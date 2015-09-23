import sys, os
sys.path.append('/var/www/SiteUppity')

from bottle import Bottle, route, view, run, template, TEMPLATE_PATH

TEMPLATE_PATH.insert(0, os.path.abspath(os.path.dirname(__file__)))

import subprocess, re, json, httplib

application = Bottle()

@application.route('/')
@view('index')
def index():
    pass

@application.route('/getstatus/<host>/<path>')
@application.route('/getstatus/<host>/')
@application.route('/getstatus/<host>')
def getstatus(host, path=""):
    json1 = "{0} {1}"
    json2 = "{0} {1}"
    path = "/" + path
    try:
        conn = httplib.HTTPConnection(host, 80)
        conn.request("HEAD", path)
        res = conn.getresponse()
        json1 = json1.format(res.status, res.reason)
    except Exception as e:
        json1 = e.strerror

    try:
        conn2 = httplib.HTTPSConnection(host, 443)
        conn2.request("HEAD", path)
        res2 = conn2.getresponse()
        json2 = json2.format(res2.status, res2.reason)
    except Exception as e:
        json2 = e.strerror        

    return '{"http":"' + json1 + '","https":"' + json2 + '"}'

@application.route('/dig/<d>')
def dig(d):
    try:
        domain = str(d)
        r = subprocess.check_output(["dig", domain]).splitlines()
        return json.dumps(r)
    except Exception as e:
        return '{"SiteUppity Error":"' + e.strerror + '"}'

@application.route('/ping/<d>')
def ping(d):
    try:
        domain = str(d)
        ping = subprocess.Popen(["ping", "-n", "-c 1", domain], stdout=subprocess.PIPE, stderr=subprocess.PIPE)        
        output = ping.communicate()
        if output:
            return json.dumps(output[0].splitlines())
        else:
            return '["SiteUppity Error: Could not get ping"]'
    except subprocess.CalledProcessError:
        return '["SiteUppity Error: Could not get ping"]'

if __name__ == '__main__':
    application.run(host='127.0.0.1', port='8080')


