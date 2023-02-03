#!/bin/bash

git log --pretty=format:"[%cN]: %cd" --date=format-local:'%d %B %Y'

# References
# https://stackoverflow.com/questions/7853332/how-to-change-git-log-date-formats
# https://git-scm.com/docs/git-log