/**
 * common.js
 * Created by robertlanter on 5/29/14.
 *
 * Common Javascript functions used more than once in app.
 */
// Alert messages
function my_alert (message, message_type_class, message_type_string) {
	var alert_str = "<div class='alert " + message_type_class + " alert-dismissable' style='width: 590px; margin-bottom: 0; float: right'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	document.getElementById("login_error").innerHTML = alert_str;
}
/*
 * Determine if user has a profile collection. If so, display default collection, if not, display account profile.
 */
function login(username, password) {
	localStorage.clear();
	var params = "username=" + username + "&password=" + password;
	processData(params, 'get_user_data.php', 'user_info', false);
	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data);
	var ret_code = obj.ret_code;
	if (ret_code === -1){
		my_alert(obj.message, "alert-warning", "Warning! ");
		return;
	}

	window.location.assign('profile_collection.html');
}

/*
 * Load drop down list of profiles for current user
 */
function load_profile_list(user_id) {
	processData("user_id=" + user_id, "get_profile_list.php", "identity_profile_list_data", false);
	var identity_profile_list_data = localStorage.getItem("identity_profile_list_data");
	var identity_profile_list_obj = JSON.parse(identity_profile_list_data);
	var profile_list_dropdown = '<select name="identityProfileList" id="identityProfileList" class="dropdown-wami" onchange="loadData(this.value)" >';

	var identity_profile_id = '';
	var profile_list_option = '';
	var selected_identity_profile_id = '';
	for (var i = 0; i < identity_profile_list_obj.identity_profile_list_data.length; i++) {
		var select_profile_name = identity_profile_list_obj.identity_profile_list_data[i].profile_name;
		selected_identity_profile_id = identity_profile_list_obj.identity_profile_list_data[i].identity_profile_id;
		var default_profile_ind = identity_profile_list_obj.identity_profile_list_data[i].default_profile_ind;
		if (default_profile_ind == 1) {
			profile_list_option = profile_list_option + '<option selected value=' + '"' + selected_identity_profile_id + '">' + select_profile_name + " - Default" + '</option>';
			identity_profile_id = selected_identity_profile_id;
			localStorage.setItem("default_identity_profile_id", identity_profile_id);
		}
		else profile_list_option = profile_list_option + '<option value=' + '"' + selected_identity_profile_id + '">' + select_profile_name + '</option>';
	}
	profile_list_dropdown = profile_list_dropdown + profile_list_option + '</select>';
	document.getElementById("identityProfileDropDown").innerHTML = profile_list_dropdown;

	localStorage.setItem("identity_profile_id", identity_profile_id);
}
