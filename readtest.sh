#!/bin/sh

if read -t 0; then
    while read line; do
        echo $line
    done
fi