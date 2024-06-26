# Terraform Beginner Bootcamp 2023 - week 0

## Table of Contents

- [Semantic Versioning](#semantic-verioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
  - [Considerations for Linux Distribution](#consideratrions-for-linux-distribution)
  - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    - [Shebang Considerations](#shebang-considerations)
    - [Execution Considerations](#execution-considerations)
    - [Linux Permissions Considerations](#github-lifecycle-before-init-command)
- [Gitpod Lifecycle](#gitpod-lifecycle)
- [Working Env Vars](#working-env-vars)
  - [env command](#env-command)
  - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
  - [Printing Vars](#printing-vars)
  - [Scoping of Env Vars](#scoping-of-env-vars)
  - [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  - [Terraform Registry](#terraform-registry)
  - [Terraform Console](#terraform-console)
    - [Terraform Init](#terraform-init)
    - [Terraform Plan](#terraform-plan)
    - [Terraform Apply](#terraform-apply)
    - [Terraform Destroy](#terraform-destroy)
    - [Terraform Lock Files](#terraform-lock-files)
    - [Terraform State Files](#terraform-state-files)
    - [Terraform Directory](#terraform-directory)
- [ Terraform Cloud Credentials File Path](#terraform-cloud-credentials-file-path)


## Semantic Verioning 

This project is going to utilize semantic verioning for its tagging.
[semver.org](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, eg. `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes
Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.


## Install the Terraform CLI

### Considerations with the Terraform CLI changes
The Terraform CLI installation instructions have changes due to gpg keyring changes. So we need to refer to the latest install CLI 
instruction via Terraform Documentation and change the installation script. 

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Consideratrions for Linux Distribution

This project is built against Ubunut.
Please consider checking your Linux Distribution and change accordingly to the distribution requirements.

[How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS Version:

```
$ cat /etc/os-release 
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.4 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depreciation issues we notice that bash script steps were a considerable amount of code. So we decided to create a bash script file to install Terrform CLI.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This willkeep the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) tidy.
- This allow an easier debugging and excute manually Terraform CLI install
- This will allow better portability fro other projects that need to install Terraform CLI.

### Shebang Considerations

A Shebang (prounced Sha-bang) tells the bash script which program that will interpret the script. eg. `#!/bin/bash`

ChatGPT recommended this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distributions
- Will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation to execute the bash script.
 eg. `./bin/install_terraform_cli`

If we are using a script in .gitpod.yml we need to point the script to a program to interpret it.

eg. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make the bash scripts executable we need to change Linux permissions for the file to be executable by the user.

```sh
chmod u+x ./bin/install_terraform_cli
```
alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

https://en.wikipedia.org/wiki/Chmod

### Gitpod Lifecycle

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

https://www.gitpod.io/docs/configure/workspaces/tasks


### Working Env Vars

#### env command

We can list out all Environment Variables (Env Vars) using the `env` command

We can filter specific env vars using grep eg. `env | grep AWS_`

#### Setting and Unsetting Env Vars

In the terminal we can set using `export HELLO='world`

In the terniaml we unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script we can set env without writing export eg.

```
HELLO='world'

echo $HELLO
```
#### Printing Vars

We can print an env using echo eg. `echo $HELLO`

#### Scoping of Env Vars

When you open up new bash terminals in VSCode it will not be aware of env vars that you have set in another window.

If you want to Env Vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg. `.bash_profile`


#### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secrets Storage.

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in thoes workspaces.

You can also set en vars in the `.gitpod.yml` but this can only contain non-senstive env vars.

### AWS CLI Installation

AWS CLI is installed for the project via the bash script [./bin/install_aws_cli](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```
If it is succesful you should see a json payload return that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We'll need to generate AWS CLI credits from IAM User in order to the user AWS CLI.


## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is a plugin that enables interaction with an API. This includes Cloud providers and Software-as-a-service providers.

- **Modules** are a way to make large amount of terraform code modular, portable and sharable. A Terraform module is a set of Terraform configuration files in a single directory. Even a simple configuration consisting of a single directory with one or more .tf files is a module. When you run Terraform commands directly from such a directory, it is considered the root module.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terrform commands by simply typing `terraform`

#### Terraform Init

At the start of a new terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset, about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be execute by terraform. Apply should prompt yes or no.

If we want to automatically approve an apply we can provide the auto approve flag eg. `terraform apply --auto-approve`

#### Terraform Destroy

`teraform destroy` This will destroy the created resources.

You can alos use the auto approve flag to skip the approve prompt eg. `terraform apply --auto-approve`


#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modulues that should be used with this project.

The Terraform Lock File **should be committed** to your Version Control System (VSC) eg. Github

#### Terraform State Files

`.terraform.tfstate` contain information about the current state of your infrastructure.

This file **should not be commited** to your VCS.

This file can **contain sensentive data**.

If you lose this file, you **lose knowning the state of your infrastructure**.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory
`.terraform` directory contains binaries of terraform providers.

### Bucket Naming Rules

We changed the random string to match the bucket naming rules  (lower case...)

### Terraform Cloud Credentials File Path

The temporary generated token to access the Terraform Cloud to store the terraform state file are stored in the follwing file in Gitpod:

```sh
/home/gitpod/.terraform.d/credentials.tfrc.json
```

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

The token can be generated from Trreaform Cloud:: [Terreform Cloud Token](https://app.terraform.io/app/settings/tokens?source=terraform-login)


We have automated this workaround with the following bash script [bin/generate_tfrc_credentials](We have automated this workaround with the following bash script bin/generate_tfrc_credentials)

