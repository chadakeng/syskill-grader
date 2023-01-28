#!/bin/bash

# variables
name=( "Low" "Medium" "High" )
exp=0
score=0

# create files with desired sizes

for i in ${name[@]}; do
    mkdir $i
    dd if=/dev/zero of=./$i/output.dat status=none  bs=500k  count=$((2 ** exp))

    temp=$(./quota.sh "$i")

    if [ "$temp" == "$i" ]; then
        ((score=score+10))
        echo $i: Passed
    else
        echo $i: Failed
    fi
    ((exp=exp+1))
    rm -r $i
done

echo --------------------------
echo "Score: $score/30"
echo --------------------------
