#!/usr/bin/python
import sys, re

DEBUG=True
#DEBUG=False

PREFIX=";; this is memory inits for %s\n;;remember that the frames are defined 0th frame at bottom\nmemory_initialization_radix=2;\nmemory_initialization_vector="

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
	global frame, frametotal, mode, PREFIX
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
	frame = frametotal - 1 #end on 0

#insert commas/end semicolons where appropirate
def increment():
	global row, col
	if col == 7:
		col = 0
	else:
		col = col+1

#figure out what char is what positional code
def encodePositional(char):
	str = ""
	status = False
	if char=="X":
		str = "11" + idents["enemy1"]	
	elif char=="Y":
		str = "11" + idents["enemy2"]	
	elif char=="Z":
		str = "11" + idents["enemy3"]	
	elif char=="P":
		str = "10" + idents["powerup1"]	
	elif char=="Q":
		str = "10" + idents["powerup2"]	
	elif char=="R":
		str = "10" + idents["powerup3"]	
	elif char=="F":
		str = "00" + idents["finish"]
	elif char=="O":
		str = "00" + idents["blank"]
	if str != "":
		status = True 
		increment()
	return status, str

# for colors we do everything in one row
def encodeColoral(char):
	if char in COLORMAP.keys():
		increment()
		return True, COLORS[COLORMAP[char]]
	else:
		return False, ""

#main
countframes()

for line in lines:
	nline = []
	status = False
	if re.search("frame", line):
		if DEBUG: output.append(" #frame: %s " % frame)
		frame = frame-1	
		row = 7 #reset row count 
	elif line != "\n": #skip blank lines
		if DEBUG: output.append(" #row: %s " % row)
		for char in list(line):
			if mode=="positional":
				status, str = encodePositional(char)
				if status: nline.append(str)		
			elif mode=="coloral":
				status, str = encodeColoral(char)
				if status: nline.append(str)
		row = row-1
	if nline != []: output.append(nline)

if DEBUG:
	for line in output:
		print line

#reformat it here for correct ordering
output.reverse()

#print it all to a .coe file
newfile = open(file+".coe", "w")
print >> newfile, PREFIX
cnt = 1
for row in output:
	global cnt	
	if type(row) == type([]): #get rid of debug output
		for column in row:
			if cnt == 64 * frametotal: #account for frames
				print >> newfile, column+";" 
			else:
				print >> newfile, column+","
			cnt = cnt + 1


