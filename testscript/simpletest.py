import re
list = '196.223.28.31 - - [16/Nov/2015:00:00:00 +0400] "GET /photo/manage.cgi HTTP/1.1" 404 0 "-" "Mozilla/6.66"'
record_re = re.compile('([\d\.:]+) - - \[(\S+ [^"]+)\] "(\w+) ([^"]+) (HTTP/[\d\.]+)" (\d+) \d+ "([^"]+)" "([^"]+)"')
rec = re.compile('([\d\.:]+) - - \[(\S+ [^"]+)\] "(\w+) ([^"]+) (HTTP/[\d\.]+)" (\d+) (\d+) "([^"]+)" "([^"]+)"')

res = rec.match(list)

if res:
    print res.group(0)
    print res.group(1)
    print res.group(2)
    print res.group(3)
    print res.group(4)
    print res.group(5)
    print res.group(6)
    print res.group(7)
    print res.group(8)
    print res.group(9)
