#!/usr/bin/python
import sys, re
pattern = re.compile("\\s+$")

for row in sys.stdin:
    row.replace("\t", "    ")
    row = pattern.sub("", row)
    print(row)

