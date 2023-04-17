#!/bin/bash

uid=$1
expected=eo.txt
score=0

echo ---------- Git ------------

# get current loc so we can come back
here=$(pwd)

# cant clone a new repo inside a repo so gna go to root
cd ~

git clone -q https://github.com/chadakeng/hello-world.git
cd ./hello-world
cp $here/git.sh .

./git.sh >> student_out.txt
if cmp -s ./student_out.txt $here/$expected; then
    ((score=score+1))
    echo git: Passed
else
    echo git: Failed
    echo "ST: "
    cat student_out.txt
    echo "EO: "
    cat $here/$expected
fi

echo "Score: $score/1"
echo -----------------------------
echo "$score/1" >> "$here"/../"$uid"_scores.txt

rm ./git.sh
rm student_out.txt
echo y | rm -r ./.git
rm -r ../hello-world
cd "$here"