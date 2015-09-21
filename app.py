import sys, os
sys.path.append('/var/www/SiteUppity')

from bottle import Bottle, route, view, run, template, TEMPLATE_PATH

TEMPLATE_PATH.insert(0, os.path.abspath(os.path.dirname(__file__)))

import subprocess
import json
import httplib

application = Bottle()

@application.route('/')
@view('index')
def index():
    pass

@application.route('/getstatus/<host>/<path>')
@application.route('/getstatus/<host>/')
@application.route('/getstatus/<host>')
def getstatus(host, path=""):
    path = "/" + path
    conn = httplib.HTTPConnection(host, 80)
    conn.request("HEAD", path)
    res = conn.getresponse()
    conn2 = httplib.HTTPSConnection(host, 443)
    conn2.request("HEAD", path)
    res2 = conn2.getresponse()
    json1 = "{0} {1}".format(res.status, res.reason)
    json2 = "{0} {1}".format(res2.status, res2.reason)
    return '{"http":"' + json1 + '","https":"' + json2 + '"}'

@application.route('/dig/<d>')
def dig(d):
    domain = "{0}".format(d)
    r = subprocess.check_output(["dig", domain]).splitlines()
    return json.dumps(r)

@application.route('/ping/<domain>')
def ping(domain):
    try:
        domain_str = "{0}".format(domain)
        r = subprocess.check_output(["ping", "-c", "1", domain_str]).splitlines()
        return json.dumps(r)
    except subprocess.CalledProcessError, e:
        return '["error"]'

if __name__ == '__main__':
    application.run(host='127.0.0.1', port='8080')

