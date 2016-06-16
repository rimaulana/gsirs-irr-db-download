import sys
import os
import re

Filein = open(sys.argv[1],"r")
job = {"route","as-set"}
Fileout = {}
lineBuff = []
name = sys.argv[1].split('.')[0]


for line in Filein:
	buff = line[:len(line)-1]
	if len(buff) > 0:
		if buff[0] != '%' or buff[0] != '#':
			lineBuff.append(buff)
	elif len(lineBuff) > 0:
		work = lineBuff[0].split(":")[0]
		if work in job:
			if work not in Fileout:
				Fileout[work] = open(name+".db"+"."+work,"w+")
				# print "created file "+work
			for item in lineBuff:
				Fileout[work].write(item+"\n")
			Fileout[work].write("\n")
		lineBuff = []
for fl in Fileout:
	Fileout[fl].close()
