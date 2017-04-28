#!/usr/bin/env python

# return count_new_users    \t  count_lost_user
import sys
import datetime

def main():
    if len(sys.argv) > 1:
        currDate = sys.argv[1]
    else:
        currDate = (datetime.datetime.today() + datetime.timedelta(days=-1)).strftime("%Y-%m-%d")

    lostDate = (datetime.datetime.strptime(currDate,"%Y-%m-%d") + datetime.timedelta(days=-14)).strftime("%Y-%m-%d")
    currentIP = None
    newCount = 0
    lostCount =0
    indLostUser = 0
    for line in sys.stdin:
        lineIP, lineDate, lineCount = line.strip().split('\t', 2)
        # IF new IP then return current stat and change all counts
        if currentIP != lineIP or currentIP is None:
            # User changed.
            if currentIP and indLostUser==1:
                #It mean then current user changed and previous user had last visit date X-13
                lostCount +=1
                indLostUser = 0
                #print "Lost %s\t%s" % (lineIP, lineDate)
            elif currentIP and lineDate == currDate:
                #Its new user
                newCount += 1
                #print "New %s\t%s" % (lineIP, lineDate)
            elif currentIP and lineDate == lostDate:
                #Its lost user possible
                indLostUser=1
            else:
                indLostUser = 0
            currentIP = lineIP
    if indLostUser == 1:
        lostCount += 1
    print "%i\t%i" % (newCount, lostCount)

if __name__ == '__main__':
    main()
