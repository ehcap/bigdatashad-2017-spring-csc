#!/usr/bin/env python

# return count_new_users    \t  count_lost_user
import sys
import datetime

def main():
    new_users = 0
    lost_users = 0
    for line in sys.stdin:
        lineNewUsers, lineLostUsers = line.strip().split('\t', 1)
        new_users += int(lineNewUsers)
        lost_users += int(lineLostUsers)
    print "new_users:%i\tlost_users:%i" % (new_users, lost_users)

if __name__ == '__main__':
    main()
