#!/usr/bin/env python

import sys
import re
import datetime

def get_top_pages(date, topN):
    try:
        top_pages = []
        i=1
        with open("/home/sgerasimov/out/hw1/" + date.strftime("%Y-%m-%d") + ".metric1_top", "r") as filereader:
            for line in filereader:
                linepage, counthit = line.split('\t')
                top_pages.append(linepage)
                i +=1
                if i>topN:
                    break
        return top_pages
    except (IOError):
        top_pages=[]
        return top_pages

def main():
    topN=10
    date = datetime.datetime.today() -  datetime.timedelta(days=8)
    print get_top_pages(date, topN)



if __name__ == '__main__':
    main()

