import os, re, string, sys
from xml.dom import minidom

# Script for changing all the levels in a directory to a different format

path = "."
format = "hd"
if len(sys.argv) > 1:
	path = sys.argv[1]
if len(sys.argv) > 2:
	format = sys.argv[2]

searches = {
	'width' : 'tilewidth="40"',
	'height' : 'tileheight="40"',
	'image' : '<image source="tiles.png" width="256" height="256"/>'
}
replaces = {
	'hd' : {
		'width' : 'tilewidth="80"',
		'height' : 'tileheight="80"',
		'image' : '<image source="tiles-hd.png" width="512" height="512"/>'
	},
	'ipad' : {
		'width' : 'tilewidth="80"',
		'height' : 'tileheight="80"',
		'image' : '<image source="tiles-ipad.png" width="512" height="512"/>'
	},
	'ipadhd' : {
		'width' : 'tilewidth="160"',
		'height' : 'tileheight="160"',
		'image' : '<image source="tiles-ipadhd.png" width="1024" height="1024"/>'
	}
}

print "Converting files in: " + path + " to -" + format + " format"
for level in os.listdir(path):
	match = re.match("(\d+-\d+).tmx", level)
	if match:
		f = open(path + "/" + level, "r")
		xml = f.read()
		for key in searches:
			search = searches[key]
			replace = replaces[format][key]
			if string.find(xml, search):
				xml = string.replace(xml, search, replace)
			else:
				print "Unable to find " + key + " in " + level
		f = open(path + "/" + match.group(1) + "-" + format + ".tmx", "w")
		f.write(xml)
