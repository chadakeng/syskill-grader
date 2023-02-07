#!/bin/bash

uid=$1
echo ---------- Quota ------------

# variables
name=()
score=0

# read file name
read f_name < "eo.txt"

# find max line number in each given text file
max_eo="$( awk 'END { print NR }' "eo.txt" )"
((max_eo=max_eo-1))
((ttl_score=10+max_eo*10))
tail -n$max_eo "eo.txt" >> in_out.txt

while IFS="," read -r size result; do
    mkdir -p ./$size/subfolder/subsubfolder

    # create files with desired sizes
    dd if=/dev/zero of=./$size/subfolder/subsubfolder/output.dat status=none  bs="$size"K  count=1

    # run student's script
    temp=$(./quota.sh ./$size/subfolder/subsubfolder)
    
    if [ "$temp" == "$result" ]; then
        ((score=score+10))
        echo $result "$size"kB: Passed
    else
        # check if wrong formatting before failing test for partial credit
        lowered=$(echo $temp | awk '{print tolower($0)}')
        res_low=$(echo $result | awk '{print tolower($0)}')

        if [ "$lowered" == "$res_low" ]; then
            ((score=score+5))
            echo "$result $size"kB: Wrong format, right output.
        else
            echo $result "$size"kB: Failed
            echo "  ST: $temp"
            echo "  EO: $result"
        fi
    fi
    rm -r ./$size
done < in_out.txt


# check correctness of the file created
echo 
if cmp -s ~/$f_name ./compare.txt; then
    ((score=score+10))
    echo $f_name: Passed
else
    echo $f_name: Failed
    echo "  ST":
    cat ~/$f_name
    echo "  EO":
    cat ./compare.txt
fi

echo "Score: $score/$ttl_score"
echo -----------------------------

echo "$score/$ttl_score" >> ../"$uid"_scores.txt
rm ~/$f_name
rm ./in_out.txt
