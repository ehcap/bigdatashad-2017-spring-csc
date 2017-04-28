#!/usr/bin/env python

import sys

def main():
    currentIP = None
    currentRequest = None
    countDistinctRequest = 0
    firstSessTime = 0
    currentSessTime=0
    currentSessHitCount = 0
    for line in sys.stdin:
        lineIP, lineTime, lineRequest = line.strip().split('\t', 2)
        #IF new IP then returnt current stat and change all counts
        if currentIP != lineIP or currentIP is None:
            # User changed.
            if currentIP:
                print "%s\t%i\t%i" % (currentIP, (currentSessTime - firstSessTime), currentSessHitCount)
            currentIP = lineIP
            currentRequest = lineRequest
            firstSessTime = int(lineTime)
            currentSessTime = int(lineTime)
            currentSessHitCount = 1
        else:
            #Current user but can occured new user session
            if (int(lineTime)-firstSessTime)>(30*60):
                #Its new user session
                print "%s\t%i\t%i" % (currentIP, (currentSessTime - firstSessTime), currentSessHitCount)
                currentRequest = lineRequest
                currentSessTime = int(lineTime)
                firstSessTime = int(lineTime)
                currentSessHitCount = 0
            else:
                #sum counts
                currentSessTime = int(lineTime)
                #check distinct request
                #if currentRequest != lineRequest :
                #Will be counting ALL hit. Without analyzed distinct and type of request/
                currentSessHitCount += 1
    print "%s\t%i\t%i" % (currentIP, (currentSessTime - firstSessTime), currentSessHitCount)

if __name__ == '__main__':
    main()
