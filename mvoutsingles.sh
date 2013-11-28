#!/bin/sh

Prog=`basename $0`

fnUsage() { echo "usage: ${Prog} dir ..." 1>&2; exit 1; }

if [ $# -eq 0 ]
	then
		fnUsage
fi

for arg in "$@"
do
	if [ -e "$arg" ] && [ $(wcdir "$arg") -eq 1 ]
		then
			echo "moveout " `echo $arg`
			file=`echo "${arg%/}"/*`
			#echo "file=$file"
			if [ -d $file ]
				then
					cp -Rf $file "$arg/.."
					if [ -e $file ]
						then
							rm -rf $file
					fi
				else
					mv -f $file "$arg/.."
			fi
	fi
	
done