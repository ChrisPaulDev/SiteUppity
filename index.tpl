<!DOCTYPE html>
<html>
    <head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
	<title>SiteUppity</title>
	<style type="text/css">
	    body {
		font-family: sans-serif;
                font-size: 15px;
                line-height: 18px;
	    }
            p {margin-top: 0;}
            input {
	        border: 1px solid #ccc;
	        color: #000;
	        font-size: 15px;
	        padding: 5px;
	    }
	    button {
		font-size: 15px;
		padding: 5px;
	    }
            #status, #ping, #dig {
                border-bottom: 1px solid #ddd;
                margin: 0 0 5px;
                width: 400px;
            }
	</style>
    </head>
    <body>
        <div style="width:550px;float:left;">
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
        </div>
        <div style="width:410px;float:left;">
            <div id="status"></div>
            <div id="ping"></div>
            <div id="dig"></div>
        </div>
<script type="text/javascript">
    document.getElementById('siteuppity_form').addEventListener('submit', function(event){
        event.preventDefault();
        run();
    });
    function run() {
        var host = document.getElementById('host').value;
        if (host != '') {
            document.getElementById('status').innerHTML = 'Processing...';
            document.getElementById('ping').innerHTML = 'Processing...';
            document.getElementById('dig').innerHTML = 'Processing...';
            var path = document.getElementById('path').value;

            var statusXHR = new XMLHttpRequest();
            statusXHR.onreadystatechange = function() {
                if (statusXHR.readyState == 4 && statusXHR.status == 200) {
                    var statusresult = JSON.parse(statusXHR.responseText);
                    var statushtml = '<div id="httpstatus">HTTP Status: ' + statusresult.http + '</div>';
                    statushtml += '<div id="sslstatus">HTTPS Status: ' + statusresult.https + '</div>';
                    document.getElementById('status').innerHTML = statushtml;
                }
            }
            statusXHR.open('GET', '/getstatus/' + host + '/' + path, true);
            statusXHR.send();

            var pingXHR = new XMLHttpRequest();
            pingXHR.onreadystatechange = function() {
                if (pingXHR.readyState == 4 && pingXHR.status == 200) {
                    var pingresult = JSON.parse(pingXHR.responseText);
                    var pinghtml = '';
                    for (var i = 0; i < pingresult.length; i++) {
                        pinghtml = pinghtml + pingresult[i] + "<br>";
                    }
                    document.getElementById('ping').innerHTML = pinghtml;
                }
            }
            pingXHR.open('GET', '/ping/' + host, true);
            pingXHR.send();
    
            var digXHR = new XMLHttpRequest();
            digXHR.onreadystatechange = function() {
                if (digXHR.readyState == 4 && digXHR.status == 200) {
                    var digresult = JSON.parse(digXHR.responseText);
                    var dightml = "";
                    for (var i = 0; i < digresult.length; i++) {
                        dightml = dightml + digresult[i] + "<br>";
                    }
                    document.getElementById('dig').innerHTML = dightml;
                }
            }
            digXHR.open('GET', '/dig/' + host, true);
            digXHR.send();
        }     
    }
</script>
</body>
</html>

