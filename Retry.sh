#!/bin/bash
SCRIPT=$(readlink -f $0)
ROOTDIR=`dirname $SCRIPT`

source $ROOTDIR/download.cfg

OLDIFS=$IFS
IFS=,
[ ! -f $FAILEDLIST ] && { echo "$FAILEDLIST file not found"; exit 99; }
while read RETRIES IRR URL EXTENSION
do
	DEST_FOLDER="$DESTINATION/$IRR"
	if ! [[ -e  $DEST_FOLDER ]]; then
		mkdir $DEST_FOLDER
	fi
	((RETRIES++)) 
	FILEDEST=`echo "$DEST_FOLDER/${IRR,,}-$DATE.$EXTENSION"`
	curl --fail -o $FILEDEST $URL || { echo "$RETRIES,$IRR,$URL,$EXTENSION" >> $ROOTDIR/failed-list.temp; }
done < $FAILEDLIST
rm $FAILEDLIST
if [[ -e $ROOTDIR/failed-list.temp ]]; then
	mv $ROOTDIR/failed-list.temp $FAILEDLIST
fi
IFS=$OLDIFS