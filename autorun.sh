#!/usr/bin/env bash

is_sclib_imported 2> /dev/null ||
    SCLIB_PATH="/tmp/sclib.sh"
    SCLIB_GIT_RAW_URL="https://raw.githubusercontent.com/rajalokan/cloud-installer/master/scripts/sclib.sh"
    if [[ ! -f ${SCLIB_PATH} ]]; then
        wget ${SCLIB_GIT_RAW_URL} -O ${SCLIB_PATH}
    fi
    source ${SCLIB_PATH}

info_block "Bootstraping docker role"

ansible_roles_path="${HOME}/.ansible/roles"
mkdir -p ${ansible_roles_path}

role_path="${ansible_roles_path}/docker"
repo="https://github.com/rajalokan/ansible_role_docker.git"

# Ensure git is installed
is_package_installed git || install_package git

if [[ ! -d ${role_path} ]]; then
    git clone ${repo} ${role_path}
fi

# Ensure latest ansible is installed
is_package_installed ansible || info_block "ansible not installed. Exiting"

pushd ${role_path} >/dev/null
    ansible-playbook -i "localhost," -c local playbook.yaml
popd
