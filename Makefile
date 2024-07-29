.PHONY: build deploy-infra deploy-site

build:
	sam build

deploy-site:
	aws s3 sync ./resume s3://$(S3_BUCKET_NAME)