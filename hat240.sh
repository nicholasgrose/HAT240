#!/bin/bash

#
# CS 240 Homework Auto-Tester
# Version 1.3.0
#
# $1 = Test File
# $2 = Test Count
# $3 = Target Score
#

if [ -z "$1" ]; then
    read -e -p "Where is the test file? " homework_test_file
else
    homework_test_file=$1
fi

if [ ! -f $homework_test_file ]; then
    echo "File not found. Please ensure you have the correct path."
    exit 1
fi

if [ -z "$2" ]; then
    read -e -p "How many times would you like to test? " test_count
else
    test_count=$2
fi

if [ $test_count -le 0 ]; then
    echo "Can't execute less than 1 time"
    exit 1
fi

if [ -z "$3" ]; then
    target_score=100
else
    target_score=$3
fi

tests_failed=0
minimum_score=100
minimum_score_failure=0

if [ -d test_failures ]; then
    rm -rf test_failures/*
else
    mkdir -p test_failures
fi
touch "test_failures/failures.txt"

cd test_failures

bar="=============================="
bar_length=${#bar}
echo

for i in `seq 1 $test_count`; do
    mkdir "failure$tests_failed"
    
    # move into test failed and copy test file
    cd "failure$tests_failed"

    # execute and calculate score
    $(../../$homework_test_file > ./test_output.txt)
    score=$(cat test_output.txt | grep "total score" | grep -E -o "[0-9]+")

    if [ $score -eq $target_score ] || [ $score -gt $target_score ]; then
        cd ..
	rm -rf "failure$tests_failed"
    else
        echo "Failure$tests_failed: $score" >> "../failures.txt"

        if [ $score -lt $minimum_score ]; then
            minimum_score=$score;
            minimum_score_failure=$tests_failed;
        fi

        tests_failed=$((tests_failed + 1))
	cd ..
    fi
    n=$(((i)*bar_length / test_count))
    printf "\r[%-${bar_length}s] #%d" "${bar:0:n}" $((i))
   
done

echo
echo
echo "$tests_failed tests failed!"

if [ $tests_failed = 0 ]; then
    cd ..
    rm -rf test_failures
else
    echo "Lowest Score: $minimum_score in failure$minimum_score_failure"
fi

exit 0
