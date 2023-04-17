#!/bin/bash

uid=$1

# unzip student's src code
zip_file=a1.zip
unzip -d student_src ./a1.zip

touch "$uid"_scores.txt
touch "$uid"_report.txt
# define file used to specify the questions and its points used in this assignment
q_p=questions_points.txt

# counter variables
score=0
ttl_score=0
questions=()
points=()

# read questions
while IFS="," read -r question pts; do
    questions+=($question)
    points+=($pts)
    ((ttl_score=ttl_score+pts))
done < $q_p

# find how many questions there are on the assignment
len=${#questions[@]}

for ((i=0; i<len; i++)); do
    cp ./student_src/${questions[$i]}.sh ./${questions[$i]}
    cd ${questions[$i]}

    # run grader of that question and store to uid_report.txt
    ./"${questions[$i]}"_grader.sh $uid >> ../"$uid"_report.txt
    rm ./${questions[$i]}.sh
    cd ..
done

# calculate final score:
index=0
weighted_score=0
while IFS="/" read -r score ttl; do
    raw="$(echo "scale=2; $score/$ttl" | bc)"
    temp=${points[$index]}
    weighted_score=$(echo "$weighted_score+$raw*10" | bc)
    ((index=index+1))
done < "$uid"_scores.txt


echo Weighted Score: "$weighted_score"/"$ttl_score"  >> "$uid"_report.txt
rm -r ./student_src
rm "$uid"_scores.txt
