# Infrastructure as Code

All the terraform files for Breaking Bad graduation job.

To use this code change the following:

in terraform.tfvars:
    - set your GCP project id

In vpc.tf:
    - Download a json-key from your GCP account, add it to your repo and specify the file in "credentials" in the vpc-tf file.

In Github:
    - You need to add a GCP-KEY secret. This secret is the same as you downloaded and added to your repo. Remember to not to check it in to your github repo. It should not be public.