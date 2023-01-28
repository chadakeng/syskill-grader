#!/bin/bash

# variables
name=( "Low" "Medium" "Medium" "High" "High" )
mult=1
score=0

for i in ${name[@]}; do
    mkdir temp

    # create files with desired sizes
    dd if=/dev/zero of=./temp/output.dat status=none  bs=500k  count=$mult

    temp=$(./quota.sh "temp")
    ((size_pr=500*mult))
    if [ "$temp" == "$i" ]; then
        ((score=score+10))
        echo $i "$size_pr"kB: Passed
    else
        # check if wrong formatting before failing test for partial
        lowered=$(echo $temp | awk '{print tolower($0)}')
        size=$(echo $i | awk '{print tolower($0)}')
        if [ "$lowered" == "$size" ]; then
            echo "$i $size_pr"kB: Wrong format, right output.
            ((score=score+5))
        else
            echo $i "$size_pr"kB: Failed
        fi
    fi
    ((mult=mult+1))
    rm -r temp
done

echo --------------------------
echo "Score: $score/50"
echo --------------------------
