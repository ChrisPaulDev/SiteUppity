<!DOCTYPE html>
<html>
    <head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
	<title>SiteUppity</title>
	<link rel="stylesheet" href="/static/style.css" type="text/css" />
    </head>
    <body>
        <div style="margin:0 10px 0;width:250px;float:left;">
	    <form id="siteuppity_form" method="GET" action="/">
	        <div>
		    <p>SiteUppity will return the HTTP status code, PING output, and DIG output.</p>
                    <p>Simply enter a domain.</p>
                    <p>The path defaults to "/".</p>
		    <p>The domain<br><input type="text" id="host" placeholder="example.com"></p>
    		    <p>The path<br><input type="text" id="path" placeholder="/"></p>
    		    <p><button>Execute</button></p>
	        </div>
	    </form>
        </div>
        <div style="width:410px;float:left;">
            <pre id="http_status"></pre>
            <pre id="https_status"></pre>
            <pre id="http_response"></pre>
            <pre id="https_response"></pre>
            <pre id="ping"></pre>
            <pre id="dig"></pre>
        </div>

	<script type="text/javascript" src="/static/main.js"></script>
</body>
</html>
