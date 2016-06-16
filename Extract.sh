#!/bin/bash
SCRIPT=$(readlink -f $0)
ROOTDIR=`dirname $SCRIPT`

source $ROOTDIR/download.cfg

for var in `find $DESTINATION -name *.gz` ; 
do 
	file=${var##/*/}
	outputFile="${var%/*.*}"/"${file%.*}"
	gunzip -c "${var}" > "${outputFile}"
	if [ "${outputFile##*.}" = "db" ];then
		python $ROOTDIR/split.py "${outputFile}"
		rm "${outputFile}"
	fi
	rm "${var}"
done

for var2 in `find $DESTINATION -name *.db` ; 
do
	python $ROOTDIR/split.py "$var2"
	rm "$var2"
done

for var3 in `find $DESTINATION -name *.rpsl` ; 
do
	python $ROOTDIR/split.py "$var3"
	rm "$var3"
done
