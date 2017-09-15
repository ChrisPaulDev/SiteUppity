document.getElementById('siteuppity_form').addEventListener('submit', function(event){
        event.preventDefault();
        run();
    });
    function run() {
        var host = document.getElementById('host').value;
        if (host != '') {
            document.getElementById('http_response').innerHTML = '<h5>HTTP Response Headers:</h5> {...} <hr>';
            document.getElementById('https_response').innerHTML = '<h5>HTTPs Response Headers:</h5> {...} <hr>';
            document.getElementById('http_status').innerHTML = '<h5 style="display:inline;">HTTP Status:</h5> {...}';
            document.getElementById('https_status').innerHTML = '<h5 style="display:inline;">HTTPs Status:</h5> {...}';
            document.getElementById('ping').innerHTML = '<h5>Ping Output:</h5> {...} <hr>';
            document.getElementById('dig').innerHTML = '<h5>DIG Output:</h5> {...} <hr>';
            var path = document.getElementById('path').value;
                      
            var response_xhr = new XMLHttpRequest();
            var response_secure_xhr = new XMLHttpRequest();
            var status_xhr = new XMLHttpRequest();
            var status_secure_xhr = new XMLHttpRequest();
            var ping_xhr = new XMLHttpRequest();
            var dig_xhr = new XMLHttpRequest();
            
            dig_xhr.onreadystatechange = function() {
                if (dig_xhr.readyState == 4 && dig_xhr.status == 200) {
                    var result = JSON.parse(dig_xhr.responseText);
                    var html = '<h5>DIG Output:</h5>';
                    for (var i = 0; i < result.length; i++) {
                        html += result[i] + '<br>';
                    }
                    html += '<hr>';
                    document.getElementById('dig').innerHTML = html;
                }
            }
            dig_xhr.open('GET', '/dig/' + host, true);
            dig_xhr.send();

            response_xhr.onreadystatechange = function() {
                if (response_xhr.readyState == 4 && response_xhr.status == 200) {
                    var result = JSON.parse(response_xhr.responseText);
                    var html = '<div class="container"><h5>HTTP Response Headers:</h5><div>';
                    for (var key in result) {
                        if (result.hasOwnProperty(key)) {
                            html += '<span>' + key + '</span> : ' + result[key] + '<br>';
                        }
                    }
                    html += '</div></div><hr>';
                    document.getElementById('http_response').innerHTML = html;
                }
            }
            response_xhr.open('GET', '/getresponse/0/' + host + '/' + path, true); // not https
            response_xhr.send();            
            
            response_secure_xhr.onreadystatechange = function() {
                if (response_secure_xhr.readyState == 4 && response_secure_xhr.status == 200) {
                    var result = JSON.parse(response_secure_xhr.responseText);
                    var html = '<div class="container"><h5>HTTPs Response Headers:</h5><div>';
                    for (var key in result) {
                        if (result.hasOwnProperty(key)) {
                            html += '<span>' + key + '</span> : ' + result[key] + '<br>';
                        }
                    }
                    html += '</div><hr>';
                    document.getElementById('https_response').innerHTML = html;
                }
            }
            response_secure_xhr.open('GET', '/getresponse/1/' + host + '/' + path, true); // https
            response_secure_xhr.send();

            status_xhr.onreadystatechange = function() {
                if (status_xhr.readyState == 4 && status_xhr.status == 200) {
                    var result = JSON.parse(status_xhr.responseText);
                    var html = '<h5 style="display:inline;">HTTP Status:</h5> <span>' + result.status + '</span>';
                    document.getElementById('http_status').innerHTML = html;
                }
            }
            status_xhr.open('GET', '/getstatus/0/' + host + '/' + path, true); // not https
            status_xhr.send();
            
            status_secure_xhr.onreadystatechange = function() {
                if (status_secure_xhr.readyState == 4 && status_secure_xhr.status == 200) {
                    var result = JSON.parse(status_secure_xhr.responseText);
                    var html = '<h5 style="display:inline;">HTTPs Status:</h5> <span>' + result.status + '</span>';
                    document.getElementById('https_status').innerHTML = html;
                }
            }
            status_secure_xhr.open('GET', '/getstatus/1/' + host + '/' + path, true); // https
            status_secure_xhr.send();
            
            ping_xhr.onreadystatechange = function() {
                if (ping_xhr.readyState == 4 && ping_xhr.status == 200) {
                    var result = JSON.parse(ping_xhr.responseText);
                    var html = '<div class="container"><h5>Ping Output:</h5><div>';
                    for (var i = 0; i < result.length; i++) {
                        html += result[i] + '<br>';
                    }
                    html += '</div><hr>';
                    document.getElementById('ping').innerHTML = html;
                }
            }
            ping_xhr.open('GET', '/ping/' + host, true);
            ping_xhr.send();
        }     
    }
