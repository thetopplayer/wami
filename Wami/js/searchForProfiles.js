/*
 * searchForProfiles.js
 *
 * Created by Rob Lanter on 3/19/14.
 *
 * Search either user wami collection or whole database for profiles
 */
$(document).ready(function() {
	var selected_item = localStorage.getItem("selected_item");
	var search_str = localStorage.getItem("search_str");
	var search_context = localStorage.getItem("search_context");
	if (selected_item === null) selected_item = '';
	if (search_str === null) search_str = '';
	if (search_context === null) search_context = "mywami";

	loadData(selected_item, search_str, search_context);
});

function loadData(selected_item, search_str, search_context) {
	$("#wamiSearchSelect").val(selected_item);
	$("#searchStr").val(search_str);

	var radios = document.getElementsByName("optionsRadios");
	if (search_context === "mywami") {
		radios[0].checked = true;
	}
	else radios[1].checked = true;

	if (search_str === "") {
		var search_num_items = 0;
		localStorage.setItem("search_num_items", search_num_items);
		var list = '';
		document.getElementById("list_id").innerHTML=list;
		var profile_title_id = "Profile Search Results";
		document.getElementById("profile_title_id").innerHTML=profile_title_id;
		my_search_alert ("Please provide a Search String", "alert-info", "Info!  ");
		return;
	}
	else {
		my_search_alert ("", "", "clear");
	}

	searchProfiles(selected_item, search_str, search_context);
}

function searchProfiles(selected_item, search_str, search_context) {
	var params = "selected_item=" + selected_item + "&search_str=" + search_str + "&search_context=" + search_context;

	processData(params, "get_search_profile_data.php", "profile_list");
	try {
		var profile_list_data = localStorage.getItem("profile_list");
		var profile_list_obj = JSON.parse(profile_list_data);
	} catch (err) {
			console.log(err.message)
			my_search_alert("get_search_profile_data: Problem getting search profile data: status = " + err.message, "alert-danger", "Severe Error!  ");
			return;
	}

	var ret_code = profile_list_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_list_obj.message;
		my_search_alert (message, "alert-info", "Alert! ");
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
				my_search_alert ("", "", "clear");
				return true;
			}
		}
	}
	else if (search_num_items === 0) {
		my_search_alert("No Profile search data found so none can be requested.", "alert-info", "Alert! ");
		return false;
	}
	my_search_alert("No Profiles were chosen to be requested.", "alert-info", "Alert! ");
	return false;
}

function requestProfiles() {
	var search_num_items = +localStorage.getItem("search_num_items");
	if (search_num_items > 0) {
		var email_str = '';
		for (var i = 0; i < search_num_items; i++) {
			var checkbox_id = "checkbox" + i;
			if (document.getElementById(checkbox_id).checked) {
				email_str = email_str + "," + document.getElementById(checkbox_id).value;
			}
		}
		var requestor_profile_name = localStorage.getItem("current_profile_name");
		var login_url  = "http://localhost:80/Wami/index.html";
		window.location.href = 'mailto:?bcc=' + email_str + '&subject=Request For WAMI Profile&body=' + encodeURI('Wami user: ' + requestor_profile_name + ' has requested your WAMI profile. Log into Wami ' + login_url + ' to transmit your profile.');

	}
}

// Alert messages
function my_search_alert (message, message_type_class, message_type_string) {
	var alert_str = "";
	if (message_type_string !== "clear") {
	  alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
				"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
				"<strong>" + message_type_string + "</strong> " + message + "</div>";
	}
	document.getElementById("search_alert").innerHTML = alert_str;
}