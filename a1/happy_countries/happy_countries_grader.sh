#!/bin/bash

uid=$1

expected=eo.txt
score=0

./happy_countries.sh >> student_out.txt
echo ------ Happy Countries ------
if  cmp -s student_out.txt eo.txt; then
    echo "Passed"
    ((score=score+10))
else
    echo "Failed"
    echo Expected output:
    cat $expected
    echo Student output:
    cat student_out.txt
    echo  
fi
rm student_out.txt

echo "Score: $score/10"
echo -----------------------------
echo "$score/10" >> ../"$uid"_a1_scores.txt
