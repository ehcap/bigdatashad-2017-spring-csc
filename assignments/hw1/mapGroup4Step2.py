#!/usr/bin/env python

import sys

def main():
    SessionTime = 0
    SessionCount = 0
    SessionRequestCount = 0
    SessionSkeletonCount = 0
    for line in sys.stdin:
        lineIP, lineTime, lineSessHitCount = line.strip().split('\t', 2)
        SessionTime += int(lineTime)
        SessionCount += 1
        SessionRequestCount += int(lineSessHitCount)
        if int(lineSessHitCount) == 1:
            SessionSkeletonCount += 1

    print "%i\t%i\t%i\t%i" % (SessionTime, SessionCount, SessionRequestCount, SessionSkeletonCount)

if __name__ == '__main__':
    main()
