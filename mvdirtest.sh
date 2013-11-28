#!/bin/sh

fnMvFiles()
{
	src_folder=$1
	dest_folder=$2
	
	ls -Ap1 "$src_folder" | grep '^.*[^/]$' | while read -r file ;
	do
		echo "mv \"${src_folder}/${file}\" \"${dest_folder}/${file}\""
	done 
}

fnMvDir()
{
	src=$1
	dest=$2
	src_basename=`basename "$src"`
	
	echo "mkdir -p \"${dest}/${src_basename}\""
	fnMvFiles "$src" "${dest}/${src_basename}"

	lsdir -R "$src" | while read -r file ;
	do
		file=`trim -f -t "${src}/" "$file"`
		file=`trim -e -t "/" "$file"`
		new_dir="${dest}/${src_basename}/${file}"
		old_dir="${src}/${file}"
		echo "mkdir -p \"$new_dir\""
		fnMvFiles "${old_dir}" "$new_dir"
		echo "rmdir \"$old_dir\""
	done 
	
	echo "rmdir \"$src\""
}

fnMvDir $1 $2

exit 0