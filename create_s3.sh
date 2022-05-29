if aws s3 ls s3://terraform-statefiles-vivek --region us-east-1 2>&1 | grep -q 'An error occurred'
then
    echo "bucket does not exist or permission error."
    echo "create bucket"
    aws s3api create-bucket --bucket terraform-statefiles-vivek  --region us-east-1 
else
    echo "bucket exist"
fi
