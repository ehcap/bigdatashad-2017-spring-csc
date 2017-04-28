#!/usr/bin/env python

import sys

def main():
    SessionTime = 0
    SessionCount = 0
    SessionRequestCount = 0
    SessionSkeletonCount = 0
    for line in sys.stdin:
        lineTime, lineCount, lineRequestCount, lineSkeletonCount = line.strip().split('\t', 3)
        SessionTime += int(lineTime)
        SessionCount += int(lineCount)
        SessionRequestCount += int(lineRequestCount)
        SessionSkeletonCount += int(lineSkeletonCount)

    print "%f\t%f\t%f" % ((SessionTime/float(SessionCount)),
                          (SessionRequestCount/float(SessionCount)),
                          (SessionSkeletonCount/float(SessionRequestCount)))

if __name__ == '__main__':
    main()
