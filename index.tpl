<!DOCTYPE html>
<html>
<head>
<title>SiteUppity</title>
</head>
<body>
<form id="siteuppity_form" method="GET" action="/">
<div>
    <p>
        <input type="text" id="host" />
    </p>
    <p>
        <input type="text" id="path" />
    </p>
    <p>
        <button>Run</button>
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

