# -----------------------------------------------------------------------------
# Remote state (S3 backend) — commented out until you set it up.
#
# Why: the default local backend stores terraform.tfstate on your machine.
# For anything beyond a personal experiment — and especially on a team —
# keep state in S3 with locking via DynamoDB so applies don't corrupt state.
#
# Setup (one time, ~2 minutes):
#   1. Create the state bucket (name must be globally unique):
#        aws s3api create-bucket --bucket my-terraform-state-123456 \
#          --region us-east-1
#        aws s3api put-bucket-versioning --bucket my-terraform-state-123456 \
#          --versioning-configuration Status=Enabled
#        aws s3api put-bucket-encryption --bucket my-terraform-state-123456 \
#          --server-side-encryption-configuration \
#          '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
#   2. Create the lock table:
#        aws dynamodb create-table --table-name terraform-locks \
#          --attribute-definitions AttributeName=LockID,AttributeType=S \
#          --key-schema AttributeName=LockID,KeyType=HASH \
#          --billing-mode PAY_PER_REQUEST --region us-east-1
#   3. Uncomment the backend block below, fill in your bucket name, and run:
#        terraform init -migrate-state
# -----------------------------------------------------------------------------

# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-123456" # <-- replace with your bucket
#     key            = "devops-portfolio/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }
