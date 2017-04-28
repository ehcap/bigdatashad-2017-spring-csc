#!/usr/bin/env python

import sys

def main():
    current_key = None
    hits_per_request = 0
    for line in sys.stdin:
        request, hits = line.strip().split('\t', 1)
        if request != current_key or current_key is None :
            # output count for hits per request
            if current_key:
                print "%s\t%i" % (current_key, hits_per_request)
            hits_per_request = int(hits)
            current_key = request
        else:
            # agg hits
            hits_per_request += int(hits)

    print "%s\t%i" % (current_key, hits_per_request)


if __name__ == '__main__':
    main()
