#!/usr/bin/env bash

set -x

DOMAIN=example
TLD=com

erb \
  region=us-west-2 \
  environment=staging \
  site_sub_dom=staging \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > staging-provision.tf

erb \
  region=us-west-2 \
  environment=production \
  site_sub_dom=www \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > production-provision.tf
