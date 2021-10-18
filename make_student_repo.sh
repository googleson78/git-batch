#!/bin/bash

set -e
set -u

if [[ $# != 1 ]]
then
  echo "You need to pass exactly one user."
  exit 127
fi

if [[ -z "${GITHUB_TOKEN}" ]]
then
  echo GITHUB_TOKEN should be set to a github personal access token.
  exit 2
fi

user="${1}"
repo_name="fp-lab-2021-22-tasks-${user}"
auth_header="Authorization: token ${GITHUB_TOKEN}"

# grep here so we don't depend on jq ;/
repo_not_found=$(curl -s \
  -H "Accept: application/vnd.github.v3+json" \
  -H "${auth_header}" \
  "https://api.github.com/repos/googleson78/$repo_name" | grep -o "Not Found" || true)

if [[ "${repo_not_found}" != "Not Found" ]]
then
  echo "The repository for ${user} already exists."
  exit 3
fi

echo Making "${repo_name}"

curl \
  -X POST \
  -H "Accept: application/vnd.github.v3+json" \
  -H "${auth_header}" \
  -d "{ \"name\":\"${repo_name}\",
        \"private\": true
      }" \
  https://api.github.com/user/repos \
  &> /dev/null

echo Made "${repo_name}"

# TODO: if user invitation fails here we should delete the repo
curl \
  -X PUT \
  -H "Accept: application/vnd.github.v3+json" \
  -H "${auth_header}" \
  "https://api.github.com/repos/googleson78/${repo_name}/collaborators/${user}" \
  &> /dev/null

echo Invited $user
