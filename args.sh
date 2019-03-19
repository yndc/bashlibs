#!/bin/bash
# args.sh
# Simple parser for command line arguments
# Usage     : sourced
# Author    : Jonathan Steven (yondercode@gmail.com)
# License   : MIT

. ./common.sh 2>/dev/null

function print_format_help() {
    echo "Commands: "
    while read -r line; do
        if [ ! -z "$line" ]; then
            printf "* \e[1m$(echo $line | cut -d',' -f1)\033[0m\t$(echo $line | cut -d',' -f2)\n"
        fi
    done <<<"$SCRIPT_POSITIONAL_ARGS"
    if [ ! -z "$SCRIPT_NAMED_ARGS" ]; then
        printf "Available flags/arguments: \n"
        while read -r line; do
            if [ ! -z "$line" ]; then
                printf "* $([ "$(echo $line | cut -d',' -f1)" == "FLAG" ] && echo "\e[1;33mFLAG\033[0m" || echo "\e[1;34mPARM\033[0m")  -$(echo $line | cut -d',' -f2)\t --$(echo $line | cut -d',' -f3) \t$(echo $line | cut -d',' -f5)$([ "$(echo $line | cut -d',' -f4)" == 1 ] && echo " \033[1;32mrequired\033[0m ")\n"
            fi
        done <<<"$SCRIPT_NAMED_ARGS"
    fi
}

# Parses input and exports the variables according to the script configuration
function parse_inputs() {
    POSITIONAL_ITERATOR=0
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
                    elif [ "$(echo $line | cut -d',' -f1)" == "PARM" ]; then
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
            ITERATOR=0
            while read -r line; do
                if [ ! -z "$line" ] && [[ "$ITERATOR" == "$POSITIONAL_ITERATOR" ]]; then
                    POSITIONAL_ITERATOR=$(($POSITIONAL_ITERATOR + 1))
                    eval "export $(echo $line | cut -d',' -f1 | xargs)=$1"
                    break
                fi
                ITERATOR=$(($ITERATOR + 1))
            done <<<"$SCRIPT_POSITIONAL_ARGS"
            shift
        fi
    done
    set -- "${POSITIONAL[@]}"
    # Check for required arguments
    while read -r line; do
        if [ ! -z "$line" ]; then
            if [[ "$(echo $line | cut -d',' -f4)" == "1" ]]; then
                VAR_NAME=$(echo $line | cut -d',' -f3 | xargs | awk '{print toupper($0)}' | tr -s '-' '_')
                if [[ -z ${!VAR_NAME} ]]; then
                    print_error "Argument --$(echo $line | cut -d',' -f3) or -$(echo $line | cut -d',' -f2) is required!" 2>/dev/null || echo "Error! Argument --$(echo $line | cut -d',' -f3) or -$(echo $line | cut -d',' -f2) is required!"
                    echo "Use --help to list available arguments"
                    exit 2
                fi
            fi
        fi
    done <<<"$SCRIPT_NAMED_ARGS"
}

parse_inputs $@
