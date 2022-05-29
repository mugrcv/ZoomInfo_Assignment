#!/bin/bash

aws ecr describe-repositories  --repository-names $1 --region us-east-1 2>&1 > /dev/null
status=$?
if [[ ! "${status}" -eq 0 ]]; then
    aws ecr create-repository --repository-name $1 --region us-east-1
fi
