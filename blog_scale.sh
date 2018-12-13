#!/usr/bin/env bash

DEPLOYMENT=$1
SCALING_FACTOR=$2

ansible-playbook -vv playbooks/scale.yml \
    -i local.inventory \
    -e "input_file=${PWD}/input/${DEPLOYMENT}.yml" \
    -e "scaling_factor=${SCALING_FACTOR}"