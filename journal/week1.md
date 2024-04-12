# Terraform Beginner Bootcamp 2023 - Week 1

## Root Module Structure

Our root module structure is as follows:

```
- PROJECT_ROOT
  |-- main.tf             # everything else
  |-- variables.tf        # stores the structure of input variables
  |-- terraform.tfvars    # the data variables we want to load to our Terraform project
  |-- providers.tf        # define required providers and their configuration
  |-- outputs.tf          # stores our outputs
  |-- README.md           # required for root modules

```
 

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

### Terraform Cloud Variables

In terraform we can set two kind of variables:

- Enviroment Variables - those you would set in your bash terminal eg. AWS credentials
- Terraform Variables - those that you would normally set in your tfvars file

We can set Terraform Cloud variables to be sensitive so they are not shown visibliy in the UI.

### Loading Terraform Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### var flag

We can use the `-var` flag to set an input variable or override a variable in the tfvars file eg. `terraform -var user_ud="my-user_id"`

### var-file flag

Terraform allows you to define variable files called `*.tfvars` to create a reusable file for all the variables for a project. 

[var file ](https://registry.terraform.io/providers/terraform-redhat/rhcs/latest/docs/guides/terraform-vars)

in CLI  we can provide multiple var files as input as follow:

```sh
terraform plan -var-file="variables.tfvars" -var-file="additional_variables.tfvars
```


### terraform.tfvars

This is the default file to load in terraform variables in blunk

### auto.tfvars

`auto.tfvars` is a special filename that Terraform automatically loads variable values from, if present in the current working directory. This file allows you to define default values for your variables without explicitly passing them via the command line or specifying them in your configuration files.


### order of terraform variables

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

[Variable Definition Precedence](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)

- Environment variables
- The `terraform.tfvars` file, if present.
- The `terraform.tfvars.json` file, if present.
- Any `*.auto.tfvars` or `*.auto.tfvars.json` files, processed in lexical order of their filenames.
- Any `-var` and `-var-file` options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)


## Dealing With Configuration Drift

### What happens if we lose our state file?

If you lose your statefile, you most likley have to tear down all your cloud infrastructure manually.

You can use terraform port but it won't for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`terraform import aws_s3_bucket.bucket bucket-name`

[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through ClickOps.

If we run Terraform plan it will attempt to put our infrstraucture back into the expected state fixing Configuration Drift.

## Fix using Terraform Refresh 

```sh
terraform apply -refresh-only --auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modules in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.
The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Modules Sources

Using the source we can import the module from various places eg:
- locally
- Github
- Terraform registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources)