#!/usr/bin/python
import sys, re


DEBUG=True

PREFIX=";; this is memory inits for gameboard\nmemory_initialization_radix=2;\nmemory_initialization_vector="

if len(sys.argv) > 1:
	file = sys.argv[1]
else:
	print "I need a file with frames to map!"
	sys.exit()


lines = open(file).readlines()

output = []

# [1 bit occupied][1 bit enemy or powerup][6 bit identifier]
idents ={"enemy": "000001", "powerup": "000010", "blank": "000000"}
row = 0
frame = 0
col = 0
frametotal=0

#count em so we know when we need to end
def countframes():
	global frametotal
	for each in lines:
		if re.search("frame", each):
			frametotal = frametotal + 1
	print ";processing total frames: %s" % frametotal

#insert commas/end semicolons where appropirate
def comma():
	global row, col
	cm = ""
	if row == 7 and col == 7 and frame == frametotal:
		cm = ";"
	else:
		cm = ","
	if col == 7:
		col = 0
	else:
		col = col+1
	return cm

#figure out what char is what
def encode(char):
	global output, col 
	if char=="X":
		output.append("11" + idents["enemy"] + comma())	
	elif char=="P":
		output.append("10" + idents["powerup"] + comma())	
	elif char=="O":
		output.append("00" + idents["blank"] + comma())
	#if space do nothing

#main
countframes()

for line in lines:
	if re.search("frame", line):
		if DEBUG: output.append("#frame: %s" % frame)
		frame = frame+1	
		row = 0 #reset row count 
	elif line != "\n": #skip blank lines
		if DEBUG: output.append("#row: %s" % row)
		for char in list(line):
			encode(char)		
		row = row+1

#print it all to a .coe file
newfile = open(file+".coe", "w")
print >> newfile, PREFIX
for line in output:
	print >> newfile, line
