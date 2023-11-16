# S3bucket

In this repository, I have created Terraform configurations to set up the following components:

- VPC with two instances in two different subnets
- Routing table and security group
- S3 bucket and DynamoDB table for state file locking
- Configuration to use S3 as the backend for Terraform state

This is a crucial feature in the DevOps world, as it is a best practice when working in a production environment. It allows different users to make changes within an environment, preventing others from overriding changes or duplicating creations within an organization.

## Getting Started

### Step 1:

**Note: remember to run these steps sequentially - so dont have the backend.tf file up when running 1st step because the bucket and dynamodb table needs to be created first


To set up the infrastructure, navigate to the directory containing the "main.tf" file and run the following commands in your terminal:


      terraform init
      terraform plan
      terraform apply

this will create the infarstructure specified above but will also initilise in your enviroment.

### Step 2:

Then once created you can use the "backend.tf" file to run the command below in your terminal 

      terraform init

this will then initilise the backend in your newly created s3 bucket 
