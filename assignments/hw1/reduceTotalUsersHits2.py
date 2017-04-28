#!/usr/bin/env python

import sys


def main():
    current_key = None
    users= 0
    hits = 0
    for line in sys.stdin:
        hit_line, user_line = line.strip().split('\t', 1)
        # count for total_hits
        hits = hits + int(hit_line)
        users = users + int(user_line)

    print "%i\t%i" % (hits, users)


if __name__ == '__main__':
    main()
