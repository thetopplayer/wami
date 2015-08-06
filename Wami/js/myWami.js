/**
 * myWami.js
 * Created by robertlanter on 5/15/14.
 *
 * Load all wami data for a specified profile.
 */
$(document).ready(function(){
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data);
	var user_id = obj.user_info[0].user_id;
	var username = obj.user_info[0].username;
	localStorage.setItem("username", username);

	//from common.js, loads list of profiles for the current user
	load_profile_list(user_id);

	var identity_profile_id = localStorage.getItem("identity_profile_id");
	loadData(identity_profile_id);
});

function loadData(identity_profile_id) {
	my_wami_alert("", "", "", "header");
	my_wami_alert("", "", "", "mywami");
	localStorage.setItem("identity_profile_id", identity_profile_id);
	localStorage.setItem("current_identity_profile_id", identity_profile_id);

// Get number of Wami's for the specified profile_id
	processData("identity_profile_id=" + identity_profile_id, "get_wami_count_for_profile.php", "wami_count", false);
	var wami_count_data = localStorage.getItem("wami_count");
	try {
		var wami_count_obj = JSON.parse(wami_count_data);
		var wami_count = wami_count_obj.wami_count;
	}
    catch (err) {
		console.log(err.message);
		my_wami_alert("Error getting web page: status = " + err.message, "alert-danger", "Severe Error!  ", "header");
	}

	document.getElementById("total_collected_profiles").innerHTML =
			"<input readonly class='input-wami' type='text' value='" + wami_count + "' style='margin-bottom: 10px; text-align: center; width: 50px; background-color: #e5e5e5'>";

// My Wami Data
	var username = localStorage.getItem("username");
	var params = "identity_profile_id=" + identity_profile_id + "&username=" + username;
	processData(params, "get_mywami_data.php", "mywami_data", false);
	try {
		var mywami_data = localStorage.getItem("mywami_data");
		var mywami_obj = JSON.parse(mywami_data);
	}
    catch (err) {
		console.log(err.message);
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
			alert_str = mywami_obj.message[i] + "  " + alert_str;
		}
		my_wami_alert(alert_str, "alert-info", "Info! ", "header");
	}

	//Globalize variable
	window.mywami_obj = mywami_obj;

	var image_url = "assets/main_image/" + mywami_obj.identity_profile_data[0].image_url + ".png";
    var timeInMs = Date.now();
	document.getElementById("image").innerHTML =  "<img class='wami-margin-t4' src=" + image_url + "?dummy=" + timeInMs + ">";

	var profile_name = mywami_obj.identity_profile_data[0].profile_name;
	localStorage.setItem("current_profile_name", profile_name);
	$("#profile_name").val(profile_name);

	var first_name = mywami_obj.identity_profile_data[0].first_name;
	$("#first_name").val(first_name);

	var last_name = mywami_obj.identity_profile_data[0].last_name;
	$("#last_name").val(last_name);

	var email = mywami_obj.identity_profile_data[0].email;
	$("#email").val(email);

	var saved_profile_type = mywami_obj.identity_profile_data[0].profile_type;
	set_profile_type_dropdown(saved_profile_type);

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
	var profile_group_id = [];
	if (mywami_obj.profile_group_data !== undefined) {
		localStorage.setItem("num_groups", mywami_obj.profile_group_data.length);
		for (var i = 0; i < mywami_obj.profile_group_data.length; i++) {
			profile_group_id[i] = mywami_obj.profile_group_data[i].profile_group_id;
			var group = mywami_obj.profile_group_data[i].group;
			groups = groups +
				'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
					'<div class="list-group"><div class="col-md-1" style="width: 3px">' +
						'<input type="checkbox" id="group_checkbox' + i + '">' +
					'</div>' +
					'<div class="col-md-1" style="width: 940px">' +
						'<h5 style="margin-top: 3px; margin-bottom: 3px">' + group + '</h5>' +
					'</div></div>' +
				'</a>';
		}
	}
	localStorage.setItem("profile_group_id", profile_group_id);
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
				flash_tag = '<div class="col-md-2" style="width: 630px;">' + flash + '</div>';
			} else {
				flash_tag = '<div class="col-md-1" style="min-width: 750px; padding-left: 0px">' + flash + '</div>';
			}
			flash_announcements = flash_announcements +
				'<a href="#" class="list-group-item" style="width: 1010px; padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
					'<div class="list-group">' +
						'<div class="col-md-1" style="width: 3px">' +
							'<input type="checkbox" id="flash_checkbox' + i + '">' +
						'</div>' +
						'<div class="col-md-1" style="width: 165px; padding-right: 0px">' +
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
// Get Default identity profile
//
function get_default_identity_profile () {
	my_wami_alert("", "", "", "mywami");
	var active_ind = $('#inactive').val();
	if (active_ind === "inactive") {
		var data = localStorage.getItem("user_info");
		var obj = JSON.parse(data);
		var user_id = obj.user_info[0].user_id;

		processData("user_id=" + user_id, "get_default_identity_profile_id.php", "default_identity_profile_id", false);
		var default_identity_profile_id_data = localStorage.getItem("default_identity_profile_id");
		var default_identity_profile_id_obj = JSON.parse(default_identity_profile_id_data);
		var ret_code = default_identity_profile_id_obj.ret_code;
		if (ret_code === 1) {
			my_wami_alert(default_identity_profile_id_obj.message, "alert-danger", "Alert! ", "mywami");
			return false;
		}
		var default_identity_profile_id = default_identity_profile_id_obj.default_identity_profile_id;

		var identity_profile_id = localStorage.getItem("identity_profile_id");
		if (identity_profile_id === default_identity_profile_id) {
			my_wami_alert("Default Profile can not be made inactive.", "alert-warning", "Alert! ", "mywami");
			return false;
		}
	}
	return true;
}
//
// End Get Default Identity Profile
// ------------------------------------------

// ------------------------------------------
// fill_from_account(): check box function to use data from account for profile
//
function fill_from_account() {
	if ($('#use_account_info').is(':checked')) {
		var data = localStorage.getItem("user_info");
		var obj = JSON.parse(data);
		var user_id = obj.user_info[0].user_id;

		processData("user_id=" + user_id, "get_account_data.php", "account_data", false);
		var account_data = localStorage.getItem("account_data");
		var account_data_obj = JSON.parse(account_data);

		var ret_code = account_data_obj.ret_code;
		if (ret_code === -1) {
			my_wami_alert(account_data_obj.message, "alert-danger", "Alert! ", "mywami");
			return false;
		}

		var first_name = account_data_obj.account_profile[0].first_name;
		$("#first_name").val(first_name);
		var last_name = account_data_obj.account_profile[0].last_name;
		$("#last_name").val(last_name);
		var street_address = account_data_obj.account_profile[0].street_address;
		$("#street_address").val(street_address);
		var city = account_data_obj.account_profile[0].city;
		$("#city").val(city);
		var state = account_data_obj.account_profile[0].state;
		$("#state").val(state);
		var country = account_data_obj.account_profile[0].country;
		$("#country").val(country);
		var zipcode = account_data_obj.account_profile[0].zipcode;
		$("#zipcode").val(zipcode);
		var telephone = account_data_obj.account_profile[0].telephone;
		$("#telephone").val(telephone);
	}
	else {
		$("#street_address").val('');
		$("#city").val('');
		$("#state").val('');
		$("#country").val('');
		$("#zipcode").val('');
		$("#telephone").val('');
	}
	return true;
}
//
// End fill_from_account()
// -----------------------------------------


// -----------------------------------------
// get_profile_type_list(): get list of profile types
//
function set_profile_type_dropdown(saved_profile_type) {
	processData("", "get_profile_types.php", "profile_types", false);
	try {
		var profile_types_data = localStorage.getItem("profile_types");
		var profile_types_obj = JSON.parse(profile_types_data);
	} catch (err) {
		console.log(err.message);
		my_wami_alert("Problem getting profile types list = " + err.message, "alert-danger", "Severe Error!  ", "mywami");
		return;
	}
	var ret_code = profile_types_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_types_obj.message;
		my_wami_alert (message, "alert-danger", "Alert! ", "mywami");
	}

	var profile_types_dropdown = '<select name="profileTypes" id="profileTypes" class="dropdown-wami" style="height: 20px" >';
	var num_types = profile_types_obj.profile_type_list.length;
	var profile_type = '';
	var profile_types_option = '';
	for (var i = 0; i < num_types; i++) {
		profile_type = profile_types_obj.profile_type_list[i].profile_type;
		if (profile_type === saved_profile_type) {
			profile_types_option = profile_types_option + '<option selected value=' + '"' + i + '">' + profile_type + '</option>';
		}
		else {
			profile_types_option = profile_types_option + '<option value=' + '"' + i + '">' + profile_type + '</option>';
		}
	}
	profile_types_dropdown = profile_types_dropdown + profile_types_option + '</select>';
	document.getElementById("profileTypesDropdown").innerHTML = profile_types_dropdown;
}
//
// End get_profile_type_list()
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
		console.log(err.message);
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
		var obj = JSON.parse(data);
		var user_id = obj.user_info[0].user_id;

		//from common.js, loads list of profiles for the current user
		load_profile_list(user_id);

		loadData(default_identity_profile_id);
	}
}

// Change the default profile
function updateDefaultProfile() {
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data);
	var user_id = obj.user_info[0].user_id;

	var identity_profile_id = localStorage.getItem("identity_profile_id");

	var param_str = "identity_profile_id=" + identity_profile_id + "&user_id=" + user_id;
	processData(param_str, "update_default_profile.php", "update_default_profile_data", false);
	try {
		var update_default_profile_data = localStorage.getItem("update_default_profile_data");
		var update_default_profile_obj = JSON.parse(update_default_profile_data);
	} catch (err) {
		console.log(err.message);
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

	//email "lite" validation
	var email = (document.getElementById("email").value).trim();
	if (email === '') {
		my_wami_alert ("Missing Email. Please fill in all required fields.", "alert-danger", "Alert! ", "mywami") ;
		return false;
	}
	if (email.indexOf("@") < 0) {
		my_wami_alert ("Invalid email address. Must contain at least an ampersand and period.", "alert-danger", "Alert! ", "mywami") ;
		return false;
	}
	if (email.indexOf(".") < 0) {
		my_wami_alert ("Invalid email address. Must contain at least an ampersand and period.", "alert-danger", "Alert! ", "mywami") ;
		return false;
	}

	var profile_type_dropdown = document.getElementById("profileTypes");
	var profile_type = profile_type_dropdown.options[profile_type_dropdown.selectedIndex].text;

	var description = (document.getElementById("description").value).trim();
	var street_address = (document.getElementById("street_address").value).trim();
	var city = (document.getElementById("city").value).trim();
	var state = (document.getElementById("state").value).trim();
	var country = (document.getElementById("country").value).trim();
	var zipcode = (document.getElementById("zipcode").value).trim();
	var telephone = (document.getElementById("telephone").value).trim();
	var tags = (document.getElementById("tags").value).trim();
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
		console.log(err.message);
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

	var result = (profile_name).match(/[^a-zA-Z0-9-_]/g);    //only allow alphanumeric, hyphen, underscore
	if (result !== null) {
		my_wami_alert("Profile names must only contain letters, numbers, underscore, hyphens, and no spaces", "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	if (email === '') {
		my_wami_alert ("Missing Email. Please add an email address.", "alert-danger", "Alert! ", "new_profile");
		return false;
	}

	var result_obj = check_new_profile(profile_name);
	var ret_code = result_obj.ret_code;
	if (ret_code != 0) {
		my_wami_alert(result_obj.message, "alert-danger", "Alert! ", "new_profile");
		return false;
	}
	else {
		var data = localStorage.getItem("user_info");
		var obj = JSON.parse(data);
		var user_id = obj.user_info[0].user_id;
		result_obj = insert_new_profile(profile_name, email, user_id);
		if (result_obj.ret_code != 0) {
			my_wami_alert(result_obj.message, "alert-danger", "Alert! ", "new_profile");
			return false;
		}
		message = "Profile was created and was added to your collection. Use the rest of the My Wami Profiles page to finish entering your profile information.";
		my_wami_alert(message, "alert-success", "Success!  ", "new_profile");
		load_profile_list(user_id); //located in common.js
		return true;
	}
}

// Check for valid profile name. Duplicates are not allowed
function check_new_profile(profile_name) {
	var url = "check_profile_name.php";
	var params = "profile_name=" + profile_name;
	var identifier = "result";

	processData(params, url, identifier, false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message);
		return ("check_profile_name: Error checking for duplicate profile name = " + err.message);
	}

	return result_obj;
}

// Insert new account
function insert_new_profile(profile_name, email, user_id) {
	var params = "profile_name=" + profile_name + "&email=" + email + "&user_id=" + user_id;
	var url = "insert_new_profile_data.php";
	processData(params, url, "result", false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message);
		my_wami_alert("insert_new_profile_data: Error inserting new profile = " + err.message, "alert-danger", "Error!  ", "mywami");
		return ("insert_new_profile_data: Error inserting new profile = " + err.message);
	}

	return result_obj;
}

function upload_new_profile_image() {
	my_wami_alert("", "", "", "image_upload");

	//get file and check type
	var file = document.getElementById('new_profile_image').files[0];
	var imageType = /image.*/;
	if (!file.type.match(imageType)) {
		my_wami_alert("File must be either a .jpg, .png, or ,gif image type.", "alert-danger", "Error!  ", "image_upload");
		return;
	}

    var file_size = file.size;
    if (file_size > 500000000) {
        my_wami_alert("File not uploaded. There is a 500MB limit on the size of image files.", "alert-danger", "Error!  ", "image_upload");
        return;
    }

	var preview = new Image();
    var profile_image = new Image();
	var reader  = new FileReader();
	var byte_reader = new FileReader();
	var image_id = document.getElementById("image");

	if (file) {
		reader.readAsDataURL(file);
		byte_reader.readAsDataURL(file);
	} else {
		preview.src = "";
	}

    //display image on web page. First reduce in size
    reader.onload =
		function () {
			image_id.innerHTML = "";
			preview.src = reader.result;
            var orig_height = preview.height;
            var orig_width = preview.width;
            var ratio = Math.min(130 / orig_width, 130 / orig_height);
            if (orig_height > 130) {
                preview.height = orig_height * ratio;
            }
            else {
                preview.height = orig_height;
            }
            if (orig_width > 130) {
                preview.width = orig_width * ratio;
            }
            else {
                preview.width = orig_width;
            }
			image_id.appendChild(preview);
		};

    //save to file system and database
	byte_reader.onload =
		function () {
            profile_image.src = byte_reader.result;

            //reduce size to thumbnail and save.
            var canvas = document.createElement('canvas');
            var orig_height = profile_image.height;
            var orig_width = profile_image.width;
            var ratio = Math.min(130 / orig_width, 130 / orig_height);
            if (orig_height > 130) {
                canvas.height = orig_height * ratio;
            }
            else {
                canvas.height = orig_height;
            }
            if (orig_width > 130) {
                canvas.width = orig_width * ratio;
            }
            else {
                canvas.width = orig_width;
            }
            var ctx = canvas.getContext("2d");
            ctx.drawImage(profile_image, 0, 0, canvas.width, canvas.height);
            var dataurl = canvas.toDataURL();

            var identity_profile_id = localStorage.getItem("identity_profile_id");
			//change file type to .png if its a jpg or gif. Keeps it compatible with android
			var file_name = file.name;
			var file_name_type_check = file_name.slice(file_name.lastIndexOf('.'));
			if (file_name_type_check !== '.png') {
				file_name = file_name.slice(0, file_name.indexOf('.')) + ".png";
			}

			var params = "file_name=" + file_name + "&image_src=" + dataurl + "&identity_profile_id=" + identity_profile_id;
			var url = "update_new_profile_image_data.php";
			processData(params, url, "result", false);
			try {
				var result_data = localStorage.getItem("result");
				var result_obj = JSON.parse(result_data);
			} catch (err) {
					console.log(err.message);
					my_wami_alert("update_new_profile_image_data: Error updating new profile image = " + err.message, "alert-danger", "Error!  ", "image_upload");
					return;
			}

			var ret_code = result_obj.ret_code;
			if (ret_code === -1) {
				my_wami_alert(result_obj.message, "alert-danger", "Error!  ", "image_upload");
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
		console.log(err.message);
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
		console.log(err.message);
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
				flash_tag = '<div class="col-md-1" style="min-width: 750px; padding-left: 0px">' + flash + '</div>';
			}
			flash_announcements = flash_announcements +
					'<a href="#" class="list-group-item" style="width: 1010px; padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
						'<div class="list-group">' +
							'<div class="col-md-1" style="width: 3px">' +
								'<input type="checkbox" id="flash_checkbox' + i + '">' +
							'</div>' +
							'<div class="col-md-1" style="width: 165px; padding-right: 0px">' +
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
		console.log(err.message);
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


// -------------------------------------------
// Group processing
//
function add_group() {
	$('#new_group_dialog').modal();
	my_wami_alert("", "", "", "group_dialog");
}

function save_group () {
	var new_group = (document.getElementById('new_group').value).trim();
	if (new_group === '') {
		my_wami_alert("Group name cannot be empty. Please create a group or close.", "alert-warning", "Warning!  ", "group_dialog");
		return;
	}
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "new_group=" + new_group + "&identity_profile_id=" + identity_profile_id;
	var url = "insert_group.php";
	processData(params, url, "result", false);
	try {
		var result_data = localStorage.getItem("result");
		var result_obj = JSON.parse(result_data);
	} catch (err) {
		console.log(err.message);
		my_wami_alert("insert_group: Error inserting a new Group = " + err.message, "alert-danger", "Error!  ", "group_dialog");
		return;
	}

	var ret_code = result_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(result_obj.message, "alert-danger", "Danger!  ", "group_dialog");
		return;
	}
	if (ret_code === 1) {
		my_wami_alert(result_obj.message, "alert-warning", "Warning!  ", "group_dialog");
		return;
	}
	refresh_group();
	my_wami_alert(result_obj.message, "alert-success", "Success!  ", "group_dialog");
}


function refresh_group() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "identity_profile_id=" + identity_profile_id;
	var url = "get_profile_group_data.php";
	processData(params, url, "result", false);
	try {
		var group_data = localStorage.getItem("result");
		var group_obj = JSON.parse(group_data);
	} catch (err) {
		console.log(err.message);
		my_wami_alert("get_profile_group_data: Error getting group data = " + err.message, "alert-danger", "Error!  ", "group_dialog");
		return;
	}
	var ret_code = group_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(group_obj[0].message, "alert-danger", "Alert! ", "group_dialog");
		return;
	}
	if (ret_code === 1) {
		my_wami_alert(group_obj[0].message, "alert-info", "Alert! ", "group_dialog");
		return;
	}

	var groups = '';
	var profile_group_id = [];
	if (group_obj.profile_group_data !== undefined) {
		localStorage.setItem("num_groups", group_obj.profile_group_data.length);
		for (var i = 0; i < group_obj.profile_group_data.length; i++) {
			profile_group_id[i] = group_obj.profile_group_data[i].profile_group_id;
			var group = group_obj.profile_group_data[i].group;
			var group_tag = '';
			group_tag = '<div class="col-md-1" style="min-width: 870px">' + group + '</div>';
			groups = groups +
			'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left; background-color: #f3f3f3">' +
				'<div class="list-group">' +
					'<div class="col-md-1" style="width: 3px">' +
						'<input type="checkbox" id="group_checkbox' + i + '">' +
					'</div>' +
					group_tag +
				'</div>' +
			'</a>';
		}
	}
	localStorage.setItem("profile_group_id", profile_group_id);
	document.getElementById("group_id").innerHTML = groups;
}

function remove_groups() {
	var remove_ind = check_for_chosen_group();
	if (remove_ind === true) {
		my_wami_alert("", "", "", "group");
		$('#remove_group').modal();
	}
	if (remove_ind === false) {
		my_wami_alert("No Group(s) were chosen to remove. Please check a group to remove.", "alert-warning", "Warning! ", "group");
	}
}

function check_for_chosen_group() {
	var group_ids_to_remove = [];
	var remove_index = 0;
	var profile_group_id = (localStorage.getItem("profile_group_id")).split(",");
	var num_groups = localStorage.getItem("num_groups");
	for (var i = 0; i < num_groups; i++) {
		var checkbox = "group_checkbox" + i;
		if (document.getElementById(checkbox).checked) {
			group_ids_to_remove[remove_index] =  profile_group_id[i];
			remove_index++;
		}
	}
	if (remove_index > 0) {
		localStorage.setItem("group_ids_to_remove", group_ids_to_remove);
		return true;
	}
	return false;
}

function update_for_delete_group() {
	var group_ids_to_remove = localStorage.getItem("group_ids_to_remove");
	var params = "group_ids_to_remove=" + group_ids_to_remove;
	var url = "update_for_delete_group.php";
	processData(params, url, "result", false);
	try {
		var group_data = localStorage.getItem("result");
		var group_obj = JSON.parse(group_data);
	} catch (err) {
		console.log(err.message);
		my_wami_alert("update_for_delete_group: Error deleting Group data = " + err.message, "alert-danger", "Error!  ", "remove_group");
		return false;
	}

	var ret_code = group_obj.ret_code;
	if (ret_code === -1) {
		my_wami_alert(group_obj[0].message, "alert-danger", "Alert! ", "remove_group");
	}
	else {
		my_wami_alert("Group(s) succsessfuly removed. ", "alert-success", "Success!  ", "remove_group");
		refresh_group();
	}
	return false;
}

function clean_remove_group_dialog() {
	my_wami_alert("", "", "", "remove_group");
}
//
// End Group processing
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
	if (message_type === "mywami")  {
		if (message === '') {
			document.getElementById("mywami_alerts").innerHTML = message;
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
	if (message_type === "group_dialog")  {
		if (message === '') {
			document.getElementById("group_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "flash")  {
		if (message === '') {
			document.getElementById("flash_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "group")  {
		if (message === '') {
			document.getElementById("group_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_flash")  {
		if (message === '') {
			document.getElementById("remove_flash_alert").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_group")  {
		if (message === '') {
			document.getElementById("remove_group_alert").innerHTML = message;
			return;
		}
	}

	var alert_str = "<div style='margin-bottom: 10px ' + class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	if (message_type === "header") document.getElementById("header_alerts").innerHTML = alert_str;
	if (message_type === "mywami") document.getElementById("mywami_alerts").innerHTML = alert_str;
	if (message_type === "new_profile") document.getElementById("new_profile_alerts").innerHTML = alert_str;
	if (message_type === "image_upload") document.getElementById("image_upload_alerts").innerHTML = alert_str;
	if (message_type === "flash_dialog") document.getElementById("flash_dialog_alerts").innerHTML = alert_str;
	if (message_type === "group_dialog") document.getElementById("group_dialog_alerts").innerHTML = alert_str;
	if (message_type === "flash") document.getElementById("flash_alerts").innerHTML = alert_str;
	if (message_type === "group") document.getElementById("group_alerts").innerHTML = alert_str;
	if (message_type === "remove_flash") document.getElementById("remove_flash_alert").innerHTML = alert_str;
	if (message_type === "remove_group") document.getElementById("remove_group_alert").innerHTML = alert_str;
}