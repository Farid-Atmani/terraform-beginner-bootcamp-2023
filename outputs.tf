output "bucket_name" {
    description = "Bucket name for our website"
    value = module.terrahouse_aws.bucket_name
}


output "s3_website_endpoint" {
  description = "S3 Static Website hosting endpoint"
  value = module.terrahouse_aws.website_endpoint
}