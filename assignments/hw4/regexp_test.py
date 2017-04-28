#!/usr/bin/env python

#109.248.160.226 - - [24/Mar/2017:23:10:06 +0400] "GET / HTTP/1.1" 200 31508 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"
#109.248.160.226 - - [24/Mar/2017:23:10:06 +0400] "GET /favicon.ico HTTP/1.1" 404 0 "-" "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.99 Safari/537.36"
#91.221.162.45 - - [24/Mar/2017:23:10:06 +0400] "GET /logout HTTP/1.1" 200 3006 "-" "Mozilla/5.0 (X11; CrOS x86_64 5841.83.0) AppleWebKit/537.36 (KHTML like Gecko) Chrome/36.0.1985.138 Safari/537.36"
#176.98.176.127 - - [24/Mar/2017:23:10:06 +0400] "GET / HTTP/1.1" 200 31508 "-" "Opera/9.80 (Windows NT 5.1; U; Edition Next; en) Presto/2.11.310 Version/12.50"
#176.98.176.127 - - [24/Mar/2017:23:10:06 +0400] "GET /favicon.ico HTTP/1.1" 404 0 "-" "Opera/9.80 (Windows NT 5.1; U; Edition Next; en) Presto/2.11.310 Version/12.50"
#89.206.216.17 - - [05/Apr/2017:00:00:01 +0400] "GET /id98776 HTTP/1.1" 200 4749 "-" "Mozilla/5.0; TOB 6.11 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko"


import sys
import re
import argparse

USAGE = """

Parse STDIN 

Return string match groups delimited by tab

""".format(sys.argv[0])

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
    parser = argparse.ArgumentParser(description="A Test parser", usage=USAGE)
    parser.add_argument("--action", metavar="ACTION", choices=("stdout", "file"), required=True)
    args = parser.parse_args()

    logHeader = ["IP","reqiest_time","request","response_code","response_size","refer","ID_browser"]

    parse_log = re.compile(
        '([\d\.:]+) - - \[(\S+ [^"]+)\] "(\w+) ([^"]+) (HTTP/[\d\.]+)" (\d+) (\d+) "([^"]+)" "([^"]+)"')
    for line in sys.stdin:
        match_log = log_regexp(parse_log, line)
        print "%s\t%s\t%s\t%s\t%s\t%s\t%s" % (match_log["IP"],
                                              match_log["reqiest_time"],
                                              match_log["request"],
                                              match_log["response_code"],
                                              match_log["response_size"],
                                              match_log["refer"],
                                              match_log["ID_browser"])

if __name__ == '__main__':
    main()

