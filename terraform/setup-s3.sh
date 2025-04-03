#!/bin/bash

# This script automates the creation of an S3 bucket for Terraform state files and enables versioning.

# Check if the correct number of arguments is provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <bucket-name> <region> <profile>"
    exit 1
fi

# Assign parameters to variables
BUCKET_NAME=$1
REGION=$2
PROFILE=$3

# Function to validate bucket name
validate_bucket_name() {
    if [[ ! "$1" =~ ^[a-z0-9.-]{3,63}$ ]]; then
        echo "Error: Invalid bucket name '$1'. Must be 3-63 characters long, lowercase letters, numbers, dots, or hyphens."
        exit 1
    else
        echo "Valid bucket name: $1"
    fi
}

# Function to check if bucket already exists
check_bucket_exists() {
    if aws s3api head-bucket --bucket "$1" --profile=$2 2>/dev/null; then
        echo "Error: Bucket '$1' already exists."
        exit 1
    else 
        echo "Bucket '$1' does not exist. Creating..."
    fi
}

# Validate bucket name
validate_bucket_name "$BUCKET_NAME"

# Check if bucket already exists
check_bucket_exists "$BUCKET_NAME" "$PROFILE"

# Step 1: Create the S3 bucket
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION --profile=$PROFILE

# Step 2: Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled --profile=$PROFILE

# # Step 3: Create a bucket policy for Terraform state management
# cat > policy.json <<EOL
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Action": "s3:ListBucket",
#             "Resource": "arn:aws:s3:::$BUCKET_NAME"
#         },
#         {
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Action": [
#                 "s3:GetObject",
#                 "s3:PutObject",
#                 "s3:DeleteObject"
#             ],
#             "Resource": "arn:aws:s3:::$BUCKET_NAME/*"
#         }
#     ]
# }
# EOL
# aws s3api put-bucket-policy --bucket $BUCKET_NAME --policy file://policy.json --profile=Admin

# Cleanup
rm -f policy.json

echo "Terraform state S3 bucket setup complete!"