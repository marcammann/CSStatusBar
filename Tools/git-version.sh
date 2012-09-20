#!/usr/bin/env python

from subprocess import check_output
import plistlib
import os
import re
import pprint
import xml.dom.minidom


filepath = os.path.realpath('/'.join([os.getenv('PROJECT_DIR'), os.getenv('INFOPLIST_FILE')]))
#filepath = 'TMNGO/TMNGO-Info.plist'

#print filepath
fh = open(filepath, "r")

gitnum = check_output(["/usr/bin/env git log --pretty=format:'%ad %h %d' --abbrev-commit --date=short -1"], shell = True)
gitdesc = check_output(["/usr/bin/env git describe --tags"], shell = True)
gitref = check_output(["/usr/bin/env git rev-parse HEAD"], shell = True)
gitlasttag = check_output(["/usr/bin/env git describe --abbrev=0 --tags"], shell = True)

replacements = {
	'CSBundleGitDescription': gitdesc,
	'CSBundleGitInfo': gitnum,
	'CSBundleGitRef': gitref,
}

plist = plistlib.readPlist(filepath)

for key, value in replacements.items():
    plist[key] = value.strip()

plistlib.writePlist(plist, filepath)