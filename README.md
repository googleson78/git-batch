# Utils for managing student stuff

## `make_student_repo.sh` - Student repo creation

Pass the github username of a user to create a private repo for them and invite them.

**Note** that if the user doesn't exist we will still create the repo.

## `git_batch.sh` - Batch git repo operations script

A script to operate on many repos at once.

Expects an argument REPOSFILE which contains a newline/space separated list of files.

Be careful! It's most certainly buggy!
