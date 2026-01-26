package main

import (
	"fmt"
	"net/http"
	"testing"
	"time"

	"github.com/aws/aws-sdk-go/service/elbv2"
	terratest_aws "github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/retry"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVPCBasic(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../",
	})

	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	alb_endpoint := terraform.Output(t, terraformOptions, "alb_endpoint")
	targetgroup_arn := terraform.Output(t, terraformOptions, "tg_arn")

	maxRetries := 36
	timeBetweenRetries := 5 * time.Second

	session, err := terratest_aws.NewAuthenticatedSession("ap-northeast-2")
	assert.NoError(t, err)

	svc := elbv2.New(session)

	// check target group health status via retry during 3m
	retry.DoWithRetry(t, "Checking Target Group Health", maxRetries, timeBetweenRetries, func() (string, error) {
		input := &elbv2.DescribeTargetHealthInput{
			TargetGroupArn: &targetgroup_arn,
		}

		output, err := svc.DescribeTargetHealth(input)
		if err != nil {
			return "", err
		}

		if len(output.TargetHealthDescriptions) == 0 {
			return "", fmt.Errorf("no registered target")
		}

		for _, desc := range output.TargetHealthDescriptions {
			state := desc.TargetHealth.State
			targetId := desc.Target.Id

			if *state != elbv2.TargetHealthStateEnumHealthy {
				return "", fmt.Errorf("Target %s is %s (not healthy)", *targetId, *state)
			}
		}

		return "All Target is Healthy", nil
	})

	res, err := http.Get("http://" + alb_endpoint)
	if err != nil {
		assert.NoError(t, err, "alb_endpoint should be healthy")
	} else {
		defer res.Body.Close()
		fmt.Printf("Http Get Status: %s\n", res.Status)
		assert.Equal(t, 200, res.StatusCode)
	}
}
