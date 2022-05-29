# ZoomInfo_Assignment

## Download terrform file and keep inside vivek_assignment folder ##

wget https://releases.hashicorp.com/terraform/1.2.1/terraform_1.2.1_linux_386.zip
unzip terraform_1.2.1_linux_386.zip
cp terraform vivek_assigment/


Create access and secret key and update in main.tf or create a slave with IAM permission and can execute the code manually from slave.
Refer to bitbucket pipeline.yml file which execute both infra apply and application deployment

Pipelineoutput containers the pipeline of the each stage and the successful deployment.
