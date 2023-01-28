#!/bin/bash

# ---- NOTES -----
# couldnt figure out how to calculate decimal points so leaving it as kB x)

# variables
name=( "Low" "Medium" "Medium" "High" "High" )
mult=1
score=0

for i in ${name[@]}; do
    mkdir -p ./$mult/subfolder/subsubfolder

    # create files with desired sizes
    dd if=/dev/zero of=./$mult/subfolder/subsubfolder/output.dat status=none  bs=500k  count=$mult

    # run student's script
    temp=$(./quota.sh ./$mult/subfolder/subsubfolder)

    ((size_pr=500*mult))

    if [ "$temp" == "$i" ]; then
        ((score=score+10))
        echo $i "$size_pr"kB: Passed
    else
        # check if wrong formatting before failing test for partial credit
        lowered=$(echo $temp | awk '{print tolower($0)}')
        size=$(echo $i | awk '{print tolower($0)}')

        if [ "$lowered" == "$size" ]; then
            ((score=score+5))
            echo "$i $size_pr"kB: Wrong format, right output.
        else
            echo $i "$size_pr"kB: Failed
            echo "  ST: $temp"
            echo "  EO: $i"
        fi
    fi
    rm -r ./$mult
    ((mult=mult+1))
done

echo 
if cmp -s ~/ListOfBigDirs.txt ./eo1-1.txt; then
    ((score=score+10))
    echo ListOfBigDirs.txt: Passed
else
    echo ListOfBigDirs.txt: Failed
    echo "  ST":
    cat ~/ListOfBigDirs.txt
    echo "  EO":
    cat ./eo1-1.txt
fi

echo --------------------------
echo "Score: $score/60"
echo --------------------------
rm ~/ListOfBigDirs.txt
