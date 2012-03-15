#!/usr/bin/env python

from subprocess import check_output
import plistlib
import os
import re

filepath = os.path.realpath('/'.join([os.getenv('PROJECT_DIR'), os.getenv('INFOPLIST_FILE')]))

fh = open(filepath, "r")

gitnum = check_output(["/usr/bin/env git log --pretty=format:'%ad %h %d' --abbrev-commit --date=short -1"], shell = True)
gitdesc = check_output(["/usr/bin/env git describe --tags"], shell = True)
gitref = check_output(["/usr/bin/env git rev-parse HEAD"], shell = True)
gitlasttag = check_output(["/usr/bin/env git describe --abbrev=0 --tags"], shell = True)

replacements = {
	'CSBundleGitDescription': gitdesc,
	'CSBundleGitInfo': gitnum,
	'CSBundleGitRef': gitref,
	'CFBundleShortVersionString': gitlasttag,
	'CFBundleVersion': gitdesc,
}

content = fh.read()
fh.close()

for key, value in replacements.items():
	pattern = re.compile(r"(<key>" + key + r"</key>\n[\t]+<string>).*?(</string>)")
	content = pattern.sub(r"\g<1>{0}\g<2>".format(value), content)

fh = open(filepath, "w")
fh.write(content)
fh.close()
