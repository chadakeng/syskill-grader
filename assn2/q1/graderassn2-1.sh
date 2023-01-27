#!/bin/bash

# ---- NOTES -----
# if you are adding a new case to test.txt, make sure there is a blank line at the end of the text file.
# seperate test cases with --

# declare counter variables
line_number_input=0
line_number_eo=0
case_num=1
score=0

# compile student's program
# check for clean compile using -Werror
gcc -Werror -o vert_hist vert_hist.c

# if exit status != 0, then there is a warning/error - recompile
if [ $? -eq 0 ]; then
    ((score=score+5))
fi

# define test case file and expected output file
test_case=test.txt
expected_output=eo.txt

# find max line number in each given text file
max_test_in="$( awk 'END { print NR }' $test_case )"
max_eo="$( awk 'END { print NR }' $expected_output )"


while [ $(($max_test_in - $line_number_input)) -gt 0 ]; do
        # jump to the current line number so we dont have to go through the whole file every time
        tail -n $(($max_test_in - $line_number_input)) < $test_case > test_input_short.txt
        tail -n $(($max_eo - $line_number_eo)) < $expected_output > temp_eo.txt

        input_count=0
        eo_count=0
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

        cat one_test_input.txt | ./grader_output > grader_out.txt

        # compare student output and expected output
        if  cmp -s student_out.txt grader_out.txt; then
            echo "Case $case_num: Pass"
            ((score=score+5))
        else
            echo "Case $case_num: Fail"
            echo Expected output:
            cat shortened_output.txt
            echo Student output:
            cat student_out.txt
        fi

        # increment variables
        ((line_number_student=line_number_student + student_count))
        ((line_number_eo=line_number_eo + eo_count))
        ((case_num=case_num + 1))
        
        # clear temp files
        rm student_out.txt
        rm temp_eo.txt
        rm grader_out.txt
        rm one_test_input.txt

done

echo "Score: $score/100"
