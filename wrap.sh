# !/bin/bash

uid=$1
zip_file=$2
assn="${zip_file%.zip}"

# unzip student's src code
unzip -d student_src $zip_file

touch "$uid"_"$assn"_report.txt
# define file used to specify the questions and its points used in this assignment
q_p=questions_points.txt

# counter variables
score=0
ttl_score=0
questions=()
points=()

# read questions and store into array
while IFS="," read -r question pts; do
    questions+=($question)
    points+=($pts)
    ((ttl_score=ttl_score+pts))
done < $q_p

# find how many questions there are on the assignment
len=${#questions[@]}

for ((i=0; i<len; i++)); do
    cp ./student_src/${questions[$i]}.sh ./$assn/${questions[$i]}
    cd ./$assn/${questions[$i]}

    # run grader of that question and store to uid_assn#_report.txt
    ./"${questions[$i]}"_grader.sh $uid >> ../../"$uid"_"$assn"_report.txt
    rm ./${questions[$i]}.sh
    cd ../..
done

# calculate final score:
index=0
weighted_score=0
while IFS="/" read -r score ttl; do
    raw="$(echo "scale=2; $score/$ttl" | bc)"
    temp=${points[$index]}
    weighted_score=$(echo "$weighted_score+$raw*10" | bc)
    ((index=index+1))
done < "$assn"/"$uid"_"$assn"_scores.txt


echo Weighted Score: "$weighted_score"/"$ttl_score"  >> "$uid"_"$assn"_report.txt
rm -r ./student_src
rm "$assn"/"$uid"_"$assn"_scores.txt
