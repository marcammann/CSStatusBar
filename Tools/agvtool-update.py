#!/usr/bin/env python

from subprocess import check_output
import plistlib
import os

gitnum = check_output(["/usr/bin/env git log --pretty=format:'%ad %h %d' --abbrev-commit --date=short -1"], shell = True)
gitdesc = check_output(["/usr/bin/env git describe --tags"], shell = True)
gitref = check_output(["/usr/bin/env git rev-parse HEAD"], shell = True)
gitlasttag = check_output(["/usr/bin/env git describe --abbrev=0 --tags"], shell = True)

mversoutput = check_output(["/usr/bin/agvtool -noscm new-marketing-version {version}".format(version=gitlasttag)], shell = True)
versoutput = check_output(["/usr/bin/agvtool -noscm new-version -all {version}".format(version=gitdesc)], shell = True)
