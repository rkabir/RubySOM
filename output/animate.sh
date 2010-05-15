#!/bin/bash

authors="Kjetil Valle <kjetil.valle@gmail.com>"
version=0.2

# default values
pref=''
ext='png'
outfile='out'
delay=20
fdelay=0

# handle arguments
args=("$@")
for (( i = 0 ; i < ${#args[@]} ; i++ ))
do
	case ${args[$i]} in
		'-help') 
			echo
			echo "  Simple script for creating animated GIFs using compare."
		    echo
		    echo "  Usage: ./animate.sh [options]"
		    echo
		    echo "  Options:"
		    echo "   -help               display this message"
		    echo "   -ext ARG            file extension for input images (default: $ext)"
		    echo "   -pref ARG           filename prefix for input files"
		    echo "   -out ARG            name of output GIF (default: $outfile)"
		    echo "   -delay ARG          delay between frames (default: $delay)"
		    echo "   -delay-first ARG    additional delay for first frame (default: $fdelay)"
		    echo
		    echo "  Written by $authors"
		    echo "  Version $version"
		    echo
		    exit 0 
			;;
		'-ext') 
			let "i += 1"
			ext=${args[$i]}
			;;
		'-out') 
			let "i += 1"
			outfile=${args[$i]}
			;;
		'-pref') 
			let "i += 1"
			pref=${args[$i]}
			;;
		'-delay') 
			let "i += 1"
			delay=${args[$i]}
			;;
		'-delay-first') 
			let "i += 1"
			fdelay=${args[$i]}
			;;
		*) 
			echo "> Error: could not recognize option: '${args[$i]}'"
			exit 1
			;;
	esac
done

# additional pause for first frame
firstdelay=''
if [ $fdelay -gt 0 ]; then
	first=$( ls | grep --perl-regexp "^$pref(0*)1.$ext")
	firstdelay="-delay $fdelay $first"
	if [ -z $first ]; then 
		echo "> Error: Could not find file for first frame"
		exit 1
	fi
fi

# create gif
echo -n "> Creating GIF.."
convert -loop 0 $firstdelay -delay $delay $pref*.$ext $outfile.gif
if [ $? -eq 0 ]; then
    echo " done"
else
    echo "> Error: Could not create GIF"
fi

