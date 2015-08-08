/*
 * searchForProfiles.js
 *
 * Created by Rob Lanter on 3/19/14.
 *
 * Search either user wami collection or whole database for profiles
 */
$(document).ready(function() {
	var current_profile_name = localStorage.getItem("current_profile_name");
	var search_heading = "<h3 class='panel-title'>Search Wami Network for Profiles to Connect/Subscribe to: " +
		"<b><span style='color: #f87c08'>"  + current_profile_name + "</span></b> </h3>";
	document.getElementById('search_heading').innerHTML = search_heading;
	var selected_item = '';
	var search_str = '';
	var search_context = "mywami";

	loadData(selected_item, search_str, search_context);
});

function loadData(selected_item, search_str, search_context) {
	if (selected_item === '') {
		$('#wamiSearchSelect').find('option:first-child');
	}
	else {
		$("#wamiSearchSelect").val(selected_item);
	}
	$("#searchStr").val(search_str);

	var radios = document.getElementsByName("optionsRadios");
	if (search_context === "mywami") {
		radios[0].checked = true;
	}
	else {
		radios[1].checked = true;
	}

	if (search_str === "") {
		var search_num_items = 0;
		localStorage.setItem("search_num_items", search_num_items);
		var list = '';
		document.getElementById("list_id").innerHTML=list;
		var profile_title_id = "Profile Search Results";
		document.getElementById("profile_title_id").innerHTML=profile_title_id;
		my_search_alert ("Please provide a Search String", "alert-info", "Info!  ", "search_alert");
		return;
	}
	else {
		my_search_alert ("", "", "clear", "search_alert");
	}

	searchProfiles(selected_item, search_str, search_context);
}

function searchProfiles(selected_item, search_str, search_context) {
	var current_identity_profile_id = '';
	if (search_context === 'mywami') {
		current_identity_profile_id = localStorage.getItem("current_identity_profile_id");
	}
	var params = "selected_item=" + selected_item + "&search_str=" + search_str + "&search_context=" + search_context + "&identity_profile_id=" + current_identity_profile_id;
	processData(params, "get_search_profile_data.php", "profile_list");
	try {
		var profile_list_data = localStorage.getItem("profile_list");
		var profile_list_obj = JSON.parse(profile_list_data);
	} catch (err) {
			console.log(err.message)
			my_search_alert("get_search_profile_data: Problem getting search profile data: status = " + err.message, "alert-danger", "Severe Error!  ", "search_alert");
			return;
	}

	var ret_code = profile_list_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_list_obj.message;
		my_search_alert (message, "alert-info", "Alert! ", "search_alert");
		//return;
	}

	var list = '';
	var search_num_items = profile_list_obj.profile_list.length;
	localStorage.setItem("search_num_items", search_num_items);
	var profile_title_id = "Profile Search Results:   &nbsp;&nbsp;<strong>" + search_num_items + " profile(s) found </strong>";
	document.getElementById("profile_title_id").innerHTML=profile_title_id;
	for (var i = 0; i < search_num_items; i++) {
		var profile_name = profile_list_obj.profile_list[i].profile_name;
		var image_url = "assets/main_image/" + profile_list_obj.profile_list[i].image_url + ".png";
		var contact =  profile_list_obj.profile_list[i].first_name + " "  + profile_list_obj.profile_list[i].last_name;
		var tags = profile_list_obj.profile_list[i].tags;
		var email = profile_list_obj.profile_list[i].email;
		var rating = profile_list_obj.profile_list[i].rating;
		var description = profile_list_obj.profile_list[i].description;
		if (tags === null) tags = '';
		if (description === null) description = '';

		var list_identity_profile_id = profile_list_obj.profile_list[i].identity_profile_id;
		list = list +
				'<div class="panel-body wami-panel" style="padding-bottom: 15px; padding-top: 15px; padding-right: 0px; padding-left: 15px">' +
					'<div class="row">' +
						'<div class="col-md-4" style="width: 330px; padding-left: 20px">' +
							'<label style="vertical-align: top">' +
								'<input type="checkbox" name="' + profile_name + '" value=' + email + ' id="checkbox' + i + '">  Choose' +
							'</label>' +
							'<img src="' + image_url  +  '" style="padding-left: 20px">' +
						'</div>' +
						'<div class="col-md-4" style="padding: 10px; width: 320px">' +
							'<strong>Profile Name: </strong> ' + profile_name + '<br> ' +
							'<strong>Contact Name: </strong> ' + contact + '<br> ' +
							'<strong>Tags: </strong> ' + tags + '<br> ' +
							'<strong>Email: </strong> <a href="mailto:' + email + '">' + email + '</a><br> ' +
							'<strong>Profile Rating: </strong> ' + rating + '<br> ' +
						'</div>' +
						'<div class="col-md-4" style="padding: 0px; width: 350px">' +
							'<strong>Description: </strong> ' + description + '<br> ' +
						'</div>' +
					'</div>' +
				'</div><hr>';
	}
	document.getElementById("list_id").innerHTML=list;
}

function checkForChosen() {
	var search_num_items = +localStorage.getItem("search_num_items");
	if (search_num_items > 0) {
		for (var i = 0; i < search_num_items; i++) {
			var checkbox_id = "checkbox" + i;
			if (document.getElementById(checkbox_id).checked) {
				my_search_alert ("", "", "clear", "search_alert");
				return true;
			}
		}
	}
	else if (search_num_items === 0) {
		my_search_alert("No Profile search data found so none can be requested.", "alert-info", "Alert! ", "search_alert");
		return false;
	}
	my_search_alert("No Profiles were chosen to be requested.", "alert-info", "Alert! ", "search_alert");
	return false;
}

function requestProfiles() {
	var search_num_items = localStorage.getItem("search_num_items");
	if (search_num_items > 0) {
		var email_str = '';
		for (var i = 0; i < search_num_items; i++) {
			var checkbox_id = "checkbox" + i;
			if (document.getElementById(checkbox_id).checked) {
				email_str = email_str + "," + document.getElementById(checkbox_id).value;
			}
		}
		if (email_str.slice(0,1) === ',') {
			email_str = email_str.slice(1);
		}
		var requester_profile_name = localStorage.getItem("current_profile_name");
		var login_url  = "http://www.mywami.com";

		send_serverside_request(requester_profile_name, email_str);
    }
}

function send_serverside_request(requester_profile_name, email_str) {
	var message_body =
		'<html><body style="background-color: rgba(204, 255, 254, 0.13)">' +
		'<link href="http://www.mywami.com/css/bootstrap.css" rel="stylesheet">' +
		'<link href="http://www.mywami.com/css/wami.css" rel="stylesheet">' +
		'<script src="http://www.mywami.com/js/jquery-1.11.0.min.js"></script>' +

		'<div class="panel" style="background-color: #606060; height: 45px">' +
			'<img  style="margin-left: 30px; vertical-align: middle" src="http://www.mywami.com/assets/wami-navbar.jpg">' +
		'</div>' +

		'<div style="margin-left: 10px; margin-right: 10px">' +
			'<h4> Wami user: <span style="color: #f87c08">' + requester_profile_name + '</span> has requested to connect/subscribe to your WAMI profile. Log into Wami ' +
				'<a href="http://www.mywami.com"> http://www.mywami.com </a> to transmit/publish your Profile if you want to be connected.' +
			'</h4><br>' +
			'<hr>' +
		'<div><br>' +
		'<h5> Download the WAMI app from <br><br>' +
			'<img src="http://www.mywami.com/assets/android_app_logo.png"  height="25px" width="80px"> ' +
			' <img src="http://www.mywami.com/assets/apple_app_logo.png" height="25px" width="80px">' +
		'</h5>' +
		'</div>' +
			'<hr>' +
			'<br><br>' +
			'<h6 style="margin-left: 4px; color: #808080">WAMI Logos, Site Design, and Content © 2014 WAMI Inc. All rights reserved. Several aspects of the WAMI site are patent pending.</h6> ' +
			'<p> <img src="http://www.mywami.com/assets/wami-logo-footer.jpg" class="left" ></p>' +
			'<br><br><br>' +
		'</div>' +
		'</body></html>';

	var requestor_profile_id = localStorage.getItem("current_identity_profile_id");
	if (requestor_profile_id === null) {
		requestor_profile_id = localStorage.getItem("identity_profile_id");
	}

	var params = "identity_profile_id=" + requestor_profile_id;
	processData(params, "get_profile_email.php", "from_email");
	try {
		var from_email_data = localStorage.getItem("from_email");
		var from_email_obj = JSON.parse(from_email_data);
	} catch (err) {
		console.log(err.message)
		my_search_alert("get_profile_email: Problem getting emal for profile: status = " + err.message, "alert-danger", "Severe Error!  ", "request_alert");
		return;
	}
	var ret_code = from_email_obj.ret_code;
	if (ret_code === 1) {
		var message = from_email_obj.message;
		my_search_alert (message, "alert-info", "Alert! ", "request_alert");
		return;
	}

	var from_email = from_email_obj.from_email;

	$.ajaxSetup({cache: false});
	var xmlhttp = new XMLHttpRequest();
	var response;
	var param_string = 'x999=' + Math.random() + '&message=' + message_body + "&from_email=" + from_email + "&transmit_to=" + email_str;

	xmlhttp.open("POST", "http://www.mywami.com/transmit_request_to_email_address.php", false);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 ) {
			if (xmlhttp.status == 200)  {
				response = xmlhttp.responseText;
			}
		}
	};
	xmlhttp.send(param_string);
	my_search_alert("Request transmitted to email address!", "alert-success","Success! ", "request_alert");
}

// Alert messages
function my_search_alert (message, message_type_class, message_type_string, message_placement) {
	var alert_str = "";
	if (message_type_string !== "clear") {
	  alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
				"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
				"<strong>" + message_type_string + "</strong> " + message + "</div>";
	}
	if (message_placement === "search_alert") document.getElementById("search_alert").innerHTML = alert_str;
	if (message_placement === "request_alert") document.getElementById("request_alert_message").innerHTML = alert_str;
}
