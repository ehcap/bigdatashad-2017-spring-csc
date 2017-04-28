#!/usr/bin/env python

import sys


def main():
    current_key = None
    users= 0
    hits = 0
    for line in sys.stdin:
        key, value = line.strip().split('\t', 1)
        # count for total_hits
        hits = hits + int(value)

        #count distinct users
        if key != current_key:
            users = users + int(value)
            current_key = key

    #users += 1
    print "%i\t%i" % (hits, users)

if __name__ == '__main__':
    main()
