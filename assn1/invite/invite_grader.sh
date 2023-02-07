#!/bin/bash

uid=$1

# define test case file and expected output file
test=test.csv
expected=eo.csv

# declare counter variables
month_num=0
score=0
line_num=0


months=( "January" "February" "March" "April" "May" "June" "July" "August" "September" "October" "November" "December" )



# find max line number in each given text file
max_eo="$( awk 'END { print NR }' $expected )"
echo ---------- Invite -----------
while [ $(($max_eo - $line_num)) -gt 0 ]; do
        # jump to the current line number so we dont have to go through the whole file every time
        tail -n $(($max_eo - $line_num)) < $expected > output_short.csv

        curr_month=${months[$month_num]}
        ((month_num=month_num+1))

        out_count=0
        while IFS= read -r line; do
            if [ "$line" == "--" ]; then
                ((out_count=out_count + 1))
                break
            fi
            echo "$line" >> one_test_out.csv
            ((out_count=out_count + 1))
        done < output_short.csv
        ((line_num=line_num+out_count))
        rm output_short.csv

        ./invite.sh $curr_month $test >> student_out.csv

        # compare student output and expected output
        if  cmp -s student_out.csv one_test_out.csv; then
            echo "$curr_month: Passed"
            ((score=score+1))
        else
            echo "$curr_month: Failed"
            echo Expected output:
            cat one_test_out.csv
            echo Student output:
            cat student_out.csv
            echo  
        fi
        
        # clear temp files
        rm student_out.csv
        rm one_test_out.csv
done

echo -----------------------------
echo "Score: $score/12"
echo "$score/12" >> ../"$uid"_scores.txt
