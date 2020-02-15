# s3-static-site

Handy scripts to make static site deployment easy to s3

To use, edit the values in `generate.sh` to match your use case, then run the script.  It will generate terraform files which you can then use to provision your s3 buckets and cloudfront distributions!

To provision with terraform, run:

```bash
terraform apply
```
