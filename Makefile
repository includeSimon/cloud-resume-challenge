.PHONY: build deploy-infra deploy-site

build:
	sam build

deploy-site:
	aws-vault exec simon --no-session -- aws s3 sync ./resume s3://$(S3_BUCKET_NAME)