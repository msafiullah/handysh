#!/bin/sh

while getopts "abc:" opt "${set[@]}"; do
   echo "OPTIND (index of next arg)=${OPTIND}"
   echo "opt=${opt}"
   echo "OPTARG=${OPTARG}"
   printf -- '%s\n' "${set[@]}"
done

echo "shift $((OPTIND-1))"
shift $((OPTIND-1))

echo "OPTIND (index of next arg)=${OPTIND}"

printf -- '%s\n' "${@}"