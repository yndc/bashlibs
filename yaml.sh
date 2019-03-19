#!/bin/bash
# yaml.sh   
# Tools for handling YAML files
# Usage     : sourced
# Author    : Jonathan Steven (yondercode@gmail.com)
# License   : MIT

# Parses the given YAML file into KEY=VALUE format (easy to export)
# Parameters :
# $1 (required) YAML file path
# $2 Prefix of the generated variable name
# $3 Separator used for representing nested variables in the YAML. 
# For example, if this is set to __, parent.children will be parsed to parent__children
function parse_yaml_file {
   local prefix=$2
   local separator=$3
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   if [[ -z "$separator" ]]; then separator="_"; fi
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("'$separator'")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}