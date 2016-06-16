#!/bin/bash
#This is line of comment

SCRIPT=$(readlink -f $0)
ROOTDIR=`dirname $SCRIPT`

source $ROOTDIR/download.cfg

# Global variabels
DATE=`date +%Y-%m-%d`

if [[ -e $FAILEDLIST ]]; then
	rm $FAILEDLIST
fi

OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read IRR URL EXTENSION
do
	echo "Processing $IRR"
	DEST_FOLDER="$DESTINATION/$IRR"
	if ! [[ -e  $DEST_FOLDER ]]; then
		mkdir $DEST_FOLDER
	fi
	FILEDEST=`echo "$DEST_FOLDER/${IRR,,}-$DATE.$EXTENSION"`
	curl --fail -o $FILEDEST $URL || { echo "1,$IRR,$URL,$EXTENSION" >> $FAILEDLIST; }
done < $INPUT
IFS=$OLDIFS
