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
	src_basename=$3
	
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

Src=$1
Dest=$2
SrcBasename=`basename "$Src"`
DestPath="${Dest}/${SrcBasename}"

if [ -e $DestPath ]
then
	#folder with same name already exists
	#move to tmp folder first
	fnMvDir "$Src" "$Dest" "tmp"
	#overwrite folder
	echo "rm -rf \"${DestPath}\""
	echo "mv \"${Dest}/tmp\"" "\"$DestPath\""
else
	fnMvDir "$Src" "$Dest" "$SrcBasename"
fi

exit 0


