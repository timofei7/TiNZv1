#!/usr/bin/python
import sys, re

#DEBUG=True
DEBUG=False

PREFIX=";; this is memory inits for %s\nmemory_initialization_radix=2;\nmemory_initialization_vector="

# from http://en.wikipedia.org/wiki/Web_colors#Web-safe_colors bottom of page
COLORS = {"black":"00000000","gray":"01101110","silver":"01001001","white":"11111111","maroon":"10000000","red":"11100000",
	"purple":"01100011","fuchsia":"11100011","green":"00010100","lime":"00011100","olive":"10010000",
	"yellow":"11111100","navy":"00000001","blue":"00000011","teal":"00001010","aqua":"00011111"}
# this is what we use in the definition files
COLORMAP = {"X":"black","E":"grey","S":"silver","W":"white","M":"maroon","R":"red","P":"purple","F":"fuchsia","G":"green","L":"lime","O":"olive","Y":"yellow","N":"navy","B":"blue","T":"teal","A":"aqua"}

# [1 bit occupied][1 bit enemy or powerup][6 bit identifier]
idents ={"enemy1":"000001", "enemy2":"000010", "enemy3":"000011", "powerup1":"000100", "powerup2":"000101", "powerup3":"000110", "finish":"000111","blank": "000000"}

if len(sys.argv) > 1:
	file = sys.argv[1]
else:
	print "I need a file with frames to map!"
	sys.exit()


lines = open(file).readlines()

output = []

row = 7
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
	if row == 0 and col == 7 and frame == frametotal:
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
		output.append("11" + idents["enemy1"] + comma())	
	elif char=="Y":
		output.append("11" + idents["enemy2"] + comma())	
	elif char=="Z":
		output.append("11" + idents["enemy3"] + comma())	
	elif char=="P":
		output.append("10" + idents["powerup1"] + comma())	
	elif char=="Q":
		output.append("10" + idents["powerup2"] + comma())	
	elif char=="R":
		output.append("10" + idents["powerup3"] + comma())	
	elif char=="F":
		output.append("00" + idents["finish"] + comma())
	elif char=="O":
		output.append("00" + idents["blank"] + comma())
	#if space do nothing

# for colors we do everything in one row
def encodeColoral(char):
	global output, col
	if char in COLORMAP.keys():
		output.append(COLORS[COLORMAP[char]] + comma())
		#output.append(COLORS[COLORMAP[char]] ) #can renable old style one line output

#main
countframes()

for line in lines:
	if re.search("frame", line):
		if DEBUG: output.append(" #frame: %s " % frame)
		if mode=="DISABLEDcoloral": #add the commas between frames rather than between rows 
			if frame != 0:
				output.append(",\n")
		frame = frame+1	
		row = 7 #reset row count 
	elif line != "\n": #skip blank lines
		if DEBUG: output.append(" #row: %s " % row)
		for char in list(line):
			if mode=="positional":
				encodePositional(char)		
			elif mode=="coloral":
				encodeColoral(char)
		row = row-1

#print it all to a .coe file
newfile = open(file+".coe", "w")
print >> newfile, PREFIX
if mode=="positional" or mode =="coloral":
	for line in output:
		print >> newfile, line
elif mode=="DISABLEDcoloral": #can reanble old style single line output here
	tmp=""
	for each in output:
		tmp = tmp + each
	tmp = tmp + ";\n"  #add the final ;
	print >> newfile, tmp
