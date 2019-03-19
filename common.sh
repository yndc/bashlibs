#!/bin/bash
# common.sh   
# Utilities for printing into console
# Usage     : sourced
# Author    : Jonathan Steven (yondercode@gmail.com)
# License   : MIT

function print_script() {
    printf "\033[1;32m${SCRIPT_NAME}.sh\033[0m ${1}\n"
}

function print_log() {
    printf "$(date +'[%Y-%m-%d %M:%M:%S]') $1\n"
}

function print_red() {
    printf "\033[0;31m${1}\033[0m\n"
}

function print_yellow() {
    printf "\033[0;93m${1}\033[0m\n"
}

function print_green() {
    printf "\033[1;32m${1}\033[0m\n"
}

function print_error() {
    print "\033[0;31mError\033[0m ${1}"
}