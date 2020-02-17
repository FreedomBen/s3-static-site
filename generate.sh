#!/usr/bin/env bash

set -x

DOMAIN=busyuntilbedtime
TLD=com

# Variables you can pass in to customize behavior of the template:
#
#  - site_sub_dom:  Subdomain to use for the site.  Default is 'www'
#  - site_domain:  Domain to use for the site.  Default is 'exmaple'
#  - site_tld:  TLD to use for the site.  Default is 'com'
#  - enable_cloudfront_tls:  Whether you want to use Cloudfront with TLS.  If false Cloudfront will not be used.  Default is true.
#  - preexisting_acm_cert:  Set true if you already have an ACM cert ARN that you want to use and one will not be created.  If you set the next var too the ARN will be put in the right place by the template.
#  - preexisting_acm_cert_arn:  If previous is true, this ARN will be put in the output.  If previous is true and this is empty, a comment will be put instead to help you find the correct spot.
#  - region:  AWS region to use for your stuff.  Default is 'us-east-1'
#  - is_subdomain:  If you're using a subdomain (not a naked domain) then set this true.  Default is true
#  - environment:  Environment name.  Default is 'prod'
#  - enable_logging:  Whether to enable logging on S3 and Cloudfront.  Default is true
#  - preexisting_log_bucket:  If set to true, use bucket name specified in preexisting_log_bucket for logging.  Default is false
#  - preexisting_log_bucket_name:  If you already have a log bucket and don't want one created, set to the bucket name.  If left empty a log bucket will be created for you if you set enable_logging to true
#  - enable_api:  If true, will allow CORS requests from files served by your bucket to api.<your domain>.  Default is false
#  - restrict_geo:  If true, Geo restrictions on cloudfront are used to only allow traffic from North America (pull request allowing this to be customized will be accepted).  Default is false
#  - cloudfront_price_class:  Price class to use for cloudfront.  See https://aws.amazon.com/cloudfront/pricing/ for more info.  Default is '100'.  Valid values are 100, 200, All

# Staging environment
erb \
  enable_cloudfront_tls=false \
  region=us-west-2 \
  environment=staging \
  site_sub_dom=staging \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > staging-provision.tf

# Production environment
erb \
  region=us-west-2 \
  environment=production \
  site_sub_dom=www \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > production-provision.tf
