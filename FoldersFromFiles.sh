#!/bin/bash

#===============================================================================
# FoldersFromFiles.sh
# By dchardin <donnie@fedoraproject.org>
#
# A simple script that I came up with during a coffee break.
#
# It is a bit volitile at the moment. A bit like a bomb. Just drop the script
# into the directory with your files and light the fuse. It will blast all of
# the files into their own directories named after each individual file
# (sans the extension by cutting off anything after the first dot in the 
# filename. It knows to ignore any directories that may already exist. It just
# acts on files.
#
#===============================================================================

#-------------------------------------------------------------------------------
# TODO
#
# - Need to write up some go-nogo logic so that you can see what will happen if
# you execute. (Giving you a chance to abort).
#
#-------------------------------------------------------------------------------




for i in $( ls ); do
	if [ -f "$i" ]; then
		name=$(echo $i | cut -f 1 -d '.')
		mkdir $name
		mv $i $name/$i
	fi
done


