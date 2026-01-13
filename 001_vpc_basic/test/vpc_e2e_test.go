package main

import (
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformVPCBasic(t *testing.T) {
	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./fixtures",
	})

	// defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	privateInstanceId := terraform.Output(t, terraformOptions, "private_subnet_instance")
	noInternetInstanceId := terraform.Output(t, terraformOptions, "no_internet_subnet_instance")
	region := "ap-northeast-2"
	timeout := 5 * time.Minute

	aws.WaitForSsmInstance(t, region, privateInstanceId, timeout)
	aws.WaitForSsmInstance(t, region, noInternetInstanceId, timeout)

	cmd := "curl -sI -m 10 https://www.google.com"

	privateResult, err := aws.CheckSsmCommandE(t, region, privateInstanceId, cmd, timeout)

	assert.NoError(t, err, "Private 인스턴스는 NAT를 통해 인터넷 접속이 가능합니다.")
	assert.Contains(t, privateResult.Stdout, "200")

	noInternetResult, err := aws.CheckSsmCommandE(t, region, noInternetInstanceId, cmd, timeout)

	assert.Error(t, err, "No Internet 인스턴스는 인터넷 접속에 실패합니다.")

	if noInternetResult != nil {
		assert.NotEqual(t, 0, noInternetResult.ExitCode, "인터넷이 차단되어야 합니다.")
	}
}
