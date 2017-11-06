#!/usr/bin/env python3

import os
import sys
import re

args = sys.argv[1:]

if len(args) != 1:
    print('Usage: {} ils'.format(os.path.basename(sys.argv[0])))
    sys.exit(1)

ils = args[0]

if not os.path.isfile(ils):
    print('"{}" is not a file'.format(ils))
    sys.exit(1)

dir_re = re.compile('^(\/[^:]+)')
coll_re = re.compile('^\s{2}C-\s+')
file_re = re.compile('^\s{2}([^/]+)')

dir = ''
for line in open(ils):
    line = line.rstrip()
    dir_match = dir_re.search(line)
    coll_match = coll_re.search(line)
    file_match = file_re.search(line)

    if dir_match:
        dir = dir_match.groups()[0]
    elif coll_match:
        continue
    elif file_match and dir:
        filename = file_match.groups()[0]
        print(os.path.join(dir, filename))
