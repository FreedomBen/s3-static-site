# Set your site's info here
locals {
  name   = "example"
  tld    = "com"
  domain = "${local.name}.${local.tld}"
  region = "us-west-2"
}

data "aws_route53_zone" "domain" {
  name         = "${local.domain}."
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "www.${local.domain}"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.www.website_domain}"
    zone_id                = "${aws_s3_bucket.www.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main" {
  zone_id = "${data.aws_route53_zone.domain.zone_id}"
  name    = "${local.domain}"
  type    = "A"

  alias {
    name                   = "${aws_s3_bucket.main.website_domain}"
    zone_id                = "${aws_s3_bucket.main.hosted_zone_id}"
    evaluate_target_health = false
  }
}

# Use the data one if the log one is failing
data "aws_s3_bucket" "logs" {
  bucket = "${local.name}-logs"
}

#resource "aws_s3_bucket" "logs" {
#  bucket = "${local.name}-logs"
#  acl    = "log-delivery-write"
#}

resource "aws_s3_bucket" "www" {
  bucket = "www.${local.domain}"
  acl    = "private"

  website {
    redirect_all_requests_to = "http://${local.domain}"
  }
}

resource "aws_s3_bucket" "main" {
  bucket = "${local.domain}"
  acl    = "public-read"
  policy = <<EOF
{
  "Version":"2012-10-17",
  "Statement":[{
	"Sid":"PublicReadGetObject",
        "Effect":"Allow",
	  "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${local.domain}/*"]
    }]
}  
EOF

  logging {
    #target_bucket = "${aws_s3_bucket.logs.id}"
    target_bucket = "${data.aws_s3_bucket.logs.id}"
    target_prefix = "log/"
  }

  # Don't need these yet, but will when adding an API
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["https://api.${local.domain}"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags {
    Name        = "${local.name}"
    Environment = "prod"
  }

  website {
    index_document = "index.html"
    error_document = "404.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }
}

provider "aws" {
  version = "~> 2.6"
  region  = "${local.region}"
}

data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
