#!/usr/bin/env python

import sys

def main():
    currentIP = None
    currentDate = None
    currentHitCount = 0
    for line in sys.stdin:
        lineIP, lineDate, lineCount = line.strip().split('\t', 2)
        #IF new IP then return current stat and change all counts
        if currentIP != lineIP or currentIP is None:
            # User changed.
            if currentIP:
                print "%s\t%s\t%i" % (currentIP, currentDate, currentHitCount)
            currentIP = lineIP
            currentDate = lineDate
            currentHitCount = int(lineCount)
        else:
            #Current user but can occured new date
            if currentDate <> lineDate:
                #Its new user session
                print "%s\t%s\t%i" % (currentIP, currentDate, currentHitCount)
                currentDate = lineDate
                currentHitCount = int(lineCount)
            else:
                currentHitCount += int(lineCount)
    print "%s\t%s\t%i" % (currentIP, currentDate, currentHitCount)

if __name__ == '__main__':
    main()
