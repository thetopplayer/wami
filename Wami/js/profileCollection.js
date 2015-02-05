/*
 * profileCollection.js
 * Created by robertlanter on 3/19/14.
 *
 * Load profile collection
 */
//function load_profile_collection() {
$(document).ready(function() {
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data)
	var user_id = obj.user_info[0].user_id;

	//from common.js, loads list of profiles for the current user
	load_profile_list(user_id);

	//Load profile_name_list for datalist used in dropdown Transmit Profile dialog
	processData("", "get_all_profile_names.php", "profile_name_list", false);
	try {
		var profile_name_list_data = localStorage.getItem("profile_name_list");
		var profile_name_list_obj = JSON.parse(profile_name_list_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_all_profile_names: Problem getting profile names list = " + err.message, "alert-danger", "Severe Error!  ", "side_list_placement");
		return;
	}
	var ret_code = profile_name_list_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_name_list_obj.message;
		my_profile_collection_alert (message, "alert-danger", "Alert! ", "side_list_placement");
	}
	var num_names = profile_name_list_obj.profile_name_list.length;
	var profile_names_list = [];
	for (var i = 0; i < num_names; i++) {
		profile_names_list[i] = '<option value="' + profile_name_list_obj.profile_name_list[i].profile_name + '">';
	}
	document.getElementById("profile_name_list").innerHTML = profile_names_list;

	//Determine which collection profile is being used
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var current_identity_profile_id = localStorage.getItem("current_identity_profile_id");
	var extended_info_ind = localStorage.getItem("extended_info_ind");
	if ((current_identity_profile_id !== null) && (extended_info_ind === "true")) {
		localStorage.setItem("extended_info_ind", false);
		var objSelect = document.getElementById("identityProfileList");
		for (var i = 0; i < objSelect.options.length; i++) {
			if (objSelect.options[i].value === current_identity_profile_id) {
				objSelect.options[i].selected = true;
			}
		}
		loadData(current_identity_profile_id);
	}
	else loadData(identity_profile_id);
});

function loadData(identity_profile_id) {
	my_profile_collection_alert("", "", "", "group_data");
	my_profile_collection_alert("", "", "", "side_list_placement");
	localStorage.setItem("extended_info_ind", false);
	localStorage.setItem("from_profile_id", identity_profile_id);
	localStorage.setItem("current_identity_profile_id", identity_profile_id);
	localStorage.setItem("identity_profile_id", identity_profile_id);

	//Load group_name_list for datalist used in Transmit Profile dialog
	//processData("identity_profile_id=" + identity_profile_id, "get_profile_group_data.php", "profile_group", false);
	//try {
	//	var profile_group_data = localStorage.getItem("profile_group");
	//	var profile_group_obj = JSON.parse(profile_group_data);
	//} catch (err) {
	//	console.log(err.message)
	//	my_profile_collection_alert("get_profile_group_data: Problem getting profile group names = " + err.message, "alert-danger", "Severe Error!  ", "side_list_placement");
	//	return;
	//}
	//var ret_code = profile_group_obj.ret_code;
	//if (ret_code === 1) {
	//	var message = profile_group_obj.message;
	//	my_profile_collection_alert (message, "alert-danger", "Alert! ", "side_list_placement");
	//}
	//var num_groups = profile_group_obj.profile_group_data.length;
	//var profile_groups = [];
	//for (var i = 0; i < num_groups; i++) {
	//	profile_groups[i] = '<option value="' + profile_group_obj.profile_group_data[i].group + '">';
	//}
	//document.getElementById("group_name_list").innerHTML = profile_groups;

	var group_filter = localStorage.getItem("group_filter");
	if ((group_filter === 'undefined') || (group_filter === "All") || (group_filter === null) || (group_filter === "")) {
		processData("identity_profile_id=" + identity_profile_id, "get_profile_collection.php", "profile_collection", false);
	}
	else {
		processData("identity_profile_id=" + identity_profile_id + "&profile_group_id=" + group_filter, "get_profile_collection_filtered.php", "profile_collection", false);
	}
	try {
		var wami_data = localStorage.getItem("profile_collection");
		var wami_obj = JSON.parse(wami_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("Problem getting profile collections = " + err.message, "alert-danger", "Severe Error!  ", "side_list_placement");
		return;
	}
	var profile_ret_code = wami_obj.profile_ret_code;
	if (profile_ret_code === 1) {
		message = wami_obj.message;
		my_profile_collection_alert (message, "alert-warning", "Warning! ", "group_data");
	}
	var group_ret_code = wami_obj.group_ret_code;
	if (group_ret_code === 1) {
		message = wami_obj.message;
		my_profile_collection_alert (message, "alert-info", "Info! ", "group_data");
	}

	var list =
		'<div class="col-sm-7" style="max-width: 950px; min-width: 950px; padding-left: 0px">' +
			'<div class="panel panel-primary" style="border-color: #4c4c4c">' +
				'<div class="panel-heading" style="background-color: #c2c2c2; color: #3D3D3D">' +
		'			<h3 class="panel-title">Profile Collection</h3>' +
		'		</div><span class="span-scroll-wami-list">';

	var num_list_elements = wami_obj.profile_collection.length;
	localStorage.setItem("num_list_elements", num_list_elements);
	for (var i = 0; i < num_list_elements; i++) {
		var list_identity_profile_id = wami_obj.profile_collection[i].identity_profile_id;
		var profile_name = wami_obj.profile_collection[i].profile_name;
		if (list_identity_profile_id === identity_profile_id) {
			localStorage.setItem("current_profile_name", profile_name);
		}

		var image_url = "assets/main_image/" + wami_obj.profile_collection[i].image_url + ".png";
		var first_name = wami_obj.profile_collection[i].first_name;
		if (first_name === null) first_name = '';
		var last_name = wami_obj.profile_collection[i].last_name;
		if (last_name === null) last_name = '';
		var contact = first_name + " "  + last_name;
		var tags = wami_obj.profile_collection[i].tags;
		var rating = wami_obj.profile_collection[i].rating;
		var default_profile_ind = wami_obj.profile_collection[i].default_profile_ind;
		if (default_profile_ind === 1) profile_name = profile_name  + '&nbsp;  ' + '<strong>(Default)</strong>';
		if (tags === null) tags = '';

		var groups = '';
		num_groups = wami_obj.profile_group_assign_data.length;
		for (var j = 0; j < num_groups; j++) {
			var profile_group_id = wami_obj.profile_group_assign_data[j].identity_profile_id;
			if (profile_group_id == list_identity_profile_id) {
				groups = wami_obj.profile_group_assign_data[j].group + ', ' + groups;
			}
		}
		groups = groups.substr(0, groups.length - 2);

		list = list +
				'<div class="panel-body wami-panel">' +
					'<div class="col-md-5" style="width: 38%; padding: 0px">' +
						'<label style="vertical-align: top">' +
							'<input type="checkbox" name="' + profile_name + '" value=' + list_identity_profile_id + ' id="checkbox' + i + '">  Choose' +
						'</label>' +
						'<img src="' + image_url  +  '" style="padding-left: 20px">' +
					'</div>' +
					'<div class="col-md-4" style="padding: 0px">' +
						'<div style="vertical-align: top; max-width: 300px; min-width: 280px">' +
							'<strong>Profile Name: </strong> ' + profile_name + '<br> ' +
							'<strong>Contact Name: </strong> ' + contact + '<br> ' +
							'<strong>Tags: </strong> ' + tags + '<br> ' +
							'<strong>Groups: </strong> ' + groups + '<br> ' +
						'</div>' +
					'</div>' +
				'<div class="col-md-3" style="padding-right: 20px; padding-left: 50px">' +
					'<div style="vertical-align: top">' +
						'<button type="button" class="btn-link" style="margin-bottom: 5px" id="extended_info' + i + '" onclick="show_extended_info(this.value)" value="' + list_identity_profile_id + '"><strong>More Info >></strong></button>' +
						'<button type="button" class="btn btn-sm btn-primary btn-block" id="group_assign' + i + '" style="width: 120px; margin-bottom: 10px" onclick="show_group_assign_dialog(this.value)" value="' + list_identity_profile_id + '">Manage Groups</button>' +
						'<button type="button" class="btn btn-sm btn-primary btn-block" id="transmit_profile' + i + '" style="width: 120px; margin-bottom: 10px" onclick="transmit_profile_dialog(this.value)" value="' + list_identity_profile_id + '">Transmit</button>' +
					'</div>' +
				'</div></div><hr>';
	}
	list += "</span></div></div>";
	document.getElementById("list_id").innerHTML=list;

	if ((group_filter === 'undefined') || (group_filter === "All") || (group_filter === null) || (group_filter === "")) {
		create_group_dropdown(identity_profile_id);
	}
	localStorage.setItem("group_filter", "");
}

// -----------------------
// Group processing
//
function create_group_dropdown (identity_profile_id) {
	var params = "identity_profile_id=" + identity_profile_id;
	var url = "get_profile_group_data.php";
	processData(params, url, "result", false);
	try {
		var group_data = localStorage.getItem("result");
		var group_obj = JSON.parse(group_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_profile_group_data: Error getting group data = " + err.message, "alert-danger", "Error!  ", "group_dialog");
		return;
	}
	var ret_code = group_obj.ret_code;
	if (ret_code === -1) {
		my_profile_collection_alert(group_obj[0].message, "alert-danger", "Alert! ", "group_dialog");
		return;
	}
	if (ret_code === 1) {
		my_profile_collection_alert(group_obj[0].message, "alert-info", "Alert! ", "group_dialog");
		return;
	}

	var group = '';
	var group_id = [];
	var group_option = '';
	var group_dropdown = '<select name="groupDropDownList" id="groupDropDownList" class="dropdown-wami" onchange="filter_profile_collection(this.value)">';
	group_option = group_option + '<option value="All">All Groups</option>';
	if (group_obj.profile_group_data !== undefined) {
		for (var i = 0; i < group_obj.profile_group_data.length; i++) {
			group_id[i] = group_obj.profile_group_data[i].profile_group_id;
			group = group_obj.profile_group_data[i].group;
			group_option = group_option + '<option value=' + '"' + group_id[i] + '">' + group + '</option>';
		}
	}
	group_dropdown = group_dropdown + group_option + '</select>';
	localStorage.setItem("group_data", group_data);
	document.getElementById("groupDropDown").innerHTML = group_dropdown;
}

function filter_profile_collection(selected_value) {
	localStorage.setItem("group_filter", selected_value);
	var current_identity_profile_id = localStorage.getItem("current_identity_profile_id");
	loadData(current_identity_profile_id);
}

//
// Manage groups processing
//
function manage_groups(manage_state) {
	var selected_profile_id = localStorage.getItem("selected_profile_id");
	var assign_to_identity_profile_id = localStorage.getItem("current_identity_profile_id");
	var selected_group_id_list = get_checked_groups();
	if (selected_group_id_list === null) {
		my_profile_collection_alert("No Groups selected. Please select groups(s) to assign/remove.", "alert-warning", "Info Alert! ", "assign_group_dialog");
		return;
	}

	selected_group_id_list.join(',');
	var params = "selected_profile_id=" + selected_profile_id + "&assign_to_identity_profile_id=" + assign_to_identity_profile_id + "&selected_group_id_list=" + selected_group_id_list + "&manage_state=" + manage_state;
	var url = "manage_groups.php";
	processData(params, url, "result", false);
	try {
		var manage_assign_group_data = localStorage.getItem("result");
		var manage_assign_group_obj = JSON.parse(manage_assign_group_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("manage_assign_group: Error assigning/removing group data = " + err.message, "alert-danger", "Error!  ", "assign_group_dialog");
		return;
	}
	var ret_code = manage_assign_group_obj.ret_code;
	if (ret_code === -1) {
		my_profile_collection_alert(manage_assign_group_obj.message, "alert-danger", "Alert! ", "assign_group_dialog");
		return;
	}
	if (ret_code === 1) {
		my_profile_collection_alert(manage_assign_group_obj.message, "alert-info", "Alert! ", "assign_group_dialog");
		return;
	}
	var current_profile_id = localStorage.getItem("current_identity_profile_id");
	loadData(current_profile_id);
	my_profile_collection_alert(manage_assign_group_obj.message, "alert-success","Success! ", "assign_group_dialog");
}

//
// Get checked groups processing
//
function get_checked_groups() {
	my_profile_collection_alert("", "", "", "assign_group_dialog");
	var num_groups = localStorage.getItem("num_groups");
	var selected_group_id_list = [];
	var group_selected = false;
	var selected_index = 0;
	for (var i = 0; i < num_groups; i++) {
		var checkbox_id = "group_name" + i;
		if (document.getElementById(checkbox_id).checked) {
			group_selected = true;
			selected_group_id_list[selected_index] = document.getElementById(checkbox_id).value;
			selected_index++;
		}
	}
	if (group_selected) {
		return selected_group_id_list;
	}
	return null;
}

//
// Show groups assigned dialog
//
function show_group_assign_dialog(selected_profile_id) {
	processData("identity_profile_id=" + selected_profile_id, "get_selected_profile_name.php", "result", false);
	try {
		var profile_name_data = localStorage.getItem("result");
		var profile_name_obj = JSON.parse(profile_name_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_selected_profile_name: Error getting Profile Name = " + err.message, "alert-danger", "Error!  ", "group_assign_dialog");
		return;
	}
	var ret_code = profile_name_obj.ret_code;
	if (ret_code === -1) {
		my_profile_collection_alert(profile_name_obj[0].message, "alert-danger", "Alert! ", "group_assign_dialog");
		return;
	}
	if (ret_code === 1) {
		my_profile_collection_alert(profile_name_obj[0].message, "alert-info", "Alert! ", "group_assign_dialog");
		return;
	}
	var selected_profile_name = profile_name_obj.profile_name;

	ret_code = get_group_list(selected_profile_id);
	if (ret_code === null) {
		return;
	}
	var profile_name = localStorage.getItem("current_profile_name");
	var assign_group_title = '<h4 class="modal-title">Assign/Remove ' +
		'<span style="color: #f87c08">' + profile_name + '</span>' + ' groups to/from ' +
		'<span style="color: #f87c08">' + selected_profile_name + '</span></h4>' ;
	document.getElementById("assign_group_title").innerHTML = assign_group_title;
	localStorage.setItem("selected_profile_id", selected_profile_id);
	$('#assign_group').modal();
}

//
// Get groups assigned
//
function get_group_list(selected_profile_id) {
	my_profile_collection_alert("", "", "", "assign_group_dialog");
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "identity_profile_id=" + identity_profile_id + "&selected_profile_id=" + selected_profile_id;
	var url = "get_profile_group_assign_data.php";
	processData(params, url, "result", false);
	try {
		var group_assign_data = localStorage.getItem("result");
		var group_assign_obj = JSON.parse(group_assign_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_profile_group_assign_data: Error getting group data = " + err.message, "alert-danger", "Error!  ", "group_dialog");
		return null;
	}
	var ret_code = group_assign_obj.ret_code;
	if (ret_code === -1) {
		my_profile_collection_alert(group_assign_obj.message, "alert-danger", "Alert! ", "group_dialog");
		return null;
	}
	if (ret_code === 1) {
		my_profile_collection_alert(group_assign_obj.message, "alert-info", "Info! ", "group_dialog");
		//return null;
	}

	var selected_group_ids = [];
	var num_selected_groups = group_assign_obj.profile_group_assign_data.length;
	for (var j = 0 ; j < num_selected_groups; j++) {
		selected_group_ids[j] = group_assign_obj.profile_group_assign_data[j].profile_group_id;
	}

	var group_data = localStorage.getItem("group_data");
	var group_obj = JSON.parse(group_data)
	var group_list = '';
	var selected = false;
	var num_groups = group_obj.profile_group_data.length;
	for (var i = 0; i < num_groups; i++) {
		var group_id = group_obj.profile_group_data[i].profile_group_id;
		var group_name = group_obj.profile_group_data[i].group;
		for (var j = 0;  j < num_selected_groups; j++) {
			if (group_id === selected_group_ids[j]) {
				selected = true;
			}
		}
		if (selected === true) {
			group_list = group_list +
			'<label style="margin-right: 10px">' +
				'<input checked id="group_name' + i + '" name="group_name' + i + '" value="' + group_id + '" type="checkbox"> ' + group_name +
			'</label>';
		}
		else {
			group_list = group_list +
			'<label style="margin-right: 10px">' +
				'<input id="group_name' + i + '" name="group_name' + i + '" value="' + group_id + '" type="checkbox"> ' + group_name +
			'</label>';
		}
		selected = false;
	}
	localStorage.setItem("num_groups", num_groups);
	document.getElementById("profile_group_list").innerHTML = group_list;
}
//
// End Group Processing
//-------------------------

//-------------------------
// Remove selected profiles from collection
//
function removeProfiles() {
	var message = '';
	var list_identity_profile_id = '';
	var param_str = '';
	var assign_to_identity_profile_id = localStorage.getItem("identity_profile_id");
	var num_list_elements = localStorage.getItem("num_list_elements");
	var num_profiles_to_remove = 0;
	for (var i = 0; i < num_list_elements; i++) {
		var checkbox_id = "checkbox" + i;
		if (document.getElementById(checkbox_id).checked) {
			list_identity_profile_id = document.getElementById(checkbox_id).value;

			// not allowed to delete default profile from collection
			if (list_identity_profile_id === assign_to_identity_profile_id) {
				message = "<strong>Starting Profile </strong>cannot be removed.";
				continue;
			}

			param_str = param_str + "identity_profile_id" + num_profiles_to_remove + "=" + list_identity_profile_id + "&";
			num_profiles_to_remove = num_profiles_to_remove + 1;
		}
	}
	if (num_profiles_to_remove == 0) {
		if (message !== '')	my_profile_collection_alert(message, "alert-info", "Info Alert!" +  '&nbsp;  ', "side_list_placement");
		return;
	}
	param_str = param_str.substr(0, param_str.length -1);
	param_str = "assign_to_identity_profile_id=" + assign_to_identity_profile_id + "&num_profiles_to_remove=" + num_profiles_to_remove + "&" + param_str;

	processData(param_str, "update_for_delete_profile_collection.php", "ret_code", false);
	try {
		var collection_data = localStorage.getItem("ret_code");
		var collection_obj = JSON.parse(collection_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("update_for_delete_profile_collection: Problem deleting profiles = " + err.message, "alert-danger", "Severe Error!  ", "side_list_placement");
		return;
	}

	var ret_code = collection_obj.ret_code;
	if (ret_code === -1) {
		var message = collection_obj.message;
		my_profile_collection_alert (message, "alert-danger", "Alert! ", "side_list_placement");
	}

	loadData(assign_to_identity_profile_id);
	if (message !== '')	my_profile_collection_alert(message, "alert-info", "Info Alert! ", "side_list_placement");
}
//
// End Remove
//-------------------------

//-------------------------
// Show Extended info
//
function show_extended_info(selected_profile_id) {
	localStorage.setItem("selected_profile_id", selected_profile_id);

	var element_id = document.getElementById("identityProfileList");
	var current_identity_profile_id = element_id.value;
	localStorage.setItem("current_identity_profile_id", current_identity_profile_id);
	localStorage.setItem("extended_info_ind", true);
	window.document.location.href = 'extended_profile_info.html';
}
//
// End Extended info
//-----------------------

//-----------------------
// Transmit/Remove - Check for checked profiles for "remove" and "transmit"
//
function checkForChosenProfiles(action) {
	my_profile_collection_alert("", "", "", "no_selected_profiles");
	var num_list_elements = localStorage.getItem("num_list_elements");
	for (var i = 0; i < num_list_elements; i++) {
		var checkbox_id = "checkbox" + i;
		if (document.getElementById(checkbox_id).checked) {
			if (action == "remove") {
				$('#remove_profiles').modal();
			}
			if (action == "transmit") {
				var transmit_list = getProfilesToTransmit();
				if (transmit_list == false) return false;
				my_profile_collection_alert ("", "", "", "transmit");
				$("#transmit_to_profile_name").val("");
				$("#transmit_to_email_address").val("");
				$("#transmit_list").val(transmit_list);
				$('#transmit_wami').modal();
			}
			return true;
		}
	}
	my_profile_collection_alert("No Profiles selected. Please select profile(s) to perform action.", "alert-warning", "Info Alert! ", "no_selected_profiles");
	return false;
}

//
// Transmit - Get profiles to Transmit
//
function getProfilesToTransmit () {
	var profile_ids_to_transmit = [];
	var profiles_to_transmit = [];
	var num_list_elements = localStorage.getItem("num_list_elements");
	var element_number = 0;
	for (var i = 0; i < num_list_elements; i++) {
		var checkbox_id = "checkbox" + i;
		if (document.getElementById(checkbox_id).checked) {
			profile_ids_to_transmit[element_number] = document.getElementById(checkbox_id).value;
			profiles_to_transmit[element_number] = document.getElementById(checkbox_id).name;
			profiles_to_transmit[element_number] = check_for_and_clean_up_default_string(profiles_to_transmit[element_number]);
			element_number++;
		}
	}
	var num_profiles_to_transmit = profiles_to_transmit.length;
	if (num_profiles_to_transmit == 0) return false;
	localStorage.setItem("profiles_to_transmit", JSON.stringify(profiles_to_transmit));
	localStorage.setItem("profile_ids_to_transmit", JSON.stringify(profile_ids_to_transmit));
	var transmit_list = '';
	for (var i = 0; i < num_profiles_to_transmit; i++) {
		transmit_list = transmit_list + "; " + profiles_to_transmit[i];
	}
	return transmit_list.substr(2, transmit_list.length);
}

//
// Check if profile is 'Default' profile. If so, string off profile name.
//
function check_for_and_clean_up_default_string(profile_name) {
	if (profile_name.indexOf('Default') === -1) {
		return profile_name;
	}
	return profile_name.substr(0, profile_name.indexOf(' ') -1);
}

//
// Transmit profiles
//
function transmitProfiles() {
	var param_str = '';

	//From profile id
	var from_profile_id = localStorage.getItem("from_profile_id");
	param_str = "from_profile_id=" + from_profile_id  + "&";

	//Profiles chosen to transmit
	var profile_ids_to_transmit = JSON.parse(localStorage.getItem("profile_ids_to_transmit"));
	var num_profiles_to_transmit = profile_ids_to_transmit.length;
	for (var i = 0; i < num_profiles_to_transmit; i++) {
		param_str = param_str + "profile_ids_to_transmit" + i + "=" + profile_ids_to_transmit[i] + "&";
	}
	param_str = "num_profiles_to_transmit=" + num_profiles_to_transmit + "&" + param_str;

	//Transmit to profiles from the Transmit dialog
	var transmit_to_profile_name = document.getElementById("transmit_to_profile_name").value;
	if (transmit_to_profile_name.length > 0) {
		transmit_to_profile_name = transmit_to_profile_name.replace(/\s+/g, '');   //remove all spaces.
		var pos = [];
		// remove last character if its a semi-colon
		if (transmit_to_profile_name.slice(-1) === ";") {
			transmit_to_profile_name = transmit_to_profile_name.slice(0, -1);
		}
		for (var i = 0; i < transmit_to_profile_name.length; i++) {
			if (transmit_to_profile_name[i] === ";") pos.push(i);
		}
		var transmit_str = '';
		var num_transmit_to_profile = pos.length + 1;
		var start_pos = 0;
		var end_pos = 0;
		param_str = param_str + "num_transmit_to_profile=" + num_transmit_to_profile + "&";
		for (var i = 0; i < num_transmit_to_profile; i++) {
			end_pos = pos[i];
			transmit_str = transmit_to_profile_name.slice(start_pos, end_pos);
			//if (transmit_str.length < 7) {
			//	my_profile_collection_alert("Profile names must be seven or more characters: <strong>" + transmit_str + "</strong>", "alert-danger", "Alert! ", "transmit");
			//	return;
			//}
			var result = transmit_str.match(/[^a-zA-Z0-9-_]/g);    //only allow alphanumeric, hyphen, dash
			if (result !== null) {
				my_profile_collection_alert("Profile names must only contain letters, numbers, dashes and hyphens: <strong>" + transmit_str + "</strong>", "alert-danger", "Alert! ", "transmit");
				return;
			}
			start_pos = end_pos + 1;
			param_str = param_str + "transmit_to_profile" + i + "=" + transmit_str + "&"
		}
		param_str = param_str.slice(0, param_str.length - 1);

	//Insert records
		processData(param_str, "insert_transmitted_profile_data.php", "transmit_messages", false);

		//Check results
		var alert_message = [];
		var alert_message_type_class = [];
		var alert_message_type_string = [];
		var alert_message_index = 0;

		try {
			var transmit_messages_data = localStorage.getItem("transmit_messages");
			var transmit_messages_obj = JSON.parse(transmit_messages_data);
		} catch (err) {
			console.log(err.message)
			my_profile_collection_alert("insert_transmitted_profile_data: Problem transmitting profile(s) = " + err.message, "alert-danger", "Severe Error!  ", "transmit");
			return;
		}

		var num_profile_name_not_exist = transmit_messages_obj.num_profile_name_not_exist;
		if (num_profile_name_not_exist > 0) {
			var message = '';
			for (var i = 0; i < num_profile_name_not_exist; i++) {
				alert_message[alert_message_index] = transmit_messages_obj.no_records_found[i];
				alert_message_type_class[alert_message_index] =  "alert-danger";
				alert_message_type_string[alert_message_index] =  "Alert! ";
				alert_message_index++;
			}
		}
		var record_already_exist = transmit_messages_obj.record_already_exist;
		if (record_already_exist.length > 0) {
			for (var i = 0; i < record_already_exist.length; i++) {
				alert_message[alert_message_index] = record_already_exist[i];
				alert_message_type_class[alert_message_index] =  "alert-danger";
				alert_message_type_string[alert_message_index] =  "Alert! ";
				alert_message_index++;
			}
		}
		var num_profiles_transmitted = transmit_messages_obj.num_profiles_transmitted;
		if (num_profiles_transmitted > 0) {
			alert_message[alert_message_index] = "Profile(s) successfully transmitted!";
			alert_message_type_class[alert_message_index] =  "alert-success";
			alert_message_type_string[alert_message_index] =  "Success! ";
		}
		my_profile_collection_alert(alert_message, alert_message_type_class, alert_message_type_string, "transmit");
	}

	// Email profiles
	var transmit_to_email_address = document.getElementById("transmit_to_email_address").value;
	if (transmit_to_email_address.length > 0) {
		transmit_to_email_address = transmit_to_email_address.replace(/\s+/g, '');   //remove all spaces.
		pos = [];
		for (var i = 0; i < transmit_to_email_address.length; i++) {
			if (transmit_to_email_address[i] === ";") pos.push(i);
		}
		transmit_str = '';
		var num_emails = pos.length + 1;
		start_pos = 0;
		end_pos = 0;
		for (var i = 0; i < num_emails; i++) {
			end_pos = pos[i];
			transmit_str = transmit_to_email_address.slice(start_pos, end_pos) + "," + transmit_str;
			start_pos = end_pos + 1;
		}
		transmit_str = transmit_str.slice(0, transmit_str.length - 1);
		var body = '';
		for (var j = 0; j < profile_ids_to_transmit.length; j++) {
			body = getEmailBody(profile_ids_to_transmit[j], from_profile_id, transmit_str) + body;;
			if (body === 1) return;
		}
	//	window.location.href = 'mailto:' + transmit_str + '?subject=Wami Profile(s)&body=' + encodeURI(body);
	}

	if ((transmit_to_profile_name === '') && (transmit_to_email_address === '')) {
		my_profile_collection_alert("Please enter either a Profile Name or Email Address to transmit to.", "alert-warning", "Info Alert! ", "transmit");
	}
}

//
// Transmit profile by choosing transmit button on specific profile
//
function transmit_profile_dialog(selected_profile_id) {
	my_profile_collection_alert ("", "", "", "transmit");
	var param_str = "identity_profile_id=" + selected_profile_id;
	processData(param_str, "get_profile_name.php", "profile_name", false);

	try {
		var profile_name_data = localStorage.getItem("profile_name");
		var profile_name_obj = JSON.parse(profile_name_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_profile_name: Problem getting profile name = " + err.message, "alert-danger", "Severe Error!  ", "transmit");
		return;
	}

	var ret_code = profile_name_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_data_obj.message;
		my_profile_collection_alert (message, "alert-danger", "Alert! ", "transmit");
		return;
	}
	var profile_name = profile_name_obj.profile_name;
	$("#transmit_to_profile_name").val("");
	$("#transmit_to_email_address").val("");
	$("#transmit_list").val(profile_name);
	var profile_ids_to_transmit = [];
	profile_ids_to_transmit[0] = selected_profile_id;
	localStorage.setItem("profile_ids_to_transmit", JSON.stringify(profile_ids_to_transmit));
	$('#transmit_wami').modal();
}

//
// Transmit - to email address
//
function getEmailBody(identity_profile_id, from_profile_id, transmit_str) {
	var param_str = "identity_profile_id=" + identity_profile_id + "&from_identity_profile_id=" + from_profile_id;
	processData(param_str, "get_profile_data.php", "identity_profile_data", false);

	try {
		var profile_data = localStorage.getItem("identity_profile_data");
		var profile_data_obj = JSON.parse(profile_data);
	} catch (err) {
		console.log(err.message)
		my_profile_collection_alert("get_profile_data: Problem getting identity profile data = " + err.message, "alert-danger", "Severe Error!  ", "transmit");
		return;
	}

	var ret_code = profile_data_obj.ret_code;
	if (ret_code === 1) {
		var message = profile_data_obj.message;
		my_profile_collection_alert (message, "alert-danger", "Alert! ", "transmit");
		return 1;
	}

	var profile_name = profile_data_obj.identity_profile_data[0].profile_name;
	var contact_name = profile_data_obj.identity_profile_data[0].first_name + ' ' + profile_data_obj.identity_profile_data[0].last_name;
	var email = profile_data_obj.identity_profile_data[0].email;
	var profile_type = profile_data_obj.identity_profile_data[0].profile_type;
	var description = profile_data_obj.identity_profile_data[0].description;
	var street_address = profile_data_obj.identity_profile_data[0].street_address;
	var city = profile_data_obj.identity_profile_data[0].city;
	var state = profile_data_obj.identity_profile_data[0].state;
	var zipcode = profile_data_obj.identity_profile_data[0].zipcode;
	var country = profile_data_obj.identity_profile_data[0].country;
	var telephone = profile_data_obj.identity_profile_data[0].telephone;
	var tags = profile_data_obj.identity_profile_data[0].tags;
	var create_date = profile_data_obj.identity_profile_data[0].create_date.substr(0, 10);

	var from_first_name = profile_data_obj.identity_profile_data[0].from_first_name;
	var from_last_name = profile_data_obj.identity_profile_data[0].from_last_name;
	var from_profile_name = profile_data_obj.identity_profile_data[0].from_profile_name;
	var from_email = profile_data_obj.identity_profile_data[0].from_email;

	var body =
					"\n" +
					"Profile Name: " + profile_name + "\n" +
					"Contact Name: " + contact_name + "\n" +
					"Email Address: " + email + "\n"        +
					"Profile Type: " + profile_type + "\n" +
					"Description: " + description + "\n"  +
					"Street Address: " + street_address + "\n" +
					"City: " + city + "\n"         +
					"State: " + state + "\n"        +
					"Zipcode: " + zipcode + "\n"      +
					"Country: " + country + "\n"      +
					"Telephone Number: " + telephone + "\n"    +
					"Tags: " + tags + "\n"         +
					"Profile Create Date: " + create_date + "\n\n" +
					"For more detailed Profile info, download the Wami app from the Apple App Store or Google Play! \n" +
					"----------------------------------------------------------------------------------------------\n";
	send_serverside_email(profile_data_obj, transmit_str);
	return(body);
}

//
// Transmit - Configure Server side email to transmit
//
function send_serverside_email(profile_data_obj, transmit_str) {
	var profile_name = profile_data_obj.identity_profile_data[0].profile_name;
	var contact_name = profile_data_obj.identity_profile_data[0].first_name + ' ' + profile_data_obj.identity_profile_data[0].last_name;
	var email = profile_data_obj.identity_profile_data[0].email;
	var profile_type = profile_data_obj.identity_profile_data[0].profile_type;
	var description = profile_data_obj.identity_profile_data[0].description;
	var street_address = profile_data_obj.identity_profile_data[0].street_address;
	var city = profile_data_obj.identity_profile_data[0].city;
	var state = profile_data_obj.identity_profile_data[0].state;
	var zipcode = profile_data_obj.identity_profile_data[0].zipcode;
	var country = profile_data_obj.identity_profile_data[0].country;
	var telephone = profile_data_obj.identity_profile_data[0].telephone;
	var tags = profile_data_obj.identity_profile_data[0].tags;
	var create_date = profile_data_obj.identity_profile_data[0].create_date.substr(0, 10);

	var from_first_name = profile_data_obj.identity_profile_data[0].from_first_name;
	var from_last_name = profile_data_obj.identity_profile_data[0].from_last_name;
	var from_profile_name = profile_data_obj.identity_profile_data[0].from_profile_name;
	var from_email = profile_data_obj.identity_profile_data[0].from_email;

	var message_body =
		'<html><body style="background-color: rgba(204, 255, 254, 0.13)">' +
			'<link href="http://www.mywami.com/css/bootstrap.css" rel="stylesheet">' +
			'<link href="http://www.mywami.com/css/wami.css" rel="stylesheet">' +
			'<script src="http://www.mywami.com/js/jquery-1.11.0.min.js"></script>' +

			'<div class="panel" style="background-color: #606060; height: 45px">' +
				'<img  style="margin-left: 30px; vertical-align: middle" src="http://www.mywami.com/assets/wami-navbar.jpg">' +
			'</div>' +

			'<div style="margin-left: 10px; margin-right: 10px">' +
				'<h4> Wami Profile For: <span style="color: #f87c08">' + profile_name + '</span></h4>' +
				'<h4> From: <span style="color: #f87c08">' + from_first_name + ' ' +  from_last_name + '</span>' + '  Wami Profile: ' + '<span style="color: #f87c08">' + from_profile_name + '</span> </h4>' +
				'<hr>' +
				'<div style="margin-left: 20px; line-height: 10px">' +
					'<h5> Contact Name: <span style="color: #f87c08">' + contact_name  + '</span></h5>' +
					'<h5> Email Address: <span style="color: #f87c08">' + email  + '</span></h5>' +
					'<h5> Profile Type: <span style="color: #f87c08">' + profile_type  + '</span></h5>' +
					'<h5> Description: <span style="color: #f87c08">' + description  + '</span></h5>' +
					'<h5> Street Address: <span style="color: #f87c08">' + street_address  + '</span></h5>' +
					'<h5> City: <span style="color: #f87c08">' + city  + '</span></h5>' +
					'<h5> State: <span style="color: #f87c08">' + state  + '</span></h5>' +
					'<h5> Zip/Postal Code: <span style="color: #f87c08">' + zipcode  + '</span></h5>' +
					'<h5> Country: <span style="color: #f87c08">' + country  + '</span></h5>' +
					'<h5> Telephone: <span style="color: #f87c08">' + telephone  + '</span></h5>' +
					'<h5> Profile Key Words: <span style="color: #f87c08">' + tags  + '</span></h5>' +
					'<h5> Profile Create Date: <span style="color: #f87c08">' + create_date  + '</span></h5>' +
				'</div>' +
				'<hr>' +
				'<div>' +
					'<h5> You can create a WAMI account by going to ' +
						'<a href="http://www.mywami.com"> http://www.mywami.com </a>' +
						'then download the WAMI app from <br><br>' +
						'<img src="http://www.mywami.com/assets/android_app_logo.png">   ' +
						'<img src="http://www.mywami.com/assets/apple_app_logo.png">' +
					'</h5>' +
				'</div>' +
				'<hr>' +
				'<br><br>' +
				'<h6 style="margin-left: 4px; color: #808080">WAMI Logos, Site Design, and Content © 2014 WAMI Inc. All rights reserved. Several aspects of the WAMI site are patent pending.</h6> ' +
				'<p> <img src="http://www.mywami.com/assets/wami-logo-footer.jpg" class="left" ></p>' +
				'<br><br><br>' +
			'</div>' +
		'</body></html>';

	$.ajaxSetup({cache: false});
	var xmlhttp = new XMLHttpRequest();
	var response;
	var param_string = 'x999=' + Math.random() + '&message=' + message_body + "&from_email=" + from_email + "&transmit_to=" + transmit_str;

	xmlhttp.open("POST", "http://www.mywami.com/transmit_profile_to_email_address.php", false);
	xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlhttp.onreadystatechange = function() {
		if (xmlhttp.readyState == 4 ) {
			if (xmlhttp.status == 200)  {
				response = xmlhttp.responseText;
			}
		}
	};
	xmlhttp.send(param_string);
	my_profile_collection_alert("Profile successfully transmitted to email address!", "alert-success","Success! ", "transmit");
}

//
// Transmit - clean up fields in dialog
//
function clean_up_transmit() {
	my_profile_collection_alert ("", "", "", "transmit");
	$("#transmit_to_profile_name").val('');
	$("#transmit_to_email_address").val('')
	//$("#transmit_to_group_name").val('');
}

//
// End Transmit
//----------------------

//----------------------
// Refresh profile collection
//
function refreshCollection() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	loadData(identity_profile_id);
}
//
// End refresh
//---------------------

//----------------------
// Alert messages
//
function my_profile_collection_alert (message, message_type_class, message_type_string, message_placement) {
	var full_message = '';

	if ((message_placement === "no_selected_profiles") || (message_placement === "group_dialog") || (message_placement === "side_list_placement")) {
		if (message === '') {
			document.getElementById("profile_collection_alert").innerHTML = message;
			return;
		}
	}
	if (message_placement === "assign_group_dialog") {
		if (message === '') {
			document.getElementById("assign_group_alert_message").innerHTML = message;
			return;
		}
	}

	if (message_placement === "transmit") {
		if (Array.isArray(message)) {
			for (var i = 0; i < message.length; i++) {
				var message_clean = message[i];
				full_message = full_message + "<div class='alert " + message_type_class[i] + " alert-dismissable'> " +
						"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
						"<strong>" + message_type_string[i] + "</strong> " + message_clean + "</div>";
			}
			document.getElementById("transmit_alert_message").innerHTML = full_message;
			return;
		}
		if (message === '') {
			document.getElementById("transmit_alert_message").innerHTML = message;
			return;
		}
	}

	full_message = "<div class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	if (message_placement === "remove") document.getElementById("remove_alert_message").innerHTML = full_message;
	if (message_placement === "group_data") 	document.getElementById("profile_collection_alert").innerHTML = full_message;
	if (message_placement === "side_list_placement") 	document.getElementById("profile_collection_alert").innerHTML = full_message;
	if (message_placement === "no_selected_profiles") document.getElementById("profile_collection_alert").innerHTML = full_message;
	if (message_placement === "group_dialog") document.getElementById("profile_collection_alert").innerHTML = full_message;
	if (message_placement === "assign_group_dialog") document.getElementById("assign_group_alert_message").innerHTML = full_message;
	if (message_placement === "transmit") document.getElementById("transmit_alert_message").innerHTML = full_message;
}
