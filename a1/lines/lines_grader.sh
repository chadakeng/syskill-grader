#!/bin/bash

uid=$1

# notes: 
# < lines from first file (student) that second (expected output) doesnt have 
# > lines from second file (expected output) that first (student) doesnt have 

dir=./path1/path2
chmod +x ./lines.sh
expected=eo_lines.txt

echo ---------- Lines ------------

./lines.sh $dir >> student_out.txt
score=$(awk 'a[$0]++' student_out.txt $expected | wc -l | awk '{print $1}')
# find max lines in eo_lines.txt
count_eo="$( awk 'END { print NR }' $expected )"

diff student_out.txt $expected | grep -v -E '^[0-9]+[acd]'
echo Score: $score/$count_eo
echo -----------------------------

echo "$score/$count_eo" >> ../"$uid"_a1_scores.txt
rm student_out.txt
