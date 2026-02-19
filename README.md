# aws-deployment-terraform

my aws lab history

## Component
```
00x-name
├── resource.tf
├── output.tf
├── provider.tf
├── ...
├── README.md # about project
└── test/ # E2E test code, manual test if needed
```

## How to Deploy/Test
```shell
# init
cd 00x-name
terraform init

# deploy
terraform plan
terraform apply

# test
cd test
go test -v
```

## Tech Stack
- **Infrastructure**: Terraform, AWS (VPC, EC2, EKS, etc.)
- **Testing**: Go, Terratest, My Hand