/*
 * processAccount.js
 *
 * Created by robertlanter on 3/19/14.
 *
 * Functions dealing with a user account, creating and managing.
 *
 */

// Load data
function loadData() {
	var data = localStorage.getItem("user_info");

	if (data == null) {
		var username = localStorage.getItem("username");
		var password = localStorage.getItem("password");

		var params = 'username=' + username + '&password=' + password;
		processData(params, 'get_user_data.php', 'user_info', false);
		data = localStorage.getItem("user_info");
	}

	var obj = JSON.parse(data);
	var user_id = obj.user_info[0].user_id;
	processData("user_id=" + user_id, "get_account_data.php", "account_profile_data", false);
	var account_profile = localStorage.getItem("account_profile_data");
	var account_profile_obj = JSON.parse(account_profile);

	var ret_code = account_profile_obj.ret_code;
	if (ret_code === -1) {
		my_account_alert(account_profile_obj.message, "alert-danger", "Alert! ", "account_alert");
		return false;
	}

	var first_name = account_profile_obj.account_profile[0].first_name;
	var last_name = account_profile_obj.account_profile[0].last_name;
	username = account_profile_obj.account_profile[0].username;
	password = account_profile_obj.account_profile[0].password;
	var email = account_profile_obj.account_profile[0].email;
	var street_address = account_profile_obj.account_profile[0].street_address;
	var city = account_profile_obj.account_profile[0].city;
	var state = account_profile_obj.account_profile[0].state;
	var country = account_profile_obj.account_profile[0].country;
	var zipcode = account_profile_obj.account_profile[0].zipcode;
	var telephone = account_profile_obj.account_profile[0].telephone;
	var create_date = account_profile_obj.account_profile[0].create_date,
			create_date_formatted = create_date.substr(0, 10);
	//var active_ind = account_profile_obj.account_profile[0].active_ind;
	//var radio = '';
	//if (active_ind == 1) {
	//	radio = $('#active');
	//	radio[0].checked = true;
	//	radio.button("refresh");
	//}
	//else {
	//	radio = $('#inactive');
	//	radio[0].checked = true;
	//	radio.button("refresh");
	//}

	$("#first_name").val(first_name);
	$("#last_name").val(last_name);
	$("#username_val").val(username);
	$("#password_val").val(password);
	$("#retype_password").val(password);
	$("#email").val(email);
	$("#street_address").val(street_address);
	$("#city").val(city);
	$("#state").val(state);
	$("#country").val(country);
	$("#zipcode").val(zipcode);
	$("#telephone").val(telephone);
	$("#create_date").val(create_date_formatted);

	processData("user_id=" + user_id, "get_profile_count_for_user.php", "profile_count");
	var profile_count_data = localStorage.getItem("profile_count");
	var profile_count_obj = JSON.parse(profile_count_data);
	var profile_count = profile_count_obj.profile_count;
	$("#profile_count").val(profile_count);

	return true;
}

// Clear all fields except username inaccount_profile.html page
function clearAccountData() {
	my_account_alert ("", "", "", "account_alert") ;
	$("#first_name").val('');
	$("#last_name").val('');
	$("#password_val").val('');
	$("#retype_password").val('');
	$("#email").val('');
	$("#street_address").val('');
	$("#city").val('');
	$("#state").val('');
	$("#country").val('');
	$("#zipcode").val('');
	$("#telephone").val('');
}

// Delete account
function deleteAccount() {
	my_account_alert ("", "", "", "account_alert") ;
	var user_info = localStorage.getItem("user_info");
	var user_info_obj = JSON.parse(user_info);
	var user_id = user_info_obj.user_info[0].user_id;

	var params = "user_id=" + user_id;
	processData(params, "update_for_delete_account.php", "update_account_data");

	var update_account_data = localStorage.getItem("update_account_data");
	var update_account_obj = JSON.parse(update_account_data);
	var ret_code = update_account_obj.ret_code;
	if (ret_code !== 0) {
		my_account_alert(update_account_obj.message, "alert-danger", "Alert! ", "account_alert");
	}
	else {
		my_account_alert(update_account_obj.message, "alert-success", "Success! ", "account_alert");
		this.document.location.href = "http://localhost:80/Wami/index.html";
	}
	return false;
}

function validateAccountData(account_status) {
	my_account_alert ("", "", "", "account_alert") ;
	var ret_code = validateAccount(account_status);
	if (ret_code === false) return false;


	var result_obj = checkAccount(account_status);
	if (result_obj.ret_code != 0) {
		my_account_alert(result_obj.message, "alert-danger", "Alert! ", "account_alert");
		return false;
	}

	if (account_status === 'new') {
		var result_obj = checkProfileName();
		if (result_obj.ret_code != 0) {
			my_account_alert(result_obj.message, "alert-danger", "Alert! ", "account_alert");
			return false;
		}
		result_obj = insertAccount();
		ret_code = result_obj.ret_code;
		if (ret_code === -1) {
			my_account_alert(result_obj.message, "alert-danger", "Alert! ", "account_alert");
			return false;
		}
		localStorage.setItem("username", username_val.value);
		localStorage.setItem("password", password_val.value);
		var params = "username=" + username_val.value + "&password=" + password_val.value;
		processData(params, 'get_user_data.php', 'user_info', false);
		var data = localStorage.getItem("user_info");
		var obj = JSON.parse(data);
		var ret_code = obj.ret_code;
		if (ret_code === -1){
			my_account_alert("Problem getting user data.", "alert-warning", "Warning! ", "account_alert");
			return false;
		}

		return true;
	}
	if (account_status === 'update') {
		result_obj = saveAccountData();
		ret_code = result_obj.ret_code;
		if (ret_code === 0) {
			my_account_alert(result_obj.message, "alert-success", "Success!  ", "account_alert");
		}
		else {
			my_account_alert(result_obj.message, "alert-danger", "Alert!  ", "account_alert");
		}
		return false;
	}
}

// Check account for valid username and email address. Duplicates are not allowed
function checkAccount(account_status) {
	my_account_alert ("", "", "", "account_alert") ;
	var url = "check_account_data.php";
	var username = (document.getElementById("username_val").value).trim();
	var email = (document.getElementById("email").value).trim();
	var params = "username=" + username + "&email=" + email + "&account_status=" + account_status;
	var identifier = "result";

	var message;
	processData(params, url, identifier, false);
	var result_data = localStorage.getItem("result");
	var result_obj = JSON.parse(result_data);

	return result_obj;
}

// Check account for valid username and email address. Duplicates are not allowed
function checkProfileName() {
	my_account_alert ("", "", "", "account_alert") ;
	var url = "check_profile_name.php";
	var profile_name = (document.getElementById("first_profile_name").value).trim();
	var params = "profile_name=" + profile_name;
	var identifier = "result";

	var message;
	processData(params, url, identifier, false);
	var result_data = localStorage.getItem("result");
	var result_obj = JSON.parse(result_data);

	return result_obj;
}

// Validate all required fields
function validateAccount(account_status) {
	my_account_alert("", "", "", "account_alert");

	//username validation
	if ((username_val.value).trim() == '') {
		my_account_alert("Missing Account Username. Please fill in all required fields.", "alert-danger", "Alert! ", "account_alert");
		return false;
	}
	var result = ((username_val.value).trim()).match(/[^a-zA-Z0-9-_]/g);    //only allow alphanumeric, hyphen, dash
	if (result !== null) {
		my_account_alert("Account Username must only contain letters, numbers, underscores and hyphens", "alert-danger", "Alert! ", "account_alert");
		return false;
	}

	// Password validations
	if ((password_val.value).trim() == '') {
		my_account_alert ("Missing Password. Please fill in all required fields.", "alert-danger", "Alert! ", "account_alert") ;
		return false;
	}
	//At least 8 chars, at least 1 upper and lower case letter, at least 1 number, at least one special char.
	result = ((password_val.value).trim()).match(/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-_]).{8,}$/g);
	if (result === null) {
        my_account_alert("Wami requires a strong password as explained below. Even though this might seem like a burden, having this kind of security will " +
            "help keep Wami info safe from hackers.", "alert-info", "Alert! ", "account_alert_info");

		my_account_alert("Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number," +
		" and at least 1 of the following characters: # ? ! @ $ % ^ & * - _", "alert-danger", "Alert! ", "account_alert");
		return false;
	}
	if ((retype_password.value).trim() == '') {
		my_account_alert ("Please retype password.", "alert-danger", "Alert! ", "account_alert") ;
		return false;
	}
	if ((password_val.value).trim() != (retype_password.value).trim()) {
		my_account_alert ("Passwords do not match. Please retype password.", "alert-danger", "Alert! ", "account_alert") ;
		return false;
	}

	//email "lite" validation
	if ((email.value).trim() == '') {
		my_account_alert("Missing Email. Please fill in all required fields.", "alert-danger", "Alert! ", "account_alert");
		return false;
	}
	if (((email.value).trim()).indexOf("@") < 0) {
		my_account_alert("Invalid email address. Must contain at least an ampersand and period.", "alert-danger", "Alert! ", "account_alert");
		return false;
	}
	if (((email.value).trim()).indexOf(".") < 0) {
		my_account_alert("Invalid email address. Must contain at least an ampersand and period.", "alert-danger", "Alert! ", "account_alert");
		return false;
	}

	//first profile name validation
	if (account_status === "new") {
		if ((first_profile_name.value).trim() == '') {
			my_account_alert("Missing Profile name. Please fill in all required fields.", "alert-danger", "Alert! ", "account_alert");
			return false;
		}
		result = ((first_profile_name.value).trim()).match(/[^a-zA-Z0-9-_]/g);    //only allow alphanumeric, hyphen, dash
		if (result !== null) {
			my_account_alert("Profile names must only contain letters, numbers, underscores and hyphens", "alert-danger", "Alert! ", "account_alert");
			return false;
		}
	}

	return true;
}

// Save data
function saveAccountData() {
	my_account_alert ("", "", "", "account_alert") ;
	var first_name = (document.getElementById("first_name").value).trim();
	var last_name = (document.getElementById("last_name").value).trim();
	var password = (document.getElementById("password_val").value).trim();
	var email = (document.getElementById("email").value).trim();
	var street_address = (document.getElementById("street_address").value).trim();
	var city = (document.getElementById("city").value).trim();
	var state = (document.getElementById("state").value).trim();
	var country = (document.getElementById("country").value).trim();
	var zipcode = (document.getElementById("zipcode").value).trim();
	var telephone = (document.getElementById("telephone").value).trim();
	var active_ind = 1;

	var data = localStorage.getItem("user_info");
	var obj = JSON.parse(data);
	var user_id = obj.user_info[0].user_id;

	var params = "user_id=" + user_id + "&first_name=" + first_name + "&last_name=" + last_name
		+ "&password=" + password + "&email=" + email
		+ "&street_address=" + street_address + "&city=" + city
		+ "&state=" + state + "&country=" + country
		+ "&zipcode=" + zipcode + "&telephone=" + telephone
		+ "&active_ind=" + active_ind;

	processData(params, "update_account_data.php", "result");
	var result_data = localStorage.getItem("result");
	var result_obj = JSON.parse(result_data);
	return result_obj;
}

// Insert new account
function insertAccount() {
	my_account_alert ("", "", "", "account_alert") ;
	var username = (document.getElementById("username_val").value).trim();
	var password = (document.getElementById("password_val").value).trim();
	var first_name = (document.getElementById("first_name").value).trim();
	var last_name = (document.getElementById("last_name").value).trim();
	var profile_name = (document.getElementById("first_profile_name").value).trim();
	var email = (document.getElementById("email").value).trim();
	var tele_number = (document.getElementById("tele_number").value).trim();
	var first_profile_description = (document.getElementById("first_profile_description").value).trim();

	var params = "first_name=" + first_name + "&last_name=" + last_name + "&profile_name=" + profile_name
			+ "&password=" + password + "&email=" + email + "&tele_number=" + tele_number + "&first_profile_description=" + first_profile_description
			+ "&username=" + username;

	var url = "insert_new_account_data.php";
	processData(params, url, "result", false);
	var result_data = localStorage.getItem("result");
	var result_obj = JSON.parse(result_data);

	return result_obj;
}

// Alert messages
function my_account_alert (message, message_type_class, message_type_string, message_type) {
	var alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";

    if (message_type === "account_alert_info") document.getElementById("account_alert_info").innerHTML = alert_str;
	if (message_type === "account_alert") document.getElementById("account_alert").innerHTML = alert_str;
	if (message === '') {
		document.getElementById("account_alert").innerHTML = message;
        document.getElementById("account_alert_info").innerHTML = message;
	}
}