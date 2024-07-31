#!/bin/bash

# Define your resources and their identifiers
declare -A resources=(
    ["aws_iam_role.iam_for_lambda"]="iam_for_lambda"
    ["aws_iam_policy.iam_policy_for_resume_project"]="arn:aws:iam::$AWS_ACCOUNT_ID:policy/aws_iam_policy_for_terraform_resume_project_policy"
    ["aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role"]="iam_for_lambda/arn:aws:iam::$AWS_ACCOUNT_ID:policy/aws_iam_policy_for_terraform_resume_project_policy"
    ["aws_lambda_function.myfunction"]="myfunction"
    ["aws_lambda_function_url.url"]="myfunction"
)

# Loop through the resources and import them
for resource in "${!resources[@]}"; do
    terraform import $resource ${resources[$resource]}
done

# Run terraform plan to verify the state
terraform plan
