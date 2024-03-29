#!/bin/bash

# ---- NOTES -----
# if you are adding a new case to test.txt, make sure there is a blank line at the end of the text file.
# seperate test cases with --
# ----------------

# define test case file and expected output file
test_case=test.txt
grader=grader_output

# declare counter variables
line_number_input=0
case_num=1
score=0

# compile student's program
# check for clean compile using -Werror
gcc -Werror -o vert_hist vert_hist.c

# if exit status != 0, then there is a warning/error - recompile
echo --------------------------
if [ $? -eq 0 ]; then
    echo Clean compile: Passed
    ((score=score+5))
else
    echo Clean compile: Failed

fi
echo --------------------------

# find max line number in each given text file
max_test_in="$( awk 'END { print NR }' $test_case )"

while [ $(($max_test_in - $line_number_input)) -gt 0 ]; do
        # jump to the current line number so we dont have to go through the whole file every time
        tail -n $(($max_test_in - $line_number_input)) < $test_case > test_input_short.txt

        input_count=0
        while IFS= read -r curr_test_case; do
            if [ "$curr_test_case" == "--" ]; then
                echo  >> one_test_input.txt
                ((input_count=input_count + 1))
                break
            fi
            echo "$curr_test_case" >> one_test_input.txt
            ((input_count=input_count + 1))
        done < test_input_short.txt
        ((line_number_input=line_number_input+input_count))

        rm test_input_short.txt
        cat one_test_input.txt | ./vert_hist > student_out.txt

        cat one_test_input.txt | ./$grader > grader_out.txt

        # compare student output and expected output
        if  cmp -s student_out.txt grader_out.txt; then
            echo "Case $case_num: Passed"
            ((score=score+10))
        else
            echo "Case $case_num: Failed"
            echo Expected output:
            cat shortened_output.txt
            echo Student output:
            cat student_out.txt
        fi

        # increment variables
        ((case_num=case_num + 1))
        
        # clear temp files
        rm student_out.txt
        rm grader_out.txt
        rm one_test_input.txt

done
echo --------------------------
echo "Score: $score/105"
echo --------------------------
