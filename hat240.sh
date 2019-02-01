#!/bin/bash

#
# CS 240 Homework Auto-Tester
# Version 1.2.0
# Courtesy of Nicholas Rose
#
# Feel free to modify and share this however you like!
#
# If you don't have permission to run whatever .sh file you decide
# to put this in, run the followng command.
#
# chmod +x auto_run_test.sh
#
# For my Windows friends, the following command will fix this script
# after you save your changes. Windows likes to use different line
# endings, so this will change them to allow for proper compilation.
#
# sed -i -e 's/\r$//' auto_run_test.sh
#

target_score=100
files_for_saving="*Bogus* *Input* *Output* *Result*"

read -e -p "Where is the test file? " homework_test_file
read -e -p "How many times would you like to test? " test_count

tests_failed=0
minimum_score=100
minimum_score_failure=0

rm -rf test_failures

mkdir -p test_failures
touch "test_failures/failures.txt"

for i in `seq 1 $test_count`; do
    $($homework_test_file > test_output.txt)
    score=$(cat test_output.txt | grep "total score" | grep -E -o "[0-9]+")

    if [ $score = $target_score ] || [ $score -gt $target_score ]; then
        rm -f $files_for_saving
    else
        mkdir "test_failures/failure$tests_failed"
        mv -f $files_for_saving "test_failures/failure$tests_failed" 2>/dev/null
        mv -f test_output.txt "test_failures/failure$tests_failed/failure_test_output.txt"

        echo "Failure$tests_failed: $score" >> "test_failures/failures.txt"

        if [ $score -lt $minimum_score ]; then
            minimum_score=$score;
            minimum_score_failure=$tests_failed;
        fi

        tests_failed=$((tests_failed + 1))
    fi

    if [ $(($test_count / 20)) -gt 0 ] && [ $(($i % ($test_count / 20))) = 0 ]; then
        printf "."
    fi
done

rm -f test_output.txt

echo
echo "$tests_failed tests failed!"

if [ $tests_failed = 0 ]; then
    rm -rf test_failures
else
    echo "Lowest Score: $minimum_score in failure$minimum_score_failure"
fi

exit 0
