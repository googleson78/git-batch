#!/usr/bin/env bash

set -e
set -u
set -o pipefail

# TODO fix the $2...
# or just rewrite in normal language
students="$(cat $2 | cut -d',' -f3)"

function remote_name()
{
  echo "$1_remote"
}

case "$1" in
  update)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: update STUDENTSFILE'
      echo 'Update repos from STUDENTSFILE.'
    else
      for student_username in ${students}
      do
        git switch "${student_username}"
        git merge main -m "$(git show --format=%B --quiet main)"
        git switch main
      done
    fi
    ;;
  pull)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: pull STUDENTSFILE'
      echo 'Use on clean tree!(?)'
    else
      for student_username in ${students}
      do
        git switch "${student_username}"
        git pull
        git switch main
      done
    fi
    ;;
  push)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: push STUDENTSFILE'
    else
      for student_username in ${students}
      do
        git push -u $(remote_name "${student_username}") "${student_username}":main
      done
    fi
    ;;
  setup)
    if [[ $# != 3 ]]
    then
      echo 'USAGE: setup STUDENTSFILE USERNAME'
    else
      host_username="${3}"
      for student_username in ${students}
      do
        if ! $(git branch --list | grep --quiet "${student_username}")
        then
          git branch "${student_username}"
          git remote add $(remote_name "${student_username}") "git@github.com:${host_username}/fp-lab-2023-24-tasks-${student_username}.git"
        fi
      done
    fi
    ;;
  delete)
    if [[ $# != 2 ]]
    then
      echo 'USAGE: delete STUDENTSFILE'
    else
      for student_username in ${students}
      do
        git branch -D "${student_username}"
        git remote remove $(remote_name "${student_username}")
      done
    fi
    ;;
  resethard)
    if [[ $# != 3 ]]
    then
      echo 'USAGE: resethard STUDENTSFILE REF'
      echo 'Runs reset --hard (targetting REF)'
    else
      for student_username in ${students}
      do
        git switch "${student_username}"
        echo "Resetting ${repo} to ${3}"
        git reset --hard "${3}"
        git switch main
      done
    fi
    ;;
  *)
    echo "Command must be one of: update, pull, push, setup, delete, resethard"
    exit 1
esac
