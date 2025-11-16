AWS VPC Infrastructure with Terraform & GitHub Actions
Automated AWS VPC infrastructure deployment using Terraform with GitHub Actions CI/CD pipeline.

Overview
This project provisions a production-ready AWS Virtual Private Cloud (VPC) infrastructure using Infrastructure as Code (IaC) principles with Terraform. Deployments are fully automated through GitHub Actions, ensuring consistent and repeatable infrastructure provisioning.

What Gets Created
VPC with configurable CIDR block (default: 10.0.0.0/16)

2 Public Subnets across multiple Availability Zones

2 Private Subnets across multiple Availability Zones

Internet Gateway for public internet access

NAT Gateway with Elastic IP for private subnet internet access

Route Tables with proper associations

High Availability setup across multiple AZs

Architecture
text
AWS Cloud
┌─────────────────────────────────────────────────────────────┐
│              VPC (10.0.0.0/16)                             │
│                                                             │
│  ┌─────────────────┐      ┌─────────────────┐              │
│  │ Public Subnet 1 │      │ Public Subnet 2 │              │
│  │  10.0.0.0/24    │      │  10.0.1.0/24    │              │
│  │    (AZ-1)       │      │    (AZ-2)       │              │
│  └────────┬────────┘      └────────┬────────┘              │
│           │                        │                       │
│           └────────┬───────────────┘                       │
│                    │                                       │
│         ┌──────────▼──────────┐                            │
│         │  Internet Gateway   │◄────Internet              │
│         └─────────────────────┘                            │
│                                                             │
│  ┌─────────────────┐      ┌─────────────────┐              │
│  │Private Subnet 1 │      │Private Subnet 2 │              │
│  │  10.0.10.0/24   │      │  10.0.11.0/24   │              │
│  │    (AZ-1)       │      │    (AZ-2)       │              │
│  └────────┬────────┘      └────────┬────────┘              │
│           │                        │                       │
│           └────────┬───────────────┘                       │
│                    │                                       │
│         ┌──────────▼──────────┐                            │
│         │    NAT Gateway      │                            │
│         └─────────────────────┘                            │
└─────────────────────────────────────────────────────────────┘
Project Structure
text
AWS-VPC-EKS/
├── 00-provider.tf                # AWS provider configuration
├── 01-vpc.tf                     # VPC resource definition
├── 02-internet-gatewat.tf        # Internet Gateway configuration
├── 03-public-private-subnet.tf   # Public and private subnet definitions
├── 04-eip.tf                     # Elastic IP for NAT Gateway
├── 05-nat-gateway.tf             # NAT Gateway configuration
├── 06-data-routetable.tf         # Route table data source
├── 07-route-associate.tf         # Route table associations
├── backend.tf                    # Terraform Cloud backend configuration
├── variables.tf                  # Input variable definitions
├── .github/
│   └── workflows/
│       └── terraform-deploy.yaml # GitHub Actions CI/CD pipeline
└── README.md                     # This file
Quick Start
Prerequisites
Before you begin, ensure you have:

AWS Account with appropriate IAM permissions

Terraform Cloud Account (free tier sufficient)

GitHub Account

Git installed locally

Required GitHub Secrets
Configure these secrets in your GitHub repository (Settings → Secrets → Actions):

Secret Name	Description	Example
AWS_ACCESS_KEY_ID	AWS Access Key	AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY	AWS Secret Key	wJalrXUtnFEMI/K7MDENG/bPx...
AWS_REGION	AWS Region	us-east-1
TF_API_TOKEN	Terraform Cloud API Token	abc123...
Installation & Deployment
Step 1: Clone the Repository
powershell
git clone https://github.com/chiamaka99346/AWS-VPC-EKS.git
cd AWS-VPC-EKS
Step 2: Configure Terraform Cloud Backend
Update backend.tf with your organization and workspace:

terraform
terraform { 
  cloud { 
    organization = "your-org-name"
    workspaces { 
      name = "your-workspace-name"
    } 
  } 
}
Step 3: Customize Variables (Optional)
Edit variables.tf to customize your infrastructure:

terraform
variable "region" {
  default = "us-east-1"
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "count-subnet" {
  default = 2
}
Step 4: Push to GitHub
powershell
git add .
git commit -m "Initial infrastructure setup"
git push origin main
GitHub Actions will automatically deploy your VPC infrastructure.

GitHub Actions Workflow
The CI/CD pipeline automatically triggers on push to main branch and executes:

Checkout Code - Clones repository

Setup Terraform - Installs Terraform 1.8.5

Configure Credentials - Sets up Terraform Cloud authentication

Terraform Init - Initializes working directory

Terraform Plan - Generates execution plan

Configure AWS - Sets up AWS credentials

Terraform Apply - Provisions infrastructure

Monitoring Deployments
Go to your GitHub repository

Click "Actions" tab

Select the latest workflow run

Monitor each step's progress and logs

Testing Your Infrastructure
Verify in AWS Console
After deployment, verify in AWS Console:

VPC Dashboard → Should see mainvpc

Subnets → Should see 4 subnets (2 public, 2 private)

Internet Gateways → Should see mainvpc-igw

NAT Gateways → Should see mainvpc-nat-gateway

Route Tables → Verify routing configuration

Using Terraform Cloud
Login to Terraform Cloud

Navigate to your workspace

Click "States" to view current infrastructure state

Click "Runs" to see deployment history

Local Development
Prerequisites
Terraform 1.8.5+

AWS CLI configured

Local Deployment
powershell
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy infrastructure
terraform destroy
Set Environment Variables (for local development)
powershell
$env:TF_VAR_aws_access_key="your-access-key"
$env:TF_VAR_aws_secret_key="your-secret-key"
Resource Details
Resource	Name	CIDR Block	Purpose
VPC	mainvpc	10.0.0.0/16	Main virtual network
Public Subnet 1	mainvpc-public-subnet-0	10.0.0.0/24	Internet-facing resources (AZ-1)
Public Subnet 2	mainvpc-public-subnet-1	10.0.1.0/24	Internet-facing resources (AZ-2)
Private Subnet 1	mainvpc-private-subnet-0	10.0.10.0/24	Internal resources (AZ-1)
Private Subnet 2	mainvpc-private-subnet-1	10.0.11.0/24	Internal resources (AZ-2)
Internet Gateway	mainvpc-igw	N/A	Public internet connectivity
NAT Gateway	mainvpc-nat-gateway	N/A	Private subnet internet access
Cost Estimation
Resource	Estimated Monthly Cost (us-east-1)
VPC	Free
Subnets	Free
Internet Gateway	Free
NAT Gateway	~$32 (+ data transfer)
Elastic IP (attached)	Free
Total	~$32-40/month
Note: NAT Gateway is the primary cost driver. Consider using NAT Instance for dev/test environments to reduce costs.

Cleanup / Destroy Infrastructure
Option 1: Via Terraform CLI (Local)
powershell
terraform destroy -auto-approve
Option 2: Via Terraform Cloud
Login to Terraform Cloud

Navigate to your workspace

Settings → Destruction and Deletion

Queue destroy plan

Option 3: Manual AWS Console
Delete in this order:

NAT Gateway

Wait 5 minutes

Release Elastic IP

Delete Subnets

Delete Internet Gateway (detach first)

Delete VPC

Security Best Practices
Never commit secrets - Use GitHub Secrets for sensitive data

Use IAM roles - Apply principle of least privilege

Enable MFA - Protect AWS root account

Rotate credentials - Change access keys every 90 days

Review IAM policies - Ensure minimum required permissions

Enable CloudTrail - Audit all AWS API calls

Use private repositories - Keep infrastructure code private

Troubleshooting
Issue: GitHub Actions fails at "Terraform Init"
Solution: Verify TF_API_TOKEN secret is correctly set and Terraform Cloud workspace exists.

Issue: "Error configuring Terraform AWS Provider"
Solution: Check AWS credentials in GitHub Secrets. Verify IAM user has required permissions.

Issue: NAT Gateway creation fails
Solution: Ensure Internet Gateway is created first. Check Elastic IP allocation limits.

Issue: Resources not visible in AWS Console
Solution: Verify you're viewing the correct AWS region (us-east-1 by default).

Documentation
Terraform AWS Provider: https://registry.terraform.io/providers/hashicorp/aws

AWS VPC Documentation: https://docs.aws.amazon.com/vpc

GitHub Actions Documentation: https://docs.github.com/actions

What's Next?
Extend this infrastructure by adding:

Amazon EKS Cluster - Managed Kubernetes

Application Load Balancer - Distribute traffic

Auto Scaling Groups - Dynamic scaling

CloudWatch Monitoring - Logs and metrics

Security Groups - Fine-grained access control

Bastion Host - Secure SSH access

VPC Flow Logs - Network traffic monitoring

VPN or Direct Connect - Hybrid cloud connectivity

Contributing
Contributions are welcome! Please follow these steps:

Fork the repository

Create a feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

Changelog
Version 1.0.0 (2025-11-16)
Initial release

VPC with public and private subnets

Internet Gateway and NAT Gateway

GitHub Actions CI/CD pipeline

Terraform Cloud integration

License
This project is licensed under the MIT License - see the LICENSE file for details.

Author
Chiamaka

GitHub: @chiamaka99346

Repository: AWS-VPC-EKS

Support
If you encounter issues:

Check the Troubleshooting section

Review GitHub Actions logs

Check Terraform Cloud run details

Open an issue in this repository
