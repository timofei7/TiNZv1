#!/usr/bin/python
import sys, re

#DEBUG=True
DEBUG=False

PREFIX=";; this is memory inits for %s\nmemory_initialization_radix=2;\nmemory_initialization_vector="

# from http://en.wikipedia.org/wiki/Web_colors#Web-safe_colors bottom of page
COLORS = {"black":"00000000","gray":"01101111","silver":"01001010","white":"11111111","maroon":"10000000","red":"11100000",
	"purple":"01100011","fuchsia":"11100011","green":"00010000","lime":"00011100","olive":"10010000",
	"yellow":"11111100","navy":"00000001","blue":"00000011","teal":"00001010","aqua":"00011111"}
# this is what we use in the definition files
COLORMAP = {"X":"black","E":"grey","S":"silver","W":"white","M":"maroon","R":"red","P":"purple","F":"fuchsia","G":"green","L":"lime","O":"olive","Y":"yellow","N":"navy","B":"blue","T":"teal","A":"aqua"}

# [1 bit occupied][1 bit enemy or powerup][6 bit identifier]
idents ={"enemy": "000001", "powerup": "000010", "blank": "000000"}

if len(sys.argv) > 1:
	file = sys.argv[1]
else:
	print "I need a file with frames to map!"
	sys.exit()


lines = open(file).readlines()

output = []

row = 0
frame = 0
col = 0
frametotal=0
mode=""

#count em so we know when we need to end
# also find what mode we should use
def countframes():
	global frametotal, mode, PREFIX
	for each in lines:
		if re.search("frame", each):
			frametotal = frametotal + 1
		elif re.search("position", each):
			mode="positional"
		elif re.search("color", each):
			mode="coloral"
	PREFIX = PREFIX % mode
	print ";processing total frames: %s" % frametotal
	print ";in mode: %s" % mode

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

#figure out what char is what positional code
def encodePositional(char):
	global output, col 
	if char=="X":
		output.append("11" + idents["enemy"] + comma())	
	elif char=="P":
		output.append("10" + idents["powerup"] + comma())	
	elif char=="O":
		output.append("00" + idents["blank"] + comma())
	#if space do nothing

# for colors we do everything in one row
def encodeColoral(char):
	global output, col
	if char in COLORMAP.keys():
		output.append(COLORS[COLORMAP[char]])

#main
countframes()

for line in lines:
	if re.search("frame", line):
		if DEBUG: output.append(" #frame: %s " % frame)
		if mode=="coloral": #add the commas between frames rather than between rows 
			if frame != 0:
				output.append(",\n")
		frame = frame+1	
		row = 0 #reset row count 
	elif line != "\n": #skip blank lines
		if DEBUG: output.append(" #row: %s " % row)
		for char in list(line):
			if mode=="positional":
				encodePositional(char)		
			elif mode=="coloral":
				encodeColoral(char)
		row = row+1

#print it all to a .coe file
newfile = open(file+".coe", "w")
print >> newfile, PREFIX
if mode=="positional":
	for line in output:
		print >> newfile, line
elif mode=="coloral":
	tmp=""
	for each in output:
		tmp = tmp + each
	tmp = tmp + ";\n"  #add the final ;
	print >> newfile, tmp
