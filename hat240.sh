#!/bin/bash

#
# CS 240 Homework Auto-Tester
# Version 1.1.2
# Courtesy of Nicholas Rose
#

target_score=100
files_for_saving="*Bogus* *Input* *Output* *Result*"

read -e -p "Where is the test file? " homework_test_file
read -e -p "How many times would you like to test? " test_count
tests_failed=0

rm -rf test_failures

mkdir -p test_failures
touch "test_failures/failures.txt"

for i in `seq 1 $test_count`; do
    $($homework_test_file > test_output.txt)
    score=$(cat test_output.txt | grep "total score")

    if [[ "$score" = *"$target_score"* ]]; then
        rm -f $files_for_saving
    else
        mkdir "test_failures/failure$tests_failed"
        mv -f $files_for_saving "test_failures/failure$tests_failed" 2>/dev/null
        mv -f test_output.txt "test_failures/failure$tests_failed/failure_test_output.txt"

        echo "Failure$tests_failed: $score" >> "test_failures/failures.txt"

        tests_failed=$((tests_failed + 1))
    fi

    if [ $(($test_count / 20)) -gt 0 ] && [ $(($i % ($test_count / 20))) = 0 ]; then
        printf "."
    fi
done

rm -f test_output.txt
printf "\n"

if [ $tests_failed = 0 ]; then
    rm -rf test_failures
fi

echo "$tests_failed tests failed!"

exit 0
