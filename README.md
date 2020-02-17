# s3-static-site

Handy scripts to make static site deployment easy to S3

To use, edit the values in `generate.sh` to match your use case, then run the script.  It will generate terraform files which you can then use to provision your S3 buckets and cloudfront distributions!

## Steps to use

_Note: You should only need to modify generate.sh with domain values and
variable tweaks.  If you find yourself modifying either the
generated terraform or the terraform erb file, it's considered a bug.
Please open an issue or send a PR!_

### Make sure erb is installed

1.  Install ruby (varies by platform.  Plenty of other sources to help)
1.  ERB usually comes with Ruby, but you might need to `gem install erb`

### Customize generate.sh

Open `generate.sh` and update the `DOMAIN` and `TLD` variables at the
top to fit your site.  You might also need to either add more calls to
`erb` if you want more environments than just staging and production.
If you want different settings per environment, you may need to change
the variables being passed in.  The comment at the top should be helpful
at knowing which variables to use.

#### Example:

Change `DOMAIN` to `DOMAIN=busyuntilbedtime` and `TLD` to `TLD=com`

### Run the generation script

Run the `generate.sh` script to render the template into usable terraform files:

```bash
./generate.sh
```

One file per environment will emerge.  Copy to wherever you keep your source code.

### Initialize terraform if necessary

From the directory with your terraform file, initialize terraform:

```bash
terraform init
```

Now run a plan and make sure you are happy with the results:

```bash
terraform plan
```

If you are, go ahead and apply:

```bash
terraform apply
```
