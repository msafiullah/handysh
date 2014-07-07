#!/bin/sh
# prepends filename to each line of the file

awk 'BEGIN {OFS=","} {print FILENAME,$0}' *
