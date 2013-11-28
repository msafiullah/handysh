#!/bin/sh

Prog=`basename $0`

fnUsage() { echo "usage: ${Prog} source_dir destination_dir" 1>&2; exit 1; }

fnError() { echo "${Prog}: ${1}: ${2}" 1>&2; exit 1; }

fnMvFiles()
{
	src_folder=$1
	dest_folder=$2
	
	ls -Ap1 "$src_folder" | grep '^.*[^/]$' | while read -r file ;
	do
		mv "${src_folder}/${file}" "${dest_folder}/${file}"
	done 
}

fnMvDir()
{
	src=$1
	dest=$2
	src_basename=$3
	
	mkdir -p "${dest}/${src_basename}"
	fnMvFiles "$src" "${dest}/${src_basename}"

	lsdir -R "$src" | while read -r file ;
	do
		file=`trim -f -t "${src}/" "$file"`
		file=`trim -e -t "/" "$file"`
		new_dir="${dest}/${src_basename}/${file}"
		old_dir="${src}/${file}"
		mkdir -p "$new_dir"
		fnMvFiles "${old_dir}" "$new_dir"
		rmdir "$old_dir"
	done 
	
	rmdir "$src"
}

if [ $# -lt 2 ]
then
	fnUsage
fi

Src=$1
Dest=$2

if [ ! -e "$Src" ]
then
	fnError "$Src" "No such file or directory"
fi

if [ ! -e "$Dest" ]
then
	fnError "$Dest" "No such file or directory"
fi

if [ ! -d "$Src" ]
then
	fnError "$Src" "Not a directory"
fi

if [ ! -d "$Dest" ]
then
	fnError "$Dest" "Not a directory"
fi

Src_basename=`basename "$src"`
Dest_path="${Dest}/${Src_basename}"
if [ -e $Dest_path ]
then
	fnMvDir "$Src" "$Dest" "tmp"
	#rm -rf $Dest
	src_dirname=`dirname "$Src"`
	mv  "${src_dirname}/tmp" "$Dest_path"
else
	fnMvDir "$Src" "$Dest" "$Src_basename"
fi

exit 0
