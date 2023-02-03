#!/bin/bash

expected=eo.txt
score=0

./happy_countries.sh >> student_out.txt

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

echo --------------------------
echo "Score: $score/10"
echo --------------------------
