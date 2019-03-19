#!/bin/bash
# args.sh   
# Simple parser for command line arguments
# Usage     : sourced
# Author    : Jonathan Steven (yondercode@gmail.com)
# License   : MIT

# Helper functions
function print() {
    printf "\033[1;32m${SCRIPT_NAME}.sh\033[0m ${1}\n"
}

function print_format_help() {
    print "Format: '${SCRIPT_NAME}.sh $([ ! -z "$SCRIPT_POSITIONAL_ARGS" ] && echo " [COMMANDS]") [ARGUMENTS]'"
    print ""
    print "Commands: "
    while read -r line; do
        if [ ! -z "$line" ]; then
            print "* \e[1m$(echo $line | cut -d',' -f1)\033[0m\t$(echo $line | cut -d',' -f2)"
        fi
    done <<<"$SCRIPT_POSITIONAL_ARGS"
    if [ ! -z "$SCRIPT_NAMED_ARGS" ]; then
        print ""
        print "Available flags/arguments: "
        while read -r line; do
            if [ ! -z "$line" ]; then
                print "* $([ "$(echo $line | cut -d',' -f1)" == "FLAG" ] && echo "\e[1;33mFLAG\033[0m" || echo "\e[1;34mARG \033[0m")  -$(echo $line | cut -d',' -f2)\t --$(echo $line | cut -d',' -f3) \t$([ "$(echo $line | cut -d',' -f4)" == 1 ] && echo "\033[1;32mrequired\033[0m ")$(echo $line | cut -d',' -f5)"
            fi
        done <<<"$SCRIPT_NAMED_ARGS"
    fi
}

# Parses input and exports the variables according to the script configuration
function parse_inputs() {
    while [[ $# -gt 0 ]]; do
        key="$1"
        if [ "$key" == "--help" ] || [ "$key" == "-h" ]; then
            print_format_help
            exit
        fi
        matched_arg=0
        while read -r line; do
            if [ ! -z "$line" ]; then
                if [ "$key" == "-$(echo $line | cut -d',' -f2)" ] || [ "$key" == "--$(echo $line | cut -d',' -f3)" ]; then
                    matched_arg=1
                    if [ "$(echo $line | cut -d',' -f1)" == "FLAG" ]; then
                        eval "export $(echo $line | cut -d',' -f3 | xargs | awk '{print toupper($0)}' | tr -s '-' '_')=1"
                        shift
                    elif [ "$(echo $line | cut -d',' -f1)" == "ARG" ]; then
                        eval "export $(echo $line | cut -d',' -f3 | xargs | awk '{print toupper($0)}' | tr -s '-' '_')=$2"
                        shift
                        shift
                    fi
                    break
                fi
            fi
        done <<<"$SCRIPT_NAMED_ARGS"
        if [ "$matched_arg" = "0" ]; then
            POSITIONAL+=("$1")
            shift
        fi
    done
    set -- "${POSITIONAL[@]}"
}

function print_error() {
    print "\033[0;31mError\033[0m ${1}"
}

parse_inputs $@