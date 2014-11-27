/**
 * myWami.js
 * Created by robertlanter on 5/15/14.
 *
 * Load all wami data for a specified profile.
 */
$(document).ready(function(){
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data)
	var user_id = obj.user_info[0].user_id;
	var username = obj.user_info[0].username;
	localStorage.setItem("username", username);

	//from common.js, loads list of profiles for the current user
	load_profile_list(user_id);

	var identity_profile_id = localStorage.getItem("identity_profile_id");
	loadData(identity_profile_id);
});

function loadData(identity_profile_id) {
	 localStorage.setItem("identity_profile_id", identity_profile_id);

// Get number of Wami's for the specified profile_id
	processData("identity_profile_id=" + identity_profile_id, "get_wami_count_for_profile.php", "wami_count", false);
	var wami_count_data = localStorage.getItem("wami_count");
	try {
		var wami_count_obj = JSON.parse(wami_count_data);
		var wami_count = wami_count_obj.wami_count;
	} catch (err) {
		console.log(err.message)
		my_wami_alert("Error getting web page: status = " + err.message, "alert-danger", "Severe Error!  ", "header");
	}

	document.getElementById("total_collected_profiles").innerHTML =
			"<input readonly class='input-wami' type='text' value='" + wami_count + "' style='margin-bottom: 10px; text-align: center; width: 50px; background-color: #d1d1d1'>";

// Get Validation and verification rating
//	processData("identity_profile_id=" + identity_profile_id, "get_wami_rating_for_profile.php", "rating", false);
//	try {
//		var wami_rating_data = localStorage.getItem("rating");
//		var wami_rating_obj = JSON.parse(wami_rating_data);
//	} catch (err) {
//		console.log(err.message)
//		my_wami_alert("get_wami_rating_for_profile: Error getting rating for profile: status = " + err.message, "alert-danger", "Error!  ", "header");
//	}
//
//	var wami_rating = wami_rating_obj.rating;
//	document.getElementById("rating").innerHTML =
//			"<input readonly class='input-wami' type='text' value='" + wami_rating + "' style='margin-bottom: 10px; text-align: center; width: 50px; background-color: #d1d1d1'>";

// My Wami Data
	var username = localStorage.getItem("username");
	var params = "identity_profile_id=" + identity_profile_id + "&username=" + username;
	processData(params, "get_mywami_data.php", "mywami_data", false);
	try {
		var mywami_data = localStorage.getItem("mywami_data");
		var mywami_obj = JSON.parse(mywami_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("get_mywami_data: Error getting data for profile: status = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

// Check return code and messages from get_mywami_data.php
	var ret_code = mywami_obj.ret_code;
	var alert_str = '';
	if (ret_code === -1) {
		my_wami_alert(mywami_obj[0].message, "alert-danger", "Alert! ", "header");
		return;
	}
	if (ret_code > 0) {
		var num_ele = mywami_obj.message.length;
		alert_str = '';
		for (var i = 0; i < num_ele; i++) {
			alert_str = "<br>" + mywami_obj.message[i] + alert_str;
		}
		my_wami_alert(alert_str, "alert-info", "Info! ", "header");
	}

	//Globalize variable
	window.mywami_obj = mywami_obj;

	var image_url = "assets/main_image/" + mywami_obj.identity_profile_data[0].image_url + ".png";
	document.getElementById("image").innerHTML =  "<img class='wami-margin-t4' src=" + image_url + ">";

	var profile_name = mywami_obj.identity_profile_data[0].profile_name;
	localStorage.setItem("current_profile_name", profile_name);
	$("#profile_name").val(profile_name);

	var first_name = mywami_obj.identity_profile_data[0].first_name;
	$("#first_name").val(first_name);

	var last_name = mywami_obj.identity_profile_data[0].last_name;
	$("#last_name").val(last_name);

	var email = mywami_obj.identity_profile_data[0].email;
	$("#email").val(email);

	var profile_type = mywami_obj.identity_profile_data[0].profile_type;
	$("#profile_type").val(profile_type);

	var description = mywami_obj.identity_profile_data[0].description;
	$("#description").val(description);

	var street_address = mywami_obj.identity_profile_data[0].street_address;
	$("#street_address").val(street_address);

	var city = mywami_obj.identity_profile_data[0].city;
	$("#city").val(city);

	var state = mywami_obj.identity_profile_data[0].state;
	$("#state").val(state);

	var zipcode = mywami_obj.identity_profile_data[0].zipcode;
	$("#zipcode").val(zipcode);

	var country = mywami_obj.identity_profile_data[0].country;
	$("#country").val(country);

	var telephone = mywami_obj.identity_profile_data[0].telephone;
	$("#telephone").val(telephone);

	var tags = mywami_obj.identity_profile_data[0].tags;
	$("#tags").val(tags);

	var create_date = mywami_obj.identity_profile_data[0].create_date.substr(0, 10);
	$("#create_date").val(create_date);

	var active_ind = mywami_obj.identity_profile_data[0].active_ind;
	if (active_ind == 1) {
		var radio = $('#active');
		radio[0].checked = true;
		radio.button("refresh");
	}
	else {
		radio = $('#inactive');
		radio[0].checked = true;
		radio.button("refresh");
	}

	var searchable = mywami_obj.identity_profile_data[0].searchable;
	if (searchable == 1) {
		var radio = $('#search_allowed');
		radio[0].checked = true;
		radio.button("refresh");
	}
	else {
		radio = $('#search_notallowed');
		radio[0].checked = true;
		radio.button("refresh");
	}

// Groups Data
	var groups = '';
	if (mywami_obj.profile_group_data !== undefined) {
		for (var i = 0; i < mywami_obj.profile_group_data.length; i++) {
			var group = mywami_obj.profile_group_data[i].group;
			groups = groups +
					'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left">' +
					'<div class="list-group"><div class="col-md-1" style="width: 3px"><input type="checkbox"></div>' +
					'<div class="col-md-1" style="width: 1040px">' +
					'<h5 style="margin-top: 3px; margin-bottom: 3px">' + group + '</h5>' +
					'</div></div></a>';
		}
	}
	document.getElementById("group_id").innerHTML = groups;
//
// Flash Data
//
	var flash_announcements = '';
	var profile_flash_id = [];
	if (mywami_obj.profile_flash_data !== undefined) {
		localStorage.setItem("num_flash_announcements", mywami_obj.profile_flash_data.length);
		for (var i = 0; i < mywami_obj.profile_flash_data.length; i++) {
			profile_flash_id[i] = mywami_obj.profile_flash_data[i].profile_flash_id;
			var date = mywami_obj.profile_flash_data[i].create_date;
			var flash = mywami_obj.profile_flash_data[i].flash;
			var flash_tag = '';
			var media_url = mywami_obj.profile_flash_data[i].media_url;
			var media_tag = '';
			if (media_url != null) {
				media_url = 'assets/' + media_url +  '.png';
				media_tag = '<div class="col-md-2" style="width: 140px"><img src="' + media_url + '"style="margin-top: 3px; margin-bottom: 10px"></div>';
				flash_tag = '<div class="col-md-2" style="width: 730px;">' + flash + '</div>';
			} else {
				flash_tag = '<div class="col-md-1" style="min-width: 870px">' + flash + '</div>';
			}
			flash_announcements = flash_announcements +
				'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
					'<div class="list-group">' +
						'<div class="col-md-1" style="width: 3px">' +
							'<input type="checkbox" id="flash_checkbox' + i + '">' +
						'</div>' +
						'<div class="col-md-1" style="width: 170px">' +
							'<h5 style="margin-top: 3px; margin-bottom: 3px">' + date + '</h5>' +
						'</div>' +
							media_tag + flash_tag +
					'</div>' +
				'</a>';
		}
	}
	localStorage.setItem("profile_flash_id", profile_flash_id);
	document.getElementById("flash_id").innerHTML = flash_announcements;

// function is in identityProfiler.js. Loads all Identity Profiler categories
	load_profiler_categories(identity_profile_id);
}
//
// End loadData()
// -----------------------------------------

// -----------------------------------------
// MyWami Profile Image processing...Remove profile by doing a soft delete
//
function remove_profile() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	processData("identity_profile_id=" + identity_profile_id, "update_for_delete_mywami_profile.php", "update_mywami_profile_data", false);
	try {
		var update_mywami_profile_data = localStorage.getItem("update_mywami_profile_data");
		var update_mywami_profile_obj = JSON.parse(update_mywami_profile_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("update_for_delete_mywami_profile: Error deleting profile = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

	var ret_code = update_mywami_profile_obj.ret_code;
	var profile_name = localStorage.getItem("current_profile_name");
	if (ret_code !== 0) {
		my_wami_alert(update_mywami_profile_obj.message + "Profile Name: " + profile_name, "alert-danger", "Alert! ", "header");
	}
	else {
		my_wami_alert(update_mywami_profile_obj.message + "Profile Name: " + profile_name, "alert-success", "Success! " , "header");
		var default_identity_profile_id = localStorage.getItem("default_identity_profile_id");

		var data = localStorage.getItem("user_info");
		var obj = JSON.parse(data)
		var user_id = obj.user_info[0].user_id;

		//from common.js, loads list of profiles for the current user
		load_profile_list(user_id);

		loadData(default_identity_profile_id);
	}
}

// Change the default profile
function updateDefaultProfile() {
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data)
	var user_id = obj.user_info[0].user_id;

	var identity_profile_id = localStorage.getItem("identity_profile_id");

	var param_str = "identity_profile_id=" + identity_profile_id + "&user_id=" + user_id;
	processData(param_str, "update_default_profile.php", "update_default_profile_data", false);
	try {
		var update_default_profile_data = localStorage.getItem("update_default_profile_data");
		var update_default_profile_obj = JSON.parse(update_default_profile_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("update_default_profile: Error updating default profile = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

	var profile_name = localStorage.getItem("current_profile_name");
	var ret_code = update_default_profile_obj.ret_code;
	if (ret_code !== 0) {
		my_wami_alert(update_default_profile_obj.message + "Profile Name: " + profile_name, "alert-danger", "Alert! ", "header");
	}
	else {
		my_wami_alert(update_default_profile_obj.message + "Profile Name: " + profile_name, "alert-success", "Success! ", "header");

		//from common.js, loads list of profiles for the current user
		load_profile_list(user_id);
	}
}

function save_my_wami_data() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");

	var profile_name = (document.getElementById("profile_name").value).trim();
	if (profile_name === '') {
		my_wami_alert("Missing <strong>Profile Name</strong>. Please fill in required field." , "alert-danger", "Alert! ", "mywami");
		return false;
	}

	var first_name = document.getElementById("first_name").value;
	var last_name = document.getElementById("last_name").value;
	var email = (document.getElementById("email").value).trim();
	if (email === '') {
		my_wami_alert("Missing  <strong> Email </strong>. Please fill in required field.", "alert-danger", "Alert! ", "mywami");
		return false;
	}

	var profile_type = document.getElementById("profile_type").value;
	var description = document.getElementById("description").value;
	var street_address = document.getElementById("street_address").value;
	var city = document.getElementById("city").value;
	var state = document.getElementById("state").value;
	var country = document.getElementById("country").value;
	var zipcode = document.getElementById("zipcode").value;
	var telephone = document.getElementById("telephone").value;
	var tags = document.getElementById("tags").value;
	var active_ind = document.getElementById("active");
	if (active_ind.checked) {
		active_ind = 1;
	} else active_ind = 0;

	var searchable = document.getElementById("search_allowed");
	if (searchable.checked) {
		searchable = 1;
	} else searchable = 0;

	var params = "identity_profile_id=" + identity_profile_id + "&profile_name=" + profile_name
			+ "&first_name=" + first_name + "&last_name=" + last_name
			+ "&profile_type=" + profile_type + "&email=" + email
			+ "&street_address=" + street_address + "&city=" + city
			+ "&state=" + state + "&country=" + country
			+ "&zipcode=" + zipcode + "&telephone=" + telephone
			+ "&description=" + description + "&tags=" + tags
			+ "&active_ind=" + active_ind + "&searchable=" + searchable;

	processData(params, "update_mywami_data.php", "update_mywami_data", false);
	try {
		var update_mywami_data = localStorage.getItem("update_mywami_data");
		var update_mywami_obj = JSON.parse(update_mywami_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("update_mywami_data: Error updating MyWami data = " + err.message, "alert-danger", "Error!  ", "mywami");
		return false;
	}

	var ret_code = update_mywami_obj.ret_code;
	if (ret_code !== 0) {
		my_wami_alert(update_mywami_obj.message + "Profile Name: " + profile_name, "alert-danger", "Alert! ", "mywami");
		return false;
	}
	else {
		my_wami_alert(update_mywami_obj.message + "Profile Name: " + profile_name, "alert-success", "Success! ", "mywami");
		return true;
	}
}

// Create new profile
function new_profile(profile_name, email) {
	if (profile_name === '') {
		my_wami_alert ("Missing profile name. Please create a profile name.", "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	if (profile_name.length < 7) {
		my_wami_alert ("Profile name must be at lest seven characters.", "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	var result = (profile_name).match(/[^a-zA-Z0-9-_]/g);    //only allow alphanumeric, hyphen, dash
	if (result !== null) {
		my_wami_alert("Profile names must only contain letters, numbers, dashes and hyphens", "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	if (email === '') {
		my_wami_alert ("Missing Email. Please add an email address.", "alert-danger", "Alert! ", "new_profile");
		return false;
	}

	var results = check_new_profile(profile_name);
	result = results[0];
	var message = results[1];
	var user_id = results[2];

	if (result != "success") {
		my_wami_alert(message, "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	else {
		result = insert_new_profile(profile_name, email, user_id);
		if (result != "success") {
			my_wami_alert(message, "alert-danger", "Alert! ", "new_profile");
			return false;
		}
		message = "Profile was created and was added to your collection. Use the rest of the My Wami Profiles page to finish entering your profile information.";
		my_wami_alert(message, "alert-success", "Success!  ", "new_profile");
		load_profile_list(user_id); //from common.js
		return true;
	}
}

// Check for valid profile name. Duplicates are not allowed
function check_new_profile(profile_name) {
	var url = "check_new_profile_data.php";

	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data)
	var user_id = obj.user_info[0].user_id;

	var params = "profile_name=" + profile_name + "&user_id=" + user_id;
	var identifier = "result";

	var message;
	processData(params, url, identifier, false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message)
		return ("check_new_profile_data: Error checking for duplicate profiles = " + err.message);
	}

	var result = result_obj.result;
	message = result_obj.message;

	return [result, message, user_id];
}

// Insert new account
function insert_new_profile(profile_name, email, user_id) {
	var message = null;

	var params = "profile_name=" + profile_name + "&email=" + email + "&user_id=" + user_id;
	var url = "insert_new_profile_data.php";
	processData(params, url, "result", false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("insert_new_profile_data: Error inserting new profile = " + err.message, "alert-danger", "Error!  ", "mywami");
		return ("insert_new_profile_data: Error inserting new profile = " + err.message);
	}

	var ret_code = result_obj.ret_code;
	if (ret_code === -1) {
		return result_obj.message;
	}
	return "success";
}

function upload_new_profile_image() {
	my_wami_alert("", "", "", "image_upload");

	//get file and check type
	var file = document.getElementById('new_profile_image').files[0];
	var imageType = /image.*/;
	if (!file.type.match(imageType)) {
		my_wami_alert("File must be either a .jpg or .png image type.", "alert-danger", "Error!  ", "image_upload");
		return;
	}

	//display file
	var preview = new Image();
	var reader  = new FileReader();
	var byte_reader = new FileReader();
	var image_id = document.getElementById("image");
	if (file) {
		reader.readAsDataURL(file);
		byte_reader.readAsDataURL(file);
	} else {
		preview.src = "";
	}
	reader.onload =
		function () {
			image_id.innerHTML = "";
			preview.src = reader.result;
			image_id.appendChild(preview);
		}

	//save to file system and database
	byte_reader.onload =
		function () {
			var image_src = byte_reader.result;
			var identity_profile_id = localStorage.getItem("identity_profile_id");
			//change file type to .png if its a jpg or gif. Keeps it compatible with android
			var file_name = file.name;
			var file_name_type_check = file_name.slice(file_name.lastIndexOf('.'));
			if (file_name_type_check !== '.png') {
				file_name = file_name.slice(0, file_name.indexOf('.')) + ".png";
			}
			var params = "file_name=" + file_name + "&image_src=" + image_src + "&identity_profile_id=" + identity_profile_id;
			var url = "update_new_profile_image_data.php";
			processData(params, url, "result", false);
			try {
				var result_data = localStorage.getItem("result");
				var result_obj = JSON.parse(result_data);
			} catch (err) {
					console.log(err.message)
					my_wami_alert("update_new_profile_image_data: Error updating new profile image = " + err.message, "alert-danger", "Error!  ", "image_upload");
					return;
			}

			var ret_code = result_obj.ret_code;
			if (ret_code === -1) {
				my_wami_alert(result_obj.message, "alert-danger", "Error!  ", "image_upload");
				return;
			}
		}
}
//
// End My Wami Profile processing
// ------------------------------------------

// -------------------------------------------
// Flash processing
//
function add_flash_announcement() {
	$('#new_flash_dialog').modal();

	document.getElementById('new_flash').onkeyup = function() {
		if(!textLength(this.value)) {
			my_wami_alert("Only 110 characters allowed for a flash announcement.", "alert-warning", "Warning!  ", "flash_dialog");
		}
		else {
			my_wami_alert("", "", "", "flash_dialog");
		}
	}
}

//check length of flash announcement
function textLength(value){
	var maxLength = 110;
	if (value.length > maxLength) return false;
	return true;
}

function save_new_flash () {
	var new_flash = document.getElementById('new_flash').value;
	if (new_flash === '') {
		my_wami_alert("Flash Announcement cannot be empty. Please create an announcement or close.", "alert-warning", "Warning!  ", "flash_dialog");
		return;
	}
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "new_flash=" + new_flash + "&identity_profile_id=" + identity_profile_id;
	var url = "insert_flash.php";
	processData(params, url, "result", false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("insert_flash: Error inserting a new Flash = " + err.message, "alert-danger", "Error!  ", "flash_dialog");
		return;
	}

	var ret_code = result_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(result_obj.message, "alert-danger", "Danger!  ", "flash_dialog");
		return;
	}
	refresh_flash();
	my_wami_alert(result_obj.message, "alert-success", "Success!  ", "flash_dialog");
}

function refresh_flash() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "identity_profile_id=" + identity_profile_id;
	var url = "get_profile_flash_data.php";
	processData(params, url, "result", false);
	try {
		var flash_data = localStorage.getItem("result");
		var flash_obj = JSON.parse(flash_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("get_profile_flash_data: Error getting Flash data = " + err.message, "alert-danger", "Error!  ", "flash_dialog");
		return;
	}

	var ret_code = flash_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(flash_obj[0].message, "alert-danger", "Alert! ", "flash_dialog");
		return;
	}

	var flash_announcements = '';
	var profile_flash_id = [];
	if (flash_obj.profile_flash_data !== undefined) {
		localStorage.setItem("num_flash_announcements", flash_obj.profile_flash_data.length);
		for (var i = 0; i < flash_obj.profile_flash_data.length; i++) {
			profile_flash_id[i] = flash_obj.profile_flash_data[i].profile_flash_id;
			var date = flash_obj.profile_flash_data[i].create_date;
			var flash = flash_obj.profile_flash_data[i].flash;
			var flash_tag = '';
			var media_url = flash_obj.profile_flash_data[i].media_url;
			var media_tag = '';
			if (media_url != null) {
				media_url = 'assets/' + media_url +  '.png';
				media_tag = '<div class="col-md-2" style="width: 140px"><img src="' + media_url + '"style="margin-top: 3px; margin-bottom: 10px"></div>';
				flash_tag = '<div class="col-md-2" style="width: 730px;">' + flash + '</div>';
			} else {
				flash_tag = '<div class="col-md-1" style="min-width: 870px">' + flash + '</div>';
			}
			flash_announcements = flash_announcements +
					'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
					'<div class="list-group">' +
					'<div class="col-md-1" style="width: 3px">' +
					'<input type="checkbox" id="checkbox' + i + '">' +
					'</div>' +
					'<div class="col-md-1" style="width: 170px">' +
					'<h5 style="margin-top: 3px; margin-bottom: 3px">' + date + '</h5>' +
					'</div>' +
					media_tag + flash_tag +
					'</div>' +
					'</a>';
		}
	}
	localStorage.setItem("profile_flash_id", profile_flash_id);
	document.getElementById("flash_id").innerHTML = flash_announcements;
}

function remove_flash_announcements() {
	var remove_ind = checkForChosenFlash();
	if (remove_ind === true) {
		my_wami_alert("", "", "", "flash");
		$('#remove_flash').modal();
	}
	if (remove_ind === false) {
		my_wami_alert("No Flash Announcements were chosen to remove. Please check an announcement to remove.", "alert-warning", "Warning! ", "flash");
	}
}

function checkForChosenFlash() {
	var flash_ids_to_remove = [];
	var remove_index = 0;
	var profile_flash_id = (localStorage.getItem("profile_flash_id")).split(",");
	var num_flash_announcements = localStorage.getItem("num_flash_announcements");
	for (var i = 0; i < num_flash_announcements; i++) {
		var checkbox = "flash_checkbox" + i;
		if (document.getElementById(checkbox).checked) {
			flash_ids_to_remove[remove_index] =  profile_flash_id[i];
			remove_index++;
		}
	}
	if (remove_index > 0) {
		localStorage.setItem("flash_ids_to_remove", flash_ids_to_remove);
		return true;
	}
	return false;
}

function update_for_delete_flash() {
	var flash_ids_to_remove = localStorage.getItem("flash_ids_to_remove");
	var params = "flash_ids_to_remove=" + flash_ids_to_remove;
	var url = "update_for_delete_flash.php";
	processData(params, url, "result", false);
	try {
		var flash_data = localStorage.getItem("result");
		var flash_obj = JSON.parse(flash_data);
	} catch (err) {
		console.log(err.message)
		my_wami_alert("update_for_delete_flash: Error deleting Flash data = " + err.message, "alert-danger", "Error!  ", "remove_flash");
		return false;
	}

	var ret_code = flash_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(flash_obj[0].message, "alert-danger", "Alert! ", "remove_flash");
	}
	else {
		my_wami_alert("Flash Announcements succsessfuly removed. ", "alert-success", "Success!  ", "remove_flash");
		refresh_flash();
	}
	return false;
}

function clean_remove_flash_dialog() {
	my_wami_alert("", "", "", "remove_flash");
}
//
// End Flash processing
// -----------------------------------------------

// ----------------------------------------------
// Alert messages
//
function my_wami_alert (message, message_type_class, message_type_string, message_type) {
	if (message_type === "header")  {
		if (message === '') {
			document.getElementById("header_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "image_upload")  {
		if (message === '') {
			document.getElementById("image_upload_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "flash_dialog")  {
		if (message === '') {
			document.getElementById("flash_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "flash")  {
		if (message === '') {
			document.getElementById("flash_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_flash")  {
		if (message === '') {
			document.getElementById("remove_flash_alert").innerHTML = message;
			return;
		}
	}
//	if (message_type === "categories")  {
//		if (message === '') {
//			document.getElementById("new_category_alerts").innerHTML = message;
//			return;
//		}
//	}
//	if (message_type === "profiler_category")  {
//		if (message === '') {
//			document.getElementById("profiler_category_alerts").innerHTML = message;
//			return;
//		}
//	}

	var alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	if (message_type === "header") document.getElementById("header_alerts").innerHTML = alert_str;
	if (message_type === "mywami") document.getElementById("mywami_alerts").innerHTML = alert_str;
	if (message_type === "new_profile") document.getElementById("new_profile_alerts").innerHTML = alert_str;
	if (message_type === "image_upload") document.getElementById("image_upload_alerts").innerHTML = alert_str;
	if (message_type === "flash_dialog") document.getElementById("flash_dialog_alerts").innerHTML = alert_str;
	if (message_type === "flash") document.getElementById("flash_alerts").innerHTML = alert_str;
	if (message_type === "remove_flash") document.getElementById("remove_flash_alert").innerHTML = alert_str;
//	if (message_type === "categories") document.getElementById("new_category_alerts").innerHTML = alert_str;
//	if (message_type === "profiler_category") document.getElementById("profiler_category_alerts").innerHTML = alert_str;
}