#!/bin/bash

TOP="$(pwd)";
zip_name=$1

while [ $( find . -type f -mindepth 2 | wc -l ) -gt "0" ]; do
    find . -type f -mindepth 2 -exec mv {} $TOP \;
done

 find . -type f -name "*.c" -exec zip $1 {} +

 # references
 # https://unix.stackexchange.com/questions/52814/flattening-a-nested-directory
 # https://www.geeksforgeeks.org/mindepth-maxdepth-linux-find-command-limiting-search-specific-directory/
 # https://stackoverflow.com/questions/15663607/what-is-the-best-way-to-count-find-results