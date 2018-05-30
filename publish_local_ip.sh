#!/bin/bash -ex

set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value

temp_dir=

local_ip() {
    local ip=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)
    if [[ -n $ip ]]
    then
        temp_dir=$(mktemp -d)
        echo "temp_dir=$temp_dir"
        cd $temp_dir
        local repo_github_url="github:pbukva/dummy_noob.git"
        local repo_dir="repo"
        git clone "$repo_github_url" "$repo_dir"
        cd "$repo_dir"
        local ip_file="test.txt"
        echo "ip=$ip" > "$ip_file"
        git add "$ip_file"
        git commit --amend --no-edit
        git push -f
    fi
}

local_ip

cleanup() {
    if [ -d "$temp_dir" ]
    then
        echo "Deleting the \"$temp_dir\" directory ..."
        rm -rf "$temp_dir"
        echo "Done."
    fi
}
trap cleanup 0

