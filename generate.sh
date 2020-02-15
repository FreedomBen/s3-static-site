#!/usr/bin/env bash

set -x

erb \
  region=us-west-2 \
  environment=staging \
  site_sub_dom=staging \
  site_domain=busyuntilbedtime \
  site_tld=com \
  provision.tf.erb > staging-provision.tf

erb \
  region=us-west-2 \
  environment=production \
  site_sub_dom=www \
  site_domain=busyuntilbedtime \
  site_tld=com \
  provision.tf.erb > production-provision.tf
