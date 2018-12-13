#!/usr/bin/env bash

DEPLOYMENT=$1

ansible-playbook -vv playbooks/deploy.yml --ask-become-pass \
    -i local.inventory \
    -e "input_file=${PWD}/input/${DEPLOYMENT}.yml" \
    -e "current_working_directory=${PWD}"

printf "\n\n\n"
cat .deploy_result
rm .deploy_result