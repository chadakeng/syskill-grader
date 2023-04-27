#!/bin/bash

uid=$1

# Variables
score=0

mkdir ./tester
cd ./tester

c_names=( 1 22 23 3 )

for i in 1 2 3; do
    mkdir -p ./$i/sub1
    mkdir -p ./$i/sub2/sub22 ./$i/sub2/sub23
    mkdir -p ./$i/sub3/sub33/sub333

    # make .txt files
    touch ./$i/sub1/$i.txt ./$i/sub2/sub22/test$i.txt ./$i/sub3/sub33/new$i.txt 
done

touch ./1/sub1/1.c ./2/sub2/sub22/22.c ./2/sub2/sub23/23.c ./3/sub3/sub33/sub333/3.c

# run student's script
../flatten.sh ../c_files.zip
cd ..

# ------ Grading -------
echo --------- Flatten -----------

# Check if zip file has correct name [1]
if [ -f ./c_files.zip ]; then
    unzip -q ./c_files.zip -d ./c_files
    echo Zipfile name: [1/1]
    ((score=score+1))
else
echo Zipfile name: [0/1]
    unzip -q ./*/*.zip -d ./c_files
fi

# Directories stay where they are [3]
temp=0
for i in 1 2 3; do
    if [ -d ./tester/$i/sub1 ] && [ -d ./tester/$i/sub2/sub22 ] && [ -d ./tester/$i/sub2/sub23 ] && [ -d ./tester/$i/sub3/sub33/sub333 ];then
        ((score=score+1))
        ((temp=temp+1))
    fi
done
echo Dir. location: [$temp/3]

temp=0
tempp=0
# Files are flattened correctly [13] (1 pt per file)
for i in 1 2 3; do
    if [ -f ./tester/$i.txt ]; then
        ((score=score+1))
        ((temp=temp+1))
    fi
    if [ -f ./tester/test$i.txt ]; then
        ((score=score+1))
        ((temp=temp+1))
    fi
    if [ -f ./tester/new$i.txt ]; then
        ((score=score+1))
        ((temp=temp+1))
    fi
done
# ^ continued and all .c files are zipped up [4]
for i in ${c_names[@]}; do
    if [ -f ./tester/$i.c ]; then
        ((score=score+1))
        ((temp=temp+1))
    fi
    if [ -f ./c_files/$i.c ]; then
        ((score=score+1))
        ((tempp=tempp+1))
    fi
done
echo Files flattened: [$temp/13]
echo Files zipped: [$tempp/4]


# ---- Total [21] ------

rm  ./c_files.zip
rm -r ./c_files
rm -r ./tester

echo Score: $score/21
echo -----------------------------

echo "$score/21" >> ../"$uid"_a1_scores.txt
