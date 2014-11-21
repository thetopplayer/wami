/**
 * processData.js
 * Created by robertlanter on 5/15/14.
 *
 * Generic routine to submit client requests to server.
 * input: list of parameters,  a url string, and an identifier used in the calling code to parse the JSON response object returned
 */
function processData(param_string, url, identifier, sync_ind, call_back) {
	$.ajaxSetup({cache: false});
	var xmlhttp = new XMLHttpRequest();
	var response;

	param_string = 'x999=' + Math.random() + '&' + param_string;
	xmlhttp.open("POST", url, sync_ind);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 ) {
			if (xmlhttp.status == 200)  {
				response = xmlhttp.responseText;
				localStorage.setItem(identifier, response);
				if (call_back !== undefined) {
					call_back();
				}
			}
		}
	};
	xmlhttp.send(param_string);
}
