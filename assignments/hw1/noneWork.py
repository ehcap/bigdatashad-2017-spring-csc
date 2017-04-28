#!/usr/bin/env python

import sys

def main():
    current_key = None
    for line in sys.stdin:
        key, value = line.strip().split('\t', 1)
        print "%s\t%s" % (key, value)

if __name__ == '__main__':
    main()

