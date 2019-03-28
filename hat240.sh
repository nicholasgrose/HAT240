#!/bin/bash

version="1.5.0"
#
# CS 240 Homework Auto-Tester
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

break_on_failure=0
testing_aborted=0

command_run=0

bar="=============================="
bar_length=${#bar}
test_number=0

# Initialization Functions
function set_up_test_failures_folder {
    if [ -d test_failures ]; then
        rm -rf test_failures/*
    else
        mkdir -p test_failures
    fi
    touch "test_failures/failures.txt"
}

function print_program_header {
    echo
    printf "HAT 240 Version $version"
    help_command
    echo
}

function display_progress_bar {
    n=$(((test_number)*bar_length / test_count))
    printf "\r[%-${bar_length}s] #%d " "${bar:0:n}" $((test_number))
}

# Functions for running tests
function find_score {
    $(../../$homework_test_file > ./test_output.txt)
    score=$(cat test_output.txt | grep "total score" | grep -E -o "[0-9]+")
}

function acquire_test_output {
    mkdir "failure$tests_failed"
    cd "failure$tests_failed"

    find_score

    cd ..
}

function record_failure {
    echo "Failure$tests_failed: $score" >> "failures.txt"

    if [ $score -lt $minimum_score ]; then
        minimum_score=$score;
        minimum_score_failure=$tests_failed;
    fi

    tests_failed=$((tests_failed + 1))
}

function check_for_test_failure {
    if [ $score -eq $target_score ] || [ $score -gt $target_score ]; then
        rm -rf "failure$tests_failed"
    else
        record_failure
    fi
}

function execute_test {
    acquire_test_output

    check_for_test_failure
}

# Command Functions
function abort_testing_command {
    echo
    echo
    if [ $test_number = 1 ]; then
        printf "Testing aborted after $test_number test!"
    else
        printf "Testing aborted after $test_number tests!"
    fi
    testing_aborted=1
}

function toggle_break_on_failure_command {
    echo
    echo
    if [ $break_on_failure = 0 ]; then
        break_on_failure=1
        printf "Stopping testing on first failure."
    else
        break_on_failure=0
        printf "No longer stopping testing on first failure."
    fi
    if [ $tests_failed = 0 ]; then
        echo
        echo
    fi
}

function print_lowest_score {
    echo "Lowest score: $minimum_score in failure$minimum_score_failure"
}

function check_failure_count_command {
    echo
    echo
    echo "$tests_failed tests failed so far!"
    if [ $tests_failed -gt 0 ]; then
        print_lowest_score
    fi
    echo
}

function initialize_hat_command {
    echo
    echo
    printf "Super Secret HAT 240 Hat:\nMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM\nMMMMMMMMMMMMMMMWWWNNNNNWWWMMMMMMMMMMMMMM\nMMMMMMMMWXOdollcc:::::::ccllodxOKNMMMMMM\nMMMMMMMNd,....'''',,,,,,,,,,,,,,;co0WMMM\nMMMMMMMNo',,,,,,,,,;;;;;;::::cccc:,dWMMM\nMMMMMMMMk::'.',,',,,,,,;;;::::;;;,lXMMMM\nMMMMMMWMO::'.',,.........';:,'',,;OMMMMM\nMMWWWWWM0:;'.',,'........,:;''',,lXMMMMM\nWWWWWWWW0:;,.',,........';:,'.'',xWMMMMM\nWWWWWWWNk:;,.','........';;'..'';kMMMMMM\nWWWWKd:'';:'.','........';;'....;OMWWWMM\nWWNx'   .,;'.','........,;,.....,oOO0XWW\nWWk'   ..,;'.',.........,;'.........';OW\nWNo.  .',,,..,,.........,,..........;xXW\nWWk. ...','..''..................';o0WWW\nWWXo...........................,lx0XNWWW\nWWWNk:'....................':lx0XXNNWWWM\nWWWWWNKkdlc:,''.....'';:ldk0XNNNWWWWWWMM\nMMMWWWWMWWWNXXKK000KKXNWWWWWWWWWWWWMMMMM\nMMMMMMMMWWWWWWWWWWWWWWWMMMMMMMMMMMMMMMMM\nImage Credit: Nikodem Nijaki"
    echo
    echo
}

function help_command {
    echo
    echo
    echo "The following commands are available:"
    echo "'a' = abort testing"
    echo "'b' = toggle stop on first failure"
    echo "'c' = check failure count"
    echo "'h' = print command list"
    echo "'p' = pause testing"
    echo
}

function check_for_non_pause_commands {
    command_run=1

    if [[ "$key_press" = *"h"* ]]; then
        help_command
    elif [[ "$key_press" = *"c"* ]]; then
        check_failure_count_command
    elif [[ "$key_press" = *"b"* ]]; then
        toggle_break_on_failure_command
    elif [[ "$key_press" = *"a"* ]]; then
        abort_testing_command
    elif [[ "$key_press" = *"\`"* ]]; then
        initialize_hat_command
    else
        command_run=0
    fi
}

function pause_for_commands {
    key_press=""
    read -rs -n 1 key_press

    check_for_non_pause_commands
}

function pause_testing {
    key_press=""
    while [[ "$key_press" != *"r"* ]]; do
        pause_for_commands

        if [ $testing_aborted = 1 ]; then
            break
        fi

        if [ $command_run = 1 ]; then
            printf "Testing paused! Press 'r' at any time to resume!"
        fi
    done
}

function pause_testing_command {
    echo
    echo
    printf "Testing paused! Press 'r' at any time to resume!"

    pause_testing

    if [ $testing_aborted != 1 ]; then
        echo
        echo
    fi
}

function remove_user_input_from_screen {
    input_length=${#key_press}
    printf "%0.s " `seq 1 $input_length`
    printf "%0.s\b" `seq 1 $input_length`
}

function check_for_all_commands {
    if [[ "$key_press" = *"p"* ]]; then
        pause_testing_command
    else
        check_for_non_pause_commands
    fi
}

function run_commands_in_input_line {
    key_press=""
    read -rs -d "" -t 0.0001 key_press

    remove_user_input_from_screen

    check_for_all_commands
}

set_up_test_failures_folder
cd test_failures

print_program_header

for test_number in `seq 1 $test_count`; do
    display_progress_bar

    execute_test

    run_commands_in_input_line

    if [ $testing_aborted = 1 ]; then
        break
    fi
    if [ $break_on_failure = 1 ] && [ $tests_failed -gt 0 ]; then
        break
    fi
done

echo
echo
echo

if [ $tests_failed = 1 ]; then
    echo "$tests_failed test failed!"
else
    echo "$tests_failed tests failed!"
fi

if [ $tests_failed = 0 ]; then
    cd ..
    rm -rf test_failures
else
    print_lowest_score
fi

echo

exit 0
