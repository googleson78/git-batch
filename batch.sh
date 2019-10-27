#!/bin/bash

set -e

if [[ $# < 1 ]]
then
  echo "Pass a command at least! Also REPOSFILE should be a file with a newline seperated list of dirs."
  exit 127
fi

origdir="${PWD}"

case "$1" in
  commit)
    if [[ $# < 3 ]]
    then
      echo 'USAGE: commit REPOSFILE MESSAGE [FILE]'
      echo 'Copy and commit FILEs with MESSAGE.'
    else
      repos="${2}"
      message="${3}"
      shift 3

      for repo in $(cat "${repos}")
      do
        echo "Copying files $* into ${repo}"
        cp $* "${repo}"

        cd "${repo}"
        echo "Adding and committing in ${repo} with message ${message}"
        git add .
        git commit -m "${message}"
        cd "${origdir}"
      done
    fi
    ;;
  pull)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: pull REPOSFILE'
      echo 'Use on clean repos!'
    else
      for repo in $(cat "${2}")
      do
        cd "${repo}"
        echo "Pulling ${repo}"
        git pull --ff-only
        cd "${origdir}"
      done
    fi
    ;;
  push)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: push REPOSFILE'
    else
      for repo in $(cat "${2}")
      do
        cd "${repo}"
        echo "Pushing ${repo}"
        git push
        cd "${origdir}"
      done
    fi
    ;;
  clean)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: clean REPOSFILE'
      echo 'Runs reset --hard (targetting current branch), clean -fdx.'
    else
      for repo in $(cat "${2}")
      do
        cd "${repo}"
        echo "Cleaning ${repo}"
        git reset --hard $(git rev-parse --abbrev-ref HEAD)
        git clean -fdx
        cd "${origdir}"
      done
    fi
    ;;
  *)
    echo "Command must be one of: commit, push, pull, clean"
    exit 1
esac