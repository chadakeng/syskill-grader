#!/bin/bash

uid=$1
test_case=sample_life.txt
test_ans=life_ans.txt

# echo ---------- Life ------------

gcc -o life_grader -Wall -W -pedantic life_engine.c life_grader.c
# # if exit status != 0, then there is a warning/error - recompile
# echo --------------------------
# if [ $? -eq 0 ]; then
#     echo Clean compile: Passed
#     ((score=score+5))
# else
#     echo Clean compile: Failed
# fi
# echo --------------------------

# split sample_life.txt and life_ans.txt
# find max line number in each given text file
max_test_in="$( awk 'END { print NR }' $test_case )"
max_ans="$( awk 'END { print NR }' $test_ans )"
# counter to point to the line we're on
line_number_input=0
line_number_ans=0

while [ $(($max_test_in - $line_number_input)) -gt 0 ]; do
        # jump to the current line number so we dont have to go through the whole file every time
        tail -n $(($max_test_in - $line_number_input)) < $test_case > test_input_short.txt
        tail -n $(($max_ans - $line_number_ans)) < $test_ans > test_ans_short.txt

        input_count=0
        while IFS= read -r curr_test_case; do
            if [ -z "$curr_test_case" ]; then
                ((input_count=input_count + 1))
                break
            fi
            echo "$curr_test_case" >> one_test_input.txt
            ((input_count=input_count + 1))
        done < test_input_short.txt
        ((line_number_input=line_number_input+input_count))
        
        ans_count=0
        skip=""
        while IFS= read -r curr; do
            if [ "^" == "$curr" ] && [ -z $skip ]; then
                ((ans_count=ans_count + 1))
                skip="T"
                continue
            fi
            if [ -z $skip ]; then
                echo "$curr" >> ans_board.txt
                ((ans_count=ans_count + 1))
            fi
            if [ -z "$curr" ]; then
                ((ans_count=ans_count + 1))
                break
            fi
            if [ "$skip" ]; then
                echo "$curr" >> one_ans.txt
                ((ans_count=ans_count + 1))
            fi
        done < test_ans_short.txt 
        ((line_number_ans=line_number_ans+ans_count))

        ./life_grader one_test_input.txt ans_board.txt one_ans.txt 

        rm one_test_input.txt
        rm one_ans.txt
        rm ans_board.txt
        rm test_input_short.txt
        rm test_ans_short.txt
done
rm life_grader
# echo "Score: $score/$ttl_score"
# echo -----------------------------

# echo "$score/$ttl_score" >> ../"$uid"_scores.txt