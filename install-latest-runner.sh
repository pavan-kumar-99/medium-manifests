#!/usr/bin/env bash
set -x
runner_plat=linux
latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name') 
latest_version=$(echo ${latest_version_label:1}) 
runner_file="actions-runner-${runner_plat}-x64-${latest_version}.tar.gz" 
runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}" 
curl -O -L ${runner_url} 
tar xzf "./${runner_file}"
