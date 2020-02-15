#!/usr/bin/env bash

set -x

SUBDOMAIN=staging
DOMAIN=example
TLD=com

erb \
  region=us-west-2 \
  environment=staging \
  site_sub_dom=${SUBDOMAIN} \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > staging-provision.tf

erb \
  region=us-west-2 \
  environment=production \
  site_sub_dom=${SUBDOMAIN} \
  site_domain=${DOMAIN} \
  site_tld=${TLD} \
  provision.tf.erb > production-provision.tf
