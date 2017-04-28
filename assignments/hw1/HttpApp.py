#!/usr/bin/env python
#!flask/bin/python
import argparse
import datetime
import getpass
import hashlib
import random
import struct
from flask import Flask, request, abort, jsonify

app = Flask(__name__)

def iterate_between_dates(start_date, end_date):
    span = end_date - start_date
    for i in xrange(span.days + 1):
        yield start_date + datetime.timedelta(days=i)

@app.route('/')
def index():
    return "OK!"
@app.route("/api/hw1")

def api_hw1():
    start_date = request.args.get("start_date", None)
    end_date = request.args.get("end_date", None)
    result = {}
    if start_date is None or end_date is None:
        abort(400)
    start_date = datetime.datetime(*map(int, start_date.split("-")))
    end_date = datetime.datetime(*map(int, end_date.split("-")))
    for date in iterate_between_dates(start_date, end_date):
        try:
            #with open("/home/sgerasimov/out/" + date.strftime("%Y-%m-%d") + ".metric1", "r") as filereader:
            with open("/home/sgerasimov/out/hw1/" + date.strftime("%Y-%m-%d") + ".metric1", "r") as filereader:
                line = filereader.readline()
        except (IOError):
            result[date.strftime("%Y-%m-%d")]={}
            continue
        totals = line.split('\t')
        print date
        top_pages = get_toppages(date, 10)
        #top_pages = ['1','2','3']
        result[date.strftime("%Y-%m-%d")] = {
            "total_hits": int(totals[0].strip('\n')),
            "total_users": int(totals[1].strip('\n')),
            "top_10_pages": top_pages,
        }
    return jsonify(result)

def get_toppages(date1,topN):
    top_pages = []
    i=1
    try:
        with open("/home/sgerasimov/out/hw1/" + date1.strftime("%Y-%m-%d") + ".metric1_top", "r") as filereader:
            for line in filereader:
                linepage, counthit = line.split('\t')
                top_pages.append(linepage)
                i +=1
                if i>topN:
                    break
    except (IOError):
        top_pages=[]
        return top_pages
    return top_pages

def login_to_port(login):
    """
    We believe this method works as a perfect hash function
    for all course participants. :)
    """
    hasher = hashlib.new("sha1")
    hasher.update(login)
    values = struct.unpack("IIIII", hasher.digest())
    folder = lambda a, x: a ^ x + 0x9e3779b9 + (a << 6) + (a >> 2)
    return 10000 + reduce(folder, values) % 20000


def main():
    parser = argparse.ArgumentParser(description="HW 1 Example")
    parser.add_argument("--host", type=str, default="127.0.0.1")
    parser.add_argument("--port", type=int, default=login_to_port(getpass.getuser()))
    parser.add_argument("--debug", action="store_true", dest="debug")
    parser.add_argument("--no-debug", action="store_false", dest="debug")
    parser.set_defaults(debug=False)

    args = parser.parse_args()
    app.run(host=args.host, port=args.port, debug=args.debug)


if __name__ == '__main__':
    main()