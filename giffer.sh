#!/bin/bash


# -----------------------------------------------------------------------------
# giffer
# By dchardin <donnie@fedoraproject.org>
# -----------------------------------------------------------------------------
#
# -----------------------------------------------------------------------------
# TODO:
# 
# Need to work on error handling. Behavior is misleading when dependencies are
# not met.
#
# Need to set up some configurable options for gif size, etc.
#
#
# -----------------------------------------------------------------------------
#
#
# -----------------------------------------------------------------------------
# Instructions
# -----------------------------------------------------------------------------
#
# This script makes use of the ffmpeg libraries to break a video file into
# frames and then uses ImageMagick to build a .gif out of the frames.
# 
# Here's how it works:
#
# A directory named "giffing" is created in the ~/Videos directory.
#
# Within that directory are a few more working directories:
# frames gifs imgtemp usedvids vids
#
# First, put the videos that you want converted into the vids directory.
#
# Then, run the script.
#
# The script will first ensure that the "frames" directory is empty, then
# ffmpeg will extract the frames from the first video found in the vids
# directory and dump them into the frames directory. 
#
# Then, ImageMagick will convert the frames from the frames directory into a .gif.
#
#
# The .gif will then be moved to the gifs directory, the processed video will
# be moved to the usedvids folder. 
#
# The frames folder will then be emptied, and the script will repeat all of the
# steps above for each of the remaining videos in the vids folder.
# 
# -----------------------------------------------------------------------------




echo "checking for the existence of giffing directory"

if [ -d ~/Videos/giffing/ ] ; then
	echo "folder ~/Videos/giffing/ exists"
else
	echo "folder ~/Videos/giffing/ does not exist. Creating..."
	mkdir ~/Videos/giffing/ 
	echo "folder ~/Videos/giffing/ created."
fi


# Check for the existence of necessary subfolders


for i in frames gifs imgtemp usedvids vids ; do
	echo ".........."
	echo "checking for the existence of ~/Videos/giffing/$i"
	echo ".........."
	if [ -d ~/Videos/giffing/$i ] ; then
		echo "~/Videos/giffing/$i exists"
		echo ".........."
	else
		echo "~/Videos/giffing/$i does not exist. creating..."
		echo ".........."
		mkdir ~/Videos/giffing/$i
		echo "~/Videos/giffing/$i created"
		echo ".........."
	fi
done


# clean out the contents of the frames folder

echo "Verifying empty frames folder..."

echo ".........."

rm -rf ~/Videos/giffing/frames/*


#ensure that memory useage limit is set form ImageMagick convert program.

MAGICK_MEMORY_LIMIT=10000000 

#specify temp directory for ImageMagick convert program.

MAGICK_TMPDIR=~/Videos/giffing/imgtemp/


cd ~/Videos/giffing/vids/

for f in * ; do

	name=$(echo $f | cut -f 1 -d '.')
	
	echo "Extracting frames from $f. Please Wait..."

	ffmpeg -i $f -vf scale=640:-1:flags=lanczos,fps=5 ~/Videos/giffing/frames/ffout%09d.png &> /dev/null

	echo "Converting frames from $f. Please Wait..."

	convert -loop 0 ~/Videos/giffing/frames/ffout*.png ~/Videos/giffing/gifs/$name.gif &> /dev/null

	echo "$name.gif complete!"

	mv ~/Videos/giffing/vids/$f ~/Videos/giffing/usedvids/$f

	echo "moved $f into the usedvids folder."

	rm ~/Videos/giffing/frames/*

	echo "emptied frames folder."

done
