/*
 * extendedProfileInfo.js
 * Created by robertlanter on 3/19/14.
 *
 * Show extended profile info from profile collection
 */
$(document).ready(function() {
	var selected_profile_id = localStorage.getItem("selected_profile_id");
	loadData(selected_profile_id);
});

function loadData(selected_profile_id) {
	/**
	 * My Wami Data
	 */
	processData("identity_profile_id=" + selected_profile_id, "get_extended_profile_data.php", "profile_collection_data", false);

	var profile_collection_data = localStorage.getItem("profile_collection_data");
	var profile_collection_obj = JSON.parse(profile_collection_data);

	var ret_code = profile_collection_obj.ret_code;
	var flash_ret_code = profile_collection_obj.flash_ret_code;
	var profiler_ret_code = profile_collection_obj.profiler_ret_code;
	var alert_str = '';
	if (ret_code === -1) {
		my_extended_info_alert(profile_collection_obj.message, "alert-danger", "Alert! ");
		return;
	}

	var image_url = "assets/main_image/" + profile_collection_obj.identity_profile_data[0].image_url + ".png";
	document.getElementById("image").innerHTML =  "<img class='wami-margin-t4' src=" + image_url + ">";

	var profile_name = profile_collection_obj.identity_profile_data[0].profile_name;
	$("#profile_name").val(profile_name);

	var contact_name = profile_collection_obj.identity_profile_data[0].first_name + ' ' + profile_collection_obj.identity_profile_data[0].last_name;
	$("#contact_name").val(contact_name);

	var email = profile_collection_obj.identity_profile_data[0].email;
	$("#email").val(email);

	var profile_type = profile_collection_obj.identity_profile_data[0].profile_type;
	$("#profile_type").val(profile_type);

	var description = profile_collection_obj.identity_profile_data[0].description;
	$("#description").val(description);

	var street_address = profile_collection_obj.identity_profile_data[0].street_address;
	$("#street_address").val(street_address);

	var city = profile_collection_obj.identity_profile_data[0].city;
	$("#city").val(city);

	var state = profile_collection_obj.identity_profile_data[0].state;
	$("#state").val(state);

	var zipcode = profile_collection_obj.identity_profile_data[0].zipcode;
	$("#zipcode").val(zipcode);

	var country = profile_collection_obj.identity_profile_data[0].country;
	$("#country").val(country);

	var telephone = profile_collection_obj.identity_profile_data[0].telephone;
	$("#telephone").val(telephone);

	var tags = profile_collection_obj.identity_profile_data[0].tags;
	$("#tags").val(tags);

	var create_date = profile_collection_obj.identity_profile_data[0].create_date.substr(0, 10);
	$("#create_date").val(create_date);

	/**
	 * Flash Data
	 */
	var flash_announcements = '';
	if (flash_ret_code === 1) {
		flash_announcements = profile_collection_obj.message;
	}
	else {
		for (var i = 0; i < profile_collection_obj.profile_flash_data.length; i++) {
			var date = profile_collection_obj.profile_flash_data[i].create_date;
			var flash = profile_collection_obj.profile_flash_data[i].flash;
			var flash_tag = '';
			var media_url = profile_collection_obj.profile_flash_data[i].media_url;
			var media_tag = '';
			if (media_url != null) {
				media_url = 'assets/' + media_url +  '.png';
				media_tag = '<div class="col-md-1" style="min-width: 75px"><img src="' + media_url + '"style="margin-top: 3px; margin-bottom: 10px"></div>';
				flash_tag = '<div class="col-md-1" style="min-width: 766px">' + flash + '</div>';
			} else {
				flash_tag = '<div class="col-md-1" style="min-width: 870px">' + flash + '</h5></div>';
			}
			flash_announcements = flash_announcements +
					'<a href="#" class="list-group-item" style="padding-top: 3px; padding-bottom: 3px; float: left">' +
					'<div class="col-md-1" style="width: 170px">' +
					'<h5 style="margin-top: 3px; margin-bottom: 3px">' + date + '</h5>' +
					'</div>' +
					media_tag +
					flash_tag +
					'</div></a>';
		}
	}
	document.getElementById("flash_id").innerHTML = flash_announcements;
	load_profiler_categories (selected_profile_id);
}

// -----------------------------------------
// Load Profiler categories
//
function load_profiler_categories (identity_profile_id) {
	localStorage.setItem("identity_profile_id", identity_profile_id);
	var params = "identity_profile_id=" + identity_profile_id;
	processData(params, "get_identity_profiler_data.php", "identity_profiler_data", false);
	try {
		var identity_profiler_data = localStorage.getItem("identity_profiler_data");
		var identity_profiler_obj = JSON.parse(identity_profiler_data);
	} catch (err) {
		console.log(err.message)
		my_extended_info_alert("Error getting data for identity profiler: status = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

// Set up category sections
	var header_section = '';
	document.getElementById("profiler_id").innerHTML = header_section;
	if (identity_profiler_obj.identity_profiler_data !== undefined) {
		var num_categories = identity_profiler_obj.identity_profiler_data.length;
		var identity_profiler_id = [];
		for (var i = 0; i < num_categories; i++) {
			var category = identity_profiler_obj.identity_profiler_data[i].category;
			var media_type = identity_profiler_obj.identity_profiler_data[i].media_type;
			identity_profiler_id[i] = identity_profiler_obj.identity_profiler_data[i].identity_profiler_id;
			header_section = header_section +
					'<div class="panel-group" id="accordionSection' + i + '"> ' +
						'<div class="panel panel-primary" style="border-color: #969696">' +
							'<div class="panel-heading" style="background-color: #e9e9e9; color: #616161; padding-bottom: 5px; height: 40px">' +
								'<h3 class="panel-title">' +
									'<a style="color: #323232" data-toggle="collapse" data-parent="#accordionSection' + i + '" href="#collapseSection' + i + '">' + category +
										'<i class="indicator glyphicon glyphicon-plus-sign pull-right"></i>' +
									'</a>' +
								'</h3>' +
							'</div> ' +
							'<div id="collapseSection' + i + '" class="panel-collapse collapse out">' +
								'<div class="panel-body" style="padding-bottom: 40px">' +
									'<div class="row"  style="height: 40px; padding-left: 10px">' +
										'<div class="col-md-1" style="width: 360px; vertical-align: top">' +
											'<strong>Media Type</strong> ' +
											'<input class="input-wami" type="text" readonly style="background-color: #d1d1d1" value="' + media_type + '">' +
										'</div>' +
									'</div>' +
									'<span class="span-scroll-profile" style="height: 555px; width: 1063px; margin-left: 10px">' +
										'<div style="height: 553px; width: 1050px" id="section_id' + category + '"></div>' +
									'</span>' +
								'</div>' +
							'</div>' +
						'</div>' +
					'</div>';
		}
		document.getElementById("profiler_id").innerHTML = header_section;

// Get content to fill sections
		for (var i = 0; i < identity_profiler_obj.identity_profiler_data.length; i++) {
			category = identity_profiler_obj.identity_profiler_data[i].category;
			localStorage.setItem("category", category);
			media_type = identity_profiler_obj.identity_profiler_data[i].media_type;
			var section_id = '';
			var decorator_section = '';
			var data_section = '';

// Image gallery category
			if (media_type === 'Image') {
				decorator_section =
						'<div class="row" style="padding: 10px; height: 600px; ' +
								'background-image: url(assets/seamlesstexture1_1200.jpg); background-repeat: repeat" >';

				var images = [];
				images = identity_profiler_obj.identity_profiler_data[i].images.images;
				if (images === undefined) {
					data_section =
							'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
									'<h3>No Images to display.</h3>' +
								'</div>';
				}
				else {
					for (var j = 0; j < images.length; j++) {
						var location = images[j].file_location + images[j].file_name;
						var image_name = images[j].image_name;
						if ((image_name === '') || (image_name === undefined) || (image_name === null)) {
							image_name = images[j].file_name;
						}
						data_section =
								'<div class="col-md-2">' +
									'<a class="thumbnail" title="' + image_name + '" href="' + location + '"><img src="' + location + '" width="200%" height="200%"   ></a>' +
									'<label style="padding-left: 5px; padding-bottom: 5px">' + image_name + '</label>' +
								'</div>' + data_section;
					}
				}
				section_id = "section_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section + data_section  + '</div>';
			}

// Text file categories
			if (media_type === 'Text') {
				var file = identity_profiler_obj.identity_profiler_data[i].file.file[0].contents;
				var decorator_section_text =
						'<div class="row" style="padding: 25px; background-repeat: repeat; ' +
								'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
				var data_section_text =
						'<textarea readonly cols="145" rows="25" wrap="hard" style="display: block; margin-right: auto; margin-left: auto">' + file + '</textarea>';

				section_id = "section_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section_text + data_section_text  + '</div>';
			}

// PDF file categories
			if (media_type === 'PDF') {
				var decorator_section_pdf =
						'<div class="row" style="padding: 25px; background-repeat: repeat; ' +
								'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
				var file_name =  identity_profiler_obj.identity_profiler_data[i].file.file[0].file_name;
				var file_location =  identity_profiler_obj.identity_profiler_data[i].file.file[0].file_location;
				var data_section_pdf =
						'<object type="application/pdf" width="100%" height="500px" data="' + file_location + file_name + '"> ';

				section_id = "section_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section_pdf + data_section_pdf  + '</div>';
			}

// Audio file categories
			if (media_type === 'Audio') {
				var data_section_audio = '';
				var decorator_section_audio =
						'<div class="row" style="padding: 25px; height: 550px; background-repeat: repeat; ' +
								'background-image: url(assets/seamlesstexture1_1200.jpg);" >';

				var audio_files = [];
				audio_files = identity_profiler_obj.identity_profiler_data[i].file.audio;
				if (audio_files === undefined) {
					data_section_audio =
							'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
									'<h3>No Audio files found. Use Upload New File button to populate Audio Jukebox.</h3>' +
									'</div>';
				}
				else {
					for (var j = 0; j < audio_files.length; j++) {
						var file_location = audio_files[j].file_location + audio_files[j].file_name;
						var audio_file_name = audio_files[j].audio_file_name;
						if ((audio_file_name === '') || (audio_file_name === undefined) || (audio_file_name === null)) {
							audio_file_name = audio_files[j].file_name;
						}
						data_section_audio =
								'<div class="col-md-2" style="width: 300px">' +
									'<audio controls="controls" style="padding-right: 15px"><source type="audio/mpeg" src="' + file_location + '"/></audio> ' +
									'<label style="padding-left: 5px; padding-bottom: 20px">' + audio_file_name + '</label>' +
								'</div>' + data_section_audio;
					}
				}
				section_id = "section_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section_audio + data_section_audio  + '</div>';
			}
		}
	}
}

// Alert messages
function my_extended_info_alert (message, message_type_class, message_type_string, message_type) {
	var alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	document.getElementById("extended_info_alert").innerHTML = alert_str;

	if (message_type === "header")  {
		if (message === '') {
			document.getElementById("extended_info_alert").innerHTML = message;
			return;
		}
	}
	if (message_type === "header") document.getElementById("extended_info_alert").innerHTML = alert_str;
}
