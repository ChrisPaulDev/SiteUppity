import sys, os
sys.path.append('/var/www/SiteUppity')

from bottle import Bottle, route, view, run, template, static_file, TEMPLATE_PATH

TEMPLATE_PATH.insert(0, os.path.abspath(os.path.dirname(__file__)))

import subprocess, re, json, httplib, requests

application = Bottle()

@application.route('/index.html')
@application.route('/default.html')
@application.route('/')
@view('index')
def index():
    pass

@application.route('/favicon.ico')
def fav():
    return static_file('favicon.ico', root='/var/www/SiteUppity')

@application.route('/robots.txt')
def robot():
    return static_file('robots.txt', root='/var/www/SiteUppity')

@application.route('/getresponse/<secure:int>/<d>/<path>/')
@application.route('/getresponse/<secure:int>/<d>/<path>')
@application.route('/getresponse/<secure:int>/<d>/')
@application.route('/getresponse/<secure:int>/<d>')
def getresponse(secure, d, path = ""):
    path = "/" + path
    domain = str(d)
    protocol = "http"
    if secure == 1:
        protocol = "https"

    try:
        response = requests.head(protocol + '://' + domain + path)
        return json.dumps(dict(response.headers))
    except Exception as e:
        return '{"SiteUppity Error":"' + "{0}".format(e.strerror) + '"}'

@application.route('/getstatus/<secure:int>/<host>/<path>/')
@application.route('/getstatus/<secure:int>/<host>/<path>')
@application.route('/getstatus/<secure:int>/<host>/')
@application.route('/getstatus/<secure:int>/<host>')
def getstatus(secure, host, path = ""):
    json = "{0} {1}"
    path = "/" + path
    headers = {"User-Agent": "SiteUppity.com"}
    try:
        conn = httplib.HTTPConnection(host, 80)
        if secure == 1:
            conn = httplib.HTTPSConnection(host, 443)
        conn.request("HEAD", path, "", headers)
        res = conn.getresponse()
        json = json.format(res.status, res.reason)
    except Exception as e:
        json = e.strerror

    return '{"status":"' + json + '"}'

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


