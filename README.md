# Multi-Tier Web Infrastructure on AWS (Terraform)

A modular Terraform project that provisions a production-style, three-tier web
environment on AWS: an internet-facing Application Load Balancer, containerized
app servers on ECS Fargate, and a PostgreSQL database on RDS — all inside a
custom VPC with public and private subnets across two availability zones.

## Architecture

```
                              +----------------+
                              |    Internet    |
                              +-------+--------+
                                      |
                         +------------v-------------+
                         |  Application Load        |
                         |  Balancer (public        |
                         |  subnets, 2 AZs)         |
                         +------------+-------------+
                                      |
        +-----------------------------+------------------------------+
        | AZ a (private subnet)       | AZ b (private subnet)        |
        |                             |                              |
        |  +----------------+         |  +----------------+          |
        |  | ECS Fargate    |         |  | ECS Fargate    |          |
        |  | task: nginx    +---------+  | task: nginx    |          |
        |  +----------------+         |  +----------------+          |
        |                             |                              |
        +-----------------------------+------------------------------+
                                      |
                         +------------v-------------+
                         |  RDS PostgreSQL          |
                         |  (private subnets,       |
                         |   encrypted, not public) |
                         +--------------------------+

  Outbound internet for private subnets: NAT gateway (single, in AZ a)
  DB credentials: generated + stored in AWS Secrets Manager (never in code)
  Monitoring: CloudWatch log group for containers + 3 CloudWatch alarms
```

## What it builds

| Layer | Resources |
|---|---|
| Network (`modules/vpc`) | VPC, 2 public + 2 private subnets (2 AZs), internet gateway, NAT gateway + EIP, route tables |
| Edge (`modules/alb`) | Internet-facing ALB, HTTP listener, target group, least-privilege security group (80/443 in) |
| Compute (`modules/ecs`) | ECS Fargate cluster, task definition (public `nginx:latest` image), 2 tasks in private subnets, security group allowing traffic **only from the ALB**, CloudWatch log group |
| Data (`modules/rds`) | RDS PostgreSQL 16 (`db.t3.micro`, 20 GB gp3, encrypted), DB subnet group, security group allowing 5432 **only from the ECS tasks**, master password auto-generated into Secrets Manager |
| Observability | CloudWatch log group for container logs; alarms for ALB 5xx errors, ECS CPU > 80%, RDS CPU > 80% (SNS topic + optional email) |

Security posture: no public database, no hardcoded credentials, security
groups follow least privilege (each tier only accepts traffic from the tier
above it).

## Prerequisites

- Terraform >= 1.5 ([install](https://developer.hashicorp.com/terraform/install))
- AWS CLI v2 configured with credentials that can create VPC/EC2/ECS/RDS/IAM
  resources (`aws sts get-caller-identity` should succeed)
- An AWS account where you are comfortable spending ~$75–110/month while the
  stack is up (see Cost note)

## Deploy

```bash
# 1. Clone and enter the project
git clone <this-repo> && cd terraform-aws-multi-tier-infra

# 2. Configure your variables
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars (region, project name, alert_email, ...)

# 3. Initialise providers and validate
terraform init
terraform validate

# 4. Review the plan
terraform plan

# 5. Deploy (takes ~20-30 minutes, mostly RDS provisioning)
terraform apply
```

When it finishes, Terraform prints `alb_dns_name` — open
`http://<alb_dns_name>` in a browser and you should see the nginx welcome page.

> **Remote state:** the default local backend is fine for learning. For team
> use, set up the S3 backend by following the commented instructions in
> `backend.tf`, then run `terraform init -migrate-state`.

## Verify

```bash
# ALB is serving traffic
curl -s -o /dev/null -w "%{http_code}\n" http://$(terraform output -raw alb_dns_name)

# ECS tasks are running
aws ecs list-tasks --cluster $(terraform output -raw ecs_cluster_name)

# Check the alarms exist
aws cloudwatch describe-alarms --alarm-name-prefix $(terraform output -raw ecs_cluster_name | cut -d- -f1-2)
```

## Teardown

```bash
terraform destroy
```

Type `yes` when prompted. Everything — including the database (no final
snapshot is kept, per `skip_final_snapshot = true`) — is removed. Double-check
in the AWS console that no NAT gateway or EIP was left behind.

## Cost note (rough, us-east-1, on-demand)

| Resource | ~Monthly |
|---|---|
| NAT gateway + data processing | ~$35 |
| Application Load Balancer | ~$23 |
| ECS Fargate (2 × 0.25 vCPU / 0.5 GB) | ~$15 |
| RDS db.t3.micro + 20 GB gp3 | ~$20 |
| EIP, CloudWatch logs, SNS | ~$3 |
| **Total** | **~$95/month** |

Cheapest way to run this: apply, demo, then `terraform destroy` the same day.
A single day costs roughly $3.

## Project outcomes

- Full three-tier environment (network, load balancer, containers, managed
  database, logging, alarms) provisions end-to-end with one `terraform apply`
  in **under 30 minutes** — versus days of manual console setup and
  click-ops that can't be repeated or reviewed.
- Infrastructure is codified, peer-reviewable, and destroyable: the entire
  environment can be torn down and recreated identically at any time.
