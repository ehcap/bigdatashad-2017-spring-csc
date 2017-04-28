#!/usr/bin/env python

#109.248.160.226 - - [24/Mar/2017:23:10:06 +0400] "GET / HTTP/1.1" 200 31508 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"
#109.248.160.226 - - [24/Mar/2017:23:10:06 +0400] "GET /favicon.ico HTTP/1.1" 404 0 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"
#91.221.162.45 - - [24/Mar/2017:23:10:06 +0400] "GET /logout HTTP/1.1" 200 3006 "-" "Mozilla/5.0 (X11; CrOS x86_64 5841.83.0) AppleWebKit/537.36 (KHTML like Gecko) Chrome/36.0.1985.138 Safari/537.36"
#176.98.176.127 - - [24/Mar/2017:23:10:06 +0400] "GET / HTTP/1.1" 200 31508 "-" "Opera/9.80 (Windows NT 5.1; U; Edition Next; en) Presto/2.11.310 Version/12.50"
#176.98.176.127 - - [24/Mar/2017:23:10:06 +0400] "GET /favicon.ico HTTP/1.1" 404 0 "-" "Opera/9.80 (Windows NT 5.1; U; Edition Next; en) Presto/2.11.310 Version/12.50"

import sys
import re

def log_regexp(record_log,log_line):
    line_str={}
    match_str = record_log.match(log_line)
    line_str={
        "IP": match_str.group(1),
        "reqiest_time": match_str.group(2),
        "request": match_str.group(4),
        "response_code": match_str.group(6),
        "response_size": match_str.group(7),
        "refer": match_str.group(8),
        "ID_browser": match_str.group(9),
     }
    return line_str

def main():
    if len(sys.argv) > 1:
        keyName = sys.argv[1]
    else:
        keyName = "IP"
    logHeader = ["IP","reqiest_time","request","response_code","response_size","refer","ID_browser"]
    try:
     ind_valid_param = logHeader.index(keyName)
    except (ValueError):
        print "Wring keyName in param. Available keyName:"
        print logHeader
        raise
    parse_log = re.compile(
        '([\d\.:]+) - - \[(\S+ [^"]+)\] "(\w+) ([^"]+) (HTTP/[\d\.]+)" (\d+) (\d+) "([^"]+)" "([^"]+)"')
    for line in sys.stdin:
        match_log = log_regexp(parse_log, line)
        if match_log["response_code"] == "200":
            print "%s\t%i\t" % (match_log[keyName], 1)

if __name__ == '__main__':
    main()

