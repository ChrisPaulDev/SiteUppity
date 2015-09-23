<!DOCTYPE html>
<html>
    <head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
	<title>SiteUppity</title>

	<style type="text/css">
	    body {
		font-family: sans-serif;
	    }
            input {
	        border: 1px solid #ccc;
	        color: #000;
	        font-size: 1em;
	        padding: 5px;
	    }
	    button {
		font-size: 16px;
		padding: 5px;
	    }
	</style>
    </head>
    <body>
	<form id="siteuppity_form" method="GET" action="/">
	    <div>
		<p>SiteUppity will return the HTTP status code, PING output, and DIG output.<br>Simply enter a domain. The path defaults to "/".</p>
		<p>
        	    The domain<br><input type="text" id="host" placeholder="example.com">
    		</p>
    		<p>
        	    The path<br><input type="text" id="path" placeholder="/">
    		</p>
    		<p>
        	    <button>Execute</button>
    		</p>
	    </div>
	</form>

<div id="httpStatusResult"></div>
<div id="pingresult"></div>
<div id="digresult"></div>

<script type="text/javascript">
    document.getElementById("siteuppity_form").addEventListener("submit", function(event){
        event.preventDefault();
        run();
    });
    function run() {
        document.getElementById("httpStatusResult").innerHTML = 'Processing...';
        document.getElementById("pingresult").innerHTML = 'Processing...';
        document.getElementById("digresult").innerHTML = 'Processing...';
        var host = document.getElementById('host').value;
        if (host != '') {
            var path = document.getElementById('path').value;

            var statusXHR = new XMLHttpRequest();
            statusXHR.onreadystatechange = function() {
                if (statusXHR.readyState == 4 && statusXHR.status == 200) {
                    var statusresult = JSON.parse(statusXHR.responseText);
                    document.getElementById('httpStatusResult').innerHTML = statusresult.http + '; ' + statusresult.https;
                }
            }
            statusXHR.open('GET', '/getstatus/' + host + '/' + path, true);
            statusXHR.send();

            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var pingresult = JSON.parse(xmlhttp.responseText);
                    var pinghtml = "";
                    for (var i = 0; i < pingresult.length; i++) {
                        pinghtml = pinghtml + pingresult[i] + "<br>";
                    }
                    document.getElementById("pingresult").innerHTML = pinghtml;
                }
            }
            xmlhttp.open("GET", "/ping/" + host, true);
            xmlhttp.send();
    
            var digxhr = new XMLHttpRequest();
            digxhr.onreadystatechange = function() {
                if (digxhr.readyState == 4 && digxhr.status == 200) {
                    var digresult = JSON.parse(digxhr.responseText);
                    var dightml = "";
                    for (var i = 0; i < digresult.length; i++) {
                        dightml = dightml + digresult[i] + "<br>";
                    }
                    document.getElementById("digresult").innerHTML = dightml;
                }
            }
            digxhr.open("GET", "/dig/" + host, true);
            digxhr.send();
        }     
    }
</script>
</body>
</html>

