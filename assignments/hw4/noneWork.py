#!/usr/bin/env python

import sys

def main():
    i =0
    for line in sys.stdin:
        print line
        i+=1
        if i>=1000:
            exit(1)

if __name__ == '__main__':
    main()

