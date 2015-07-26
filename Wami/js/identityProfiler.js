/*
 * identityProfiler.js
 * Created by robertlanter on 9/17/14.
 *
 * All functions for Identity Profiler engine.
 */

// -----------------------------------------
// Load Profiler categories
//
function load_profiler_categories (identity_profile_id) {
	localStorage.setItem("identity_profile_id", identity_profile_id);
	var params = "identity_profile_id=" + identity_profile_id;
	processData(params, "get_profiler_data.php", "identity_profiler_data", false);
	try {
		var identity_profiler_data = localStorage.getItem("identity_profiler_data");
		var identity_profiler_obj = JSON.parse(identity_profiler_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("Error getting data for identity profiler: status = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

// Check return code and messages from get_profiler_data.php
	var ret_code = identity_profiler_obj.ret_code;
	var alert_str = '';
	if (ret_code === -1) {
		my_identity_profiler_alert(identity_profiler_obj[0].message, "alert-danger", "Alert! ", "header");
		return;
	}
	if (ret_code > 0) {
		var num_ele = identity_profiler_obj.message.length;
		alert_str = '';
		for (var i = 0; i < num_ele; i++) {
			alert_str = "<br>" + identity_profiler_obj.message[i] + alert_str;
		}
		my_identity_profiler_alert(alert_str, "alert-info", "Info! ", "header");
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
					'<div class="panel-group" id="accordionSection' +  i + '"> ' +
						'<div class="panel panel-primary" style="border-color: #969696">' +
							'<div class="panel-heading" style="background-color: #e9e9e9; color: #616161; padding-bottom: 5px">'+
								'<h3 class="panel-title"><input type="checkbox" value="' + identity_profiler_id[i] + '" id="category_checkbox' + i + '" style="margin-right: 10px; margin-bottom: 7px">' +
									'<a style="color: #323232" data-toggle="collapse" data-parent="#accordionSection' + i + '" href="#collapseSection' +  i + '">' +  category +
										'<i class="indicator glyphicon glyphicon-plus-sign pull-right"></i>' +
									'</a>' +
								'</h3>' +
							'</div> ' +
							'<div id="collapseSection' + i + '" class="panel-collapse collapse out">' +
								'<div class="panel-body" style="padding-bottom: 40px">' +
									'<div class="row"  style="height: 40px; padding-left: 10px">'  +
										'<div class="col-md-1" style="width: 360px; vertical-align: top">' +
											'<strong>Media Type</strong> ' +
											'<input class="input-wami" type="text" readonly style="background-color: #d1d1d1" value="'  +  media_type + '">' +
										'</div>' +
									'</div>' +
									'<span class="span-scroll-profile" style="height: 555px; width: 965px; margin-left: 10px">' +
										'<div style="height: 553px; width: 965px" id="section_id' + category + '"></div>' +
									'</span>' +
									'<div id="actions_id' + category + '"></div>' +
								'</div>' +
							'</div>' +
						'</div>' +
					'</div>';
		}
		document.getElementById("profiler_id").innerHTML = header_section;
        localStorage.setItem("displayed_category_count", num_categories);

// Get content to fill sections
		for (var i = 0; i < identity_profiler_obj.identity_profiler_data.length; i++) {
			category = identity_profiler_obj.identity_profiler_data[i].category;
			localStorage.setItem("category", category);
			media_type = identity_profiler_obj.identity_profiler_data[i].media_type;
			var section_id = '';
			var actions_id = '';
			var decorator_section = '';
			var data_section = '';

// Image gallery category
			if (media_type === 'Image') {
				decorator_section = '<div class="row" style="padding: 10px; height: 600px;  background-color: #d1d1d1">';

				var images = [];
				images = identity_profiler_obj.identity_profiler_data[i].images.images;
				var profiler_image_gallery_id = [];
				var num_gallery_images = 0;
				if (images === undefined) {
					data_section =
							'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
									'<h3>No Images to display. Use Upload New Image button to populate gallery.</h3>' +
							'</div>';
				}
				else {
					for (var j = 0; j < images.length; j++) {
						profiler_image_gallery_id[num_gallery_images] = images[j].profiler_image_gallery_id;
                        var chosen_image_id = images[j].profiler_image_gallery_id;
						var file_location = images[j].file_location;
						var location_thumb = images[j].file_location + images[j].file_name;
						var location = file_location.substring(0, file_location.length - 7)  + images[j].file_name;
						var image_name = images[j].image_name;
						var image_description = images[j].image_description;
						if ((image_name === '') || (image_name === undefined) || (image_name === null)) {
							image_name = images[j].file_name;
						}

						data_section =
									'<div class="col-md-2">' +
										'<a class="thumbnail" title="' + image_name + '" href="#" onclick="show_full_size_image(\'' + location + '\', \'' + image_name + '\', \'' + image_description + '\', +  \'' + chosen_image_id + '\' );return false;">' +
													'<img src="' + location_thumb + '" width="200%" height="200%"   ></a>' +
										'<input type="checkbox" id="image_checkbox' + category + num_gallery_images + '">' +
										'<label style="padding-left: 5px; padding-bottom: 5px">' + image_name + '</label>' +
									'</div>' + data_section;

						num_gallery_images++;
					}
				}

				var image_actions =
						'<div class="row" style="padding-left: 10px; width: 1000px">'  +
							'<div class="col-md-1" style="width: 370px; vertical-align: top;  padding-right: 0px; margin-top: 15px;">' +
								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="upload_to_image_gallery_dialog(\'' + category + '\')">Upload New Image </button>' +
								'<button type="button" class="btn btn-sm btn-danger" style="margin-left: 20px" onclick="remove_gallery_images(\'' + category + '\')">Remove Checked Images </button>' +
							'</div>' +
							'<div class="col-md-1" style="width: 700px; vertical-align: top; margin-top: 8px; padding-left: 0px">' +
								'<div class="text-left" id="image_gallery_alert' + category + '" style="width: 700px"></div>' +
							'</div>' +
						'</div>';

				localStorage.setItem("num_gallery_images", num_gallery_images);
				section_id = "section_id" + category;
				actions_id = "actions_id" + category;
				localStorage.setItem("profiler_image_gallery_id", profiler_image_gallery_id);
				document.getElementById(section_id).innerHTML = decorator_section + data_section  + '</div>';
				document.getElementById(actions_id).innerHTML = image_actions;
			}

// Text file categories
			if (media_type === 'Text') {
				var file = identity_profiler_obj.identity_profiler_data[i].file.file[0].contents;
				var decorator_section_text =
						'<div class="row" style="padding: 25px;  background-color: #d1d1d1">';
								//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
				var data_section_text =
						'<textarea readonly cols="145" rows="25" wrap="hard" style="display: block; margin-right: auto; margin-left: auto">' + file + '</textarea>';
				var text_actions =
						'<div class="row" style="padding-left: 10px; width: 1200px">'  +
							'<div class="col-md-1" style="width: 370px; vertical-align: top;  padding-right: 0px; margin-top: 15px;">' +
								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="upload_to_text_file_dialog(\'' + category + '\')">Upload New File </button>' +
							'</div>' +
							'<div class="col-md-1" style="width: 700px; vertical-align: top; margin-top: 8px; padding-left: 0px">' +
								'<div class="text-left" id="text_file_alert" style="width: 700px"></div>' +
							'</div>' +
						'</div>';

				section_id = "section_id" + category;
				actions_id = "actions_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section_text + data_section_text  + '</div>';
				document.getElementById(actions_id).innerHTML = text_actions;
			}

// PDF file categories
			if (media_type === 'PDF') {
				var decorator_section_pdf =
						'<div class="row" style="padding: 25px;  background-color: #d1d1d1">';
								//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
				var file_name =  identity_profiler_obj.identity_profiler_data[i].file.file[0].file_name;
				var file_location =  identity_profiler_obj.identity_profiler_data[i].file.file[0].file_location;
				var data_section_pdf =
						'<object type="application/pdf" width="100%" height="500px" data="' + file_location + file_name + '"> ';
				var pdf_actions =
						'<div class="row" style="padding-left: 10px; width: 1200px">'  +
							'<div class="col-md-1" style="width: 370px; vertical-align: top;  padding-right: 0px; margin-top: 15px;">' +
								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="upload_to_pdf_file_dialog(\'' + category + '\')">Upload New File </button>' +
//								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="download_file_dialog()">Download File </button>' +
							'</div>' +
							'<div class="col-md-1" style="width: 700px; vertical-align: top; margin-top: 8px; padding-left: 0px">' +
								'<div class="text-left" id="pdf_file_alert" style="width: 700px"></div>' +
							'</div>' +
						'</div>';

				section_id = "section_id" + category;
				actions_id = "actions_id" + category;
				document.getElementById(section_id).innerHTML = decorator_section_pdf + data_section_pdf  + '</div>';
				document.getElementById(actions_id).innerHTML = pdf_actions;
			}

// Audio file categories
			if (media_type === 'Audio') {
				var data_section_audio = '';
				var decorator_section_audio =
						'<div class="row" style="padding: 10px; height: 550px; background-color: #d1d1d1">';
								//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';

				var audio_files = [];
				audio_files = identity_profiler_obj.identity_profiler_data[i].file.audio;
				var profiler_audio_jukebox_id = [];
				var num_audio_files = 0;
				if (audio_files === undefined) {
					data_section_audio =
							'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
									'<h3>No Audio files found. Use Upload New File button to populate Audio Jukebox.</h3>' +
							'</div>';
				}
				else {
					for (var j = 0; j < audio_files.length; j++) {
						profiler_audio_jukebox_id[num_audio_files] = audio_files[j].profiler_audio_jukebox_id;
						var file_location = audio_files[j].file_location + audio_files[j].file_name;
						var audio_file_name = audio_files[j].audio_file_name;
						var audio_description = audio_files[j].audio_file_description;
						if ((audio_file_name === '') || (audio_file_name === undefined) || (audio_file_name === null)) {
							audio_file_name = audio_files[j].file_name;
						}
						data_section_audio =
								'<div class="col-md-2" style="width: 320px; padding-bottom: 15px">' +
									'<audio controls="controls" style="padding-right: 15px"><source type="audio/mpeg" src="' + file_location + '"/></audio> ' +
									'<input type="checkbox" id="audio_checkbox' + category + num_audio_files + '">' +
									'<label style="padding-left: 5px; margin-bottom: 5px">' + audio_file_name + '</label>' +
									'<div style="padding-left: 17px;">' +
								'<textarea readonly style="width: 260px; height: 60px; border-style: inset; padding: 4px; font-size: 12px; color: #6c6c6c; background-color: #d1d1d1; resize: none; line-height: 98%">' + audio_description + '</textarea>' +
									'</div>' +
								'</div>' + data_section_audio;
						num_audio_files++;
					}
				}
				var audio_actions =
						'<div class="row" style="padding-left: 10px; width: 1200px">'  +
							'<div class="col-md-1" style="width: 370px; vertical-align: top;  padding-right: 0px; margin-top: 15px;">' +
								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="upload_to_audio_jukebox_dialog(\'' + category + '\')">Upload New File </button>' +
								'<button type="button" class="btn btn-sm btn-danger" style="margin-left: 20px" onclick="remove_audio_files(\'' + category + '\')">Remove Checked Files </button>' +
							'</div>' +
							'<div class="col-md-1" style="width: 700px; vertical-align: top; margin-top: 8px; padding-left: 0px">' +
								'<div class="text-left" id="audio_file_alert' + category + '" style="width: 700px"></div>' +
							'</div>' +
						'</div>';

				localStorage.setItem("num_audio_files", num_audio_files);
				section_id = "section_id" + category;
				actions_id = "actions_id" + category;
				localStorage.setItem("profiler_audio_jukebox_id", profiler_audio_jukebox_id);
				document.getElementById(section_id).innerHTML = decorator_section_audio + data_section_audio  + '</div>';
				document.getElementById(actions_id).innerHTML = audio_actions;
			}
		}
	}
}
//
// End loading of profiler categories
// -----------------------------------------

// -----------------------------------------
// Audio File Processing for Profiler
//
// Audio: Remove checked audio files dialog
function remove_audio_files(category) {
	var remove_ind = check_for_chosen_audio_files(category);
	if (remove_ind === true) {
		my_identity_profiler_alert("", "", "", "audio_jukebox", category);
		$('#remove_audio_files').modal();
		document.getElementById("category_id_audio_remove").value = category;
	}
}

// Audio: Check for checked checkbox
function check_for_chosen_audio_files(category) {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	processData(params, "get_audio_jukebox_data.php", "audio_jukebox_data", false);
	try {
		var audio_jukebox_data = localStorage.getItem("audio_jukebox_data");
		var audio_jukebox_obj = JSON.parse(audio_jukebox_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_audio_jukebox_data: Error getting data for audio files: status = " + err.message, "alert-danger", "Error!  ", "remove_audio_jukebox");
		return false;
	}

// ret_code = 1 means no checked audio files were found.
	var ret_code = audio_jukebox_obj.ret_code;
	if (ret_code === 1) {
		var message = audio_jukebox_obj.message;
		my_identity_profiler_alert(message, "alert-info", "Info! ", "audio_jukebox", category);
		return false;
	}

	var audio_file_id = audio_jukebox_obj.audio;
	var num_audio_files = audio_file_id.length;
	var audio_file_ids_to_remove = [];
	var remove_index = 0;
	for (var i = 0; i < num_audio_files; i++) {
		var checkbox = "audio_checkbox" + category + i;
		if (document.getElementById(checkbox).checked) {
			audio_file_ids_to_remove[remove_index] =  audio_file_id[i].profiler_audio_jukebox_id;
			remove_index++;
		}
	}
	if (remove_index > 0) {
		localStorage.setItem("audio_file_ids_to_remove", audio_file_ids_to_remove);
		return true;
	}
	my_identity_profiler_alert("No Audio Files were chosen to remove. Please click check box to remove audio files.", "alert-warning", "Warning! ", "audio_jukebox", category);
	return false;
}

// Audio: Soft delete checked of audio files
function update_for_delete_audio_files() {
	var audio_file_ids_to_remove = localStorage.getItem("audio_file_ids_to_remove");
	var params = "ids_to_remove=" + audio_file_ids_to_remove;
	processData(params, "update_for_delete_audio_files.php", "result", false);
	try {
		var audio_file_data = localStorage.getItem("result");
		var audio_file_obj = JSON.parse(audio_file_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("update_for_delete_audio_files: Error deleting audio files: status = " + err.message, "alert-danger", "Error!  ", "remove_audio_files");
		return false;
	}

	var ret_code = audio_file_obj.ret_code;
	if (ret_code === -1) {
		my_identity_profiler_alert(audio_file_obj[0].message, "alert-danger", "Alert! ", "remove_audio_files");
	}
	else {
		my_identity_profiler_alert("Audio files succsessfuly removed. ", "alert-success", "Success!  ", "remove_audio_files");
		var identity_profile_id = localStorage.getItem("identity_profile_id");
		var category = document.getElementById('category_id_audio_remove').value;
		refresh_audio_jukebox(identity_profile_id, category);
	}
	return false;
}

// Audio: clean up after deleting gallery images
function clean_remove_audio_files_dialog() {
	my_identity_profiler_alert("", "", "", "remove_audio_files");
}

// Audio: Refresh Profiler Audio Jukebox
function refresh_audio_jukebox(identity_profile_id, category) {
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	localStorage.setItem("category", category);  //****
	processData(params, "get_audio_jukebox_data.php", "audio_file_data", false);
	try {
		var audio_file_data = localStorage.getItem("audio_file_data");
		var audio_file_obj = JSON.parse(audio_file_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_audio_files_data: Error getting data for audio files: status = " + err.message, "alert-danger", "Error!  ", "remove_audio_files");
		return;
	}

	var profiler_audio_jukebox_id = [];
	var decorator_section_audio =
			'<div class="row" style="padding: 25px; height: 550px;  background-color: #d1d1d1">';
					//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';

	var audio_files = audio_file_obj.audio;
	var data_section_audio = '';
	var num_audio_files = 0;
	if (audio_files === undefined) {
		data_section_audio =
				'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
						'<h3>No Audio files found. Use Upload New File button to populate Audio Jukebox.</h3>' +
				'</div>';
	}
	else {
		for (var j = 0; j < audio_files.length; j++) {
			profiler_audio_jukebox_id[num_audio_files] = audio_files[j].profiler_audio_jukebox_id;
			var file_location = audio_files[j].file_location + audio_files[j].file_name;
			var audio_file_name = audio_files[j].audio_file_name;
			var audio_description = audio_files[j].audio_file_description;
			if ((audio_file_name === '') || (audio_file_name === undefined) || (audio_file_name === null)) {
				audio_file_name = audio_files[j].file_name;
			}

			data_section_audio =
					'<div class="col-md-2" style="width: 320px; padding-bottom: 15px">' +
						'<audio controls="controls" style="padding-right: 15px"><source type="audio/mpeg" src="' + file_location + '"/></audio> ' +
						'<input type="checkbox" id="audio_checkbox' + category + num_audio_files + '">' +
						'<label style="padding-left: 5px; margin-bottom: 5px">' + audio_file_name + '</label>' +
						'<div style="padding-left: 17px;">' +
							'<textarea readonly style="width: 260px; height: 60px; border-style: inset; padding: 4px; font-size: 12px; color: #6c6c6c; background-color: #d1d1d1; resize: none; line-height: 98%">' + audio_description + '</textarea>' +
						'</div>' +
					'</div>' + data_section_audio;
			num_audio_files++;
		}
	}

	localStorage.setItem("num_audio_files", num_audio_files);  //****
	var category =  localStorage.getItem("category");
	var section_id = "section_id" + category;
	localStorage.setItem("profiler_audio_jukebox_id", profiler_audio_jukebox_id);             //****
	document.getElementById(section_id).innerHTML = decorator_section_audio + data_section_audio  + '</div>';
}

// Audio: Upload audio file processing
function upload_to_audio_jukebox_dialog(category) {
	$('#new_audio_file_dialog').modal();
	document.getElementById("category_id_audio_new").value = category;
}

function get_audio_file() {
	var file = document.getElementById('new_audio_file').files[0];
	var file_name = file.name;
	var audioType = /audio.*/;
	if (!file.type.match(audioType)) {
		my_identity_profiler_alert("File: <strong>" + file_name + "</strong>, must be an .mp3 file type", "alert-danger", "Error!  ", "audio_jukebox_upload");
		return;
	}

	my_identity_profiler_alert("", "", "", "audio_jukebox_upload");
	$("#audio_file_file_name").val(file_name);
}

function upload_audio_file() {
	var file = document.getElementById('new_audio_file').files[0];
	if ((file === undefined) || (file === '')) {
		my_identity_profiler_alert("No file chosen to upload", "alert-warning", "Warning!  ", "audio_jukebox_upload");
		return;
	}
	my_identity_profiler_alert("", "", "audio_jukebox_upload");
	var category = document.getElementById('category_id_audio_new').value;
	var file_name = file.name;
	var profile_name = localStorage.getItem("current_profile_name");
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var audio_file_description = document.getElementById('audio_file_description').value;
	var audio_file_name = document.getElementById('audio_file_name').value;

//Audio: save to file system and database
	var byte_reader = new FileReader();
	if (file) {
		byte_reader.readAsDataURL(file);
	}
	byte_reader.onloadend =
			function () {
				var audio_file_src = byte_reader.result;

				var file_name = file.name;
				var params = "file_name=" + file_name + "&identity_profile_id=" + identity_profile_id + "&category=" + category +
						"&profile_name=" + profile_name + "&audio_file_description=" + audio_file_description + "&audio_file_name=" + audio_file_name +
						"&audio_file_src=" + audio_file_src;

				processData(params, "insert_to_audio_jukebox.php", "result", false);
				try {
					var result_data = localStorage.getItem("result");
					var result_obj = JSON.parse(result_data);
				} catch (err) {
					console.log(err.message)
					my_identity_profiler_alert("insert_to_audio_jukebox: Problem uploading audio file. Status = " + err.message, "alert-danger", "Severe Error!  ", "audio_jukebox_upload");
					return;
				}

				var ret_code = result_obj.ret_code;
				if ((ret_code === -1) || (ret_code === -9)) {
					my_identity_profiler_alert(result_obj.message, "alert-danger", "Error!  ", "audio_jukebox_upload");
					return;
				}
				if (ret_code === 0) {
					my_identity_profiler_alert(result_obj.message, "alert-success", "Success!  ", "audio_jukebox_upload");
				}
				document.getElementById('new_audio_file').value = '';
				refresh_audio_jukebox(identity_profile_id, category);
			}
}

// Audio:
function cleanup_audio_file_dialog () {
	my_identity_profiler_alert("", "", "", "audio_jukebox_upload");
	$( "#audio_file_name" ).val('');
	$( "#audio_file_description" ).val('');
	$( "#audio_file_file_name" ).val('');
}

//
// End Audio File processing
// ----------------------------------------------


// ----------------------------------------------
// Image Gallery Processing for Profiler
//
function upload_to_image_gallery_dialog(category) {
	$('#new_image_dialog').modal();
	document.getElementById("category_id_image").value = category;
}

function get_gallery_image() {
	var file = document.getElementById('new_gallery_image').files[0];
	var file_name = file.name;
	var imageType = /image.*/;
	if (!file.type.match(imageType)) {
		my_identity_profiler_alert("File: <strong>" + file_name + "</strong>, must be either a .jpg, jpeg, gif, or .png image type.", "alert-danger", "Error!  ", "image_gallery_upload");
		return;
	}

	my_identity_profiler_alert("", "", "", "image_gallery_upload");
	$("#image_gallery_file_name").val(file_name);
}

// Image Gallery:
function upload_gallery_image() {
	var file = document.getElementById('new_gallery_image').files[0];
	if ((file === undefined) || (file === '')) {
		my_identity_profiler_alert("No file chosen to upload", "alert-warning", "Warning!  ", "image_gallery_upload");
		return;
	}
	my_identity_profiler_alert("", "", "image_gallery_upload");
	var category = document.getElementById('category_id_image').value;
	var file_name = file.name;
	var profile_name = localStorage.getItem("current_profile_name");
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var image_description = document.getElementById('gallery_image_description').value;
	var image_name = document.getElementById('gallery_image_name').value;

	//save to file system and database
	var byte_reader = new FileReader();
	if (file) {
		byte_reader.readAsDataURL(file);
	}
	byte_reader.onload =
			function () {
				var image_src = byte_reader.result;
				var file_name = file.name;
				var params = "file_name=" + file_name + "&identity_profile_id=" + identity_profile_id + "&category=" + category + "&profile_name=" + profile_name + "&image_description=" + image_description + "&image_name=" + image_name + "&image_src=" + image_src;
				processData(params, "insert_to_image_gallery.php", "result", false);
				try {
					var result_data = localStorage.getItem("result");
					var result_obj = JSON.parse(result_data);
				} catch (err) {
					console.log(err.message)
					my_identity_profiler_alert("insert_to_image_gallery: Problem converting image to thumbnail. PNG image not created: status = " + err.message, "alert-danger", "Severe Error!  ", "image_gallery_upload");
					return;
				}

				var ret_code = result_obj.ret_code;
				if ((ret_code === -1) || (ret_code === -9)) {
					my_identity_profiler_alert(result_obj.message, "alert-danger", "Error!  ", "image_gallery_upload");
					return;
				}
				if (ret_code === 0) {
					my_identity_profiler_alert(result_obj.message, "alert-success", "Success!  ", "image_gallery_upload");
				}
				document.getElementById('new_gallery_image').value = '';
				refresh_image_gallery(identity_profile_id, category);
			}
}

// Image Gallery:
function cleanup_image_gallery_dialog () {
	my_identity_profiler_alert("", "", "", "image_gallery_upload");
	$( "#gallery_image_name" ).val('');
	$( "#gallery_image_description" ).val('');
	$( "#image_gallery_file_name" ).val('');
}

// Image Gallery: Refresh Profiler Image Gallery
function refresh_image_gallery(identity_profile_id, category) {
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	processData(params, "get_image_gallery_data.php", "image_gallery_data", false);
	try {
		var image_gallery_data = localStorage.getItem("image_gallery_data");
		var image_gallery_obj = JSON.parse(image_gallery_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_image_gallery_data: Error getting data for image gallery: status = " + err.message, "alert-danger", "Error!  ", "remove_gallery_image");
		return;
	}

	var profiler_image_gallery_id = [];
	var decorator_section =
			'<div class="row" style="padding: 20px; height: 600px; background-color: #d1d1d1">';

	var gallery_images = image_gallery_obj.images;
	var data_section = '';
	var num_gallery_images = 0;
	if (gallery_images === undefined) {
		data_section =
				'<div class="col-md-2" style="width: 1000px; padding-left: 130px">' +
						'<h3>No Images to display. Use Upload New Image button to populate gallery.</h3>' +
				'</div>';
	}
	else {
		for (var i = 0; i < gallery_images.length; i++) {
			profiler_image_gallery_id[num_gallery_images] = image_gallery_obj.images[i].profiler_image_gallery_id;
            var chosen_image_id = gallery_images[i].profiler_image_gallery_id;
			var file_location = gallery_images[i].file_location;
			var location_thumb = gallery_images[i].file_location + gallery_images[i].file_name;
			var location = file_location.substring(0, file_location.length - 7) + gallery_images[i].file_name;
			var image_description = gallery_images[i].image_description;
			var image_name = gallery_images[i].image_name;
			if ((image_name === '') || (image_name === undefined) || (image_name === null)) {
				image_name = gallery_images[i].file_name;
			}
			data_section =
					'<div class="col-md-2">' +
						'<a class="thumbnail" title="' + image_name + '" href="#" onclick="show_full_size_image(\'' + location + '\', \'' + image_name + '\', \'' + image_description + '\', +  \'' + chosen_image_id + '\' );return false;">' +
						'<img src="' + location_thumb + '" width="200%" height="200%"   ></a>' +
						'<input type="checkbox" id="image_checkbox' + category + num_gallery_images + '">' +
						'<label style="padding-left: 5px; padding-bottom: 5px">' + image_name + '</label>' +
					'</div>' + data_section;
			num_gallery_images++;
		}
	}
	localStorage.setItem("num_gallery_images", num_gallery_images);
	var image_gallery = decorator_section + data_section + '</div>'; //*******
	var section_id = "section_id" + category;
	localStorage.setItem("profiler_image_gallery_id", profiler_image_gallery_id);  //*******
	document.getElementById(section_id).innerHTML = image_gallery;
}


// Image Gallery: Show enlarged image with detail
function show_full_size_image(location, image_title, image_description, chosen_image_id) {
	$('#show_full_size_image').modal();

	var full_size_image = '<img src="' + location + '" width="100%" height="100%" >';
    document.getElementById("full_size_image").innerHTML = full_size_image;

    var full_image_description = "<textarea readonly style='resize: none; border: none; font-size: 16px; width: 570px; height: 80px' type='text' id='image_description'>" + image_description + "</textarea>";
    document.getElementById("full_image_description").innerHTML = full_image_description;
    localStorage.setItem("image_description", image_description);

    var full_image_title = "<h3 class='modal-title'>" + image_title + "</h3>";
    document.getElementById("full_image_title").innerHTML = full_image_title;

    localStorage.setItem("image_title", image_title);
    localStorage.setItem("image_description", image_description);
    localStorage.setItem("chosen_image_id", chosen_image_id);
    my_identity_profiler_alert("", "", "", "show_full_size_image");
}

// Image Gallery: Edit text on full size images
function editImageText() {
    var image_description = localStorage.getItem("image_description");
    var full_image_description = "<textarea style='resize: none; border: solid; border-width: 2px; font-size: 16px; width: 570px; height: 80px' type='text' id='image_description'></h3>";
    document.getElementById("full_image_description").innerHTML = full_image_description;
    document.getElementById("image_description").value = image_description;

    var image_title = localStorage.getItem("image_title");
    var full_image_title = "<h3 class='modal-title'><input type='text' name='image_title' id='image_title' style='background-color: #fafafa'></h3>";
    document.getElementById("full_image_title").innerHTML = full_image_title;
    document.getElementById("image_title").value = image_title;
    my_identity_profiler_alert("", "", "", "show_full_size_image");
}

// Image Gallery: cancel edit text on full size images
function cancelEditImageText() {
    var image_description = localStorage.getItem("image_description");
    var full_image_description = "<textarea readonly style='resize: none; border: none; font-size: 16px; width: 570px; height: 80px' type='text' id='image_description'>" + image_description + "</textarea>";
    document.getElementById("full_image_description").innerHTML = full_image_description;
    localStorage.setItem("image_description", image_description);

    var image_title = localStorage.getItem("image_title");
    var full_image_title = "<h3 class='modal-title'>" + image_title + "</h3>";
    document.getElementById("full_image_title").innerHTML = full_image_title;
    localStorage.setItem("image_title", image_title);
    my_identity_profiler_alert("", "", "", "show_full_size_image");
}

// Image Gallery: save edit text on full size images
function saveEditImageText() {
    var image_id = localStorage.getItem("chosen_image_id");
    var edited_title = document.getElementById("image_title").value;
    var edited_description = document.getElementById("image_description").value;

    var params = "image_id=" + image_id + "&image_title=" + edited_title + "&image_description=" + edited_description;
    processData(params, "update_profiler_image_data.php", "result", false);
    try {
        var image_gallery_data = localStorage.getItem("result");
        var image_gallery_obj = JSON.parse(image_gallery_data);
    }
    catch (err) {
        console.log(err.message)
        my_identity_profiler_alert("update_profiler_image_date: Error updating gallery image: status = " + err.message, "alert-danger", "Error!  ", "show_full_size_image");
        return false;
    }

    var ret_code = image_gallery_obj.ret_code;
    if (ret_code === -1) {
        my_identity_profiler_alert(image_gallery_obj[0].message, "alert-danger", "Alert! ", "show_full_size_image");
    }
    else {
        my_identity_profiler_alert("Gallery Image succsessfuly updated. ", "alert-success", "Success!  ", "show_full_size_image");
        localStorage.setItem("image_title", edited_title);
        localStorage.setItem("image_description", edited_description);

        var identity_profile_id = localStorage.getItem("identity_profile_id");
        var category = getImageCategory(image_id);
        refresh_image_gallery(identity_profile_id, category);
    }
}

// Image Gallery: Get associated category from image id
function getImageCategory(image_id) {
    var params = "image_id=" + image_id;
    processData(params, "get_image_category.php", "result", false);
    try {
        var image_gallery_data = localStorage.getItem("result");
        var image_gallery_obj = JSON.parse(image_gallery_data);
    }
    catch (err) {
        console.log(err.message)
        my_identity_profiler_alert("getImageCategory: Error getting image category = " + err.message, "alert-danger", "Error!  ", "show_full_size_image");
        return false;
    }

    var ret_code = image_gallery_obj.ret_code;
    if (ret_code === -1) {
        my_identity_profiler_alert(image_gallery_obj[0].message, "alert-danger", "Alert! ", "show_full_size_image");
    }
    var category = image_gallery_obj.category;

    return category;
}

// Image Gallery: Remove checked gallery images dialog
function remove_gallery_images(category) {
	var remove_ind = check_for_chosen_gallery_images(category);
	if (remove_ind === true) {
		my_identity_profiler_alert("", "", "", "image_gallery", category);
		$('#remove_images').modal();
		document.getElementById("category_id_image_remove").value = category;
	}
}

// Image Gallery: Check for checked checkbox
function check_for_chosen_gallery_images(category) {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	processData(params, "get_image_gallery_data.php", "image_gallery_data", false);
	try {
		var image_gallery_data = localStorage.getItem("image_gallery_data");
		var image_gallery_obj = JSON.parse(image_gallery_data);
	}
    catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_image_gallery_data: Error getting data for image gallery: status = " + err.message, "alert-danger", "Error!  ", "remove_gallery_image");
		return false;
	}

// ret_code = 1 means no checked images were found.
	var ret_code = image_gallery_obj.ret_code;
	if (ret_code === 1) {
		var message = image_gallery_obj.message;
		my_identity_profiler_alert(message, "alert-info", "Info! ","image_gallery", category);
		return false;
	}

	var image_gallery_id = image_gallery_obj.images;
	var num_gallery_images = image_gallery_id.length;
	var image_gallery_ids_to_remove = [];
	var remove_index = 0;
	for (var i = 0; i < num_gallery_images; i++) {
		var checkbox = "image_checkbox" + category + i;
		if (document.getElementById(checkbox).checked) {
			image_gallery_ids_to_remove[remove_index] = image_gallery_id[i].profiler_image_gallery_id;
			remove_index++;
		}
	}
	if (remove_index > 0) {
		localStorage.setItem("image_gallery_ids_to_remove", image_gallery_ids_to_remove);
		return true;
	}
	my_identity_profiler_alert("No Gallery Images were chosen to remove. Please click check box to remove images(s).", "alert-warning", "Warning! ", "image_gallery", category);
	return false;
}

// Image Gallery: Soft delete checked gallery images
function update_for_delete_gallery_images() {
	var image_gallery_ids_to_remove = localStorage.getItem("image_gallery_ids_to_remove");
	var params = "image_ids_to_remove=" + image_gallery_ids_to_remove;
	processData(params, "update_for_delete_gallery_images.php", "result", false);
	try {
		var image_gallery_data = localStorage.getItem("result");
		var image_gallery_obj = JSON.parse(image_gallery_data);
	}
    catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("update_for_delete_gallery_images: Error deleting gallery image: status = " + err.message, "alert-danger", "Error!  ", "remove_gallery_image");
		return false;
	}

	var ret_code = image_gallery_obj.ret_code;
	if (ret_code === -1) {
		my_identity_profiler_alert(image_gallery_obj[0].message, "alert-danger", "Alert! ", "remove_gallery_image");
	}
	else {
		my_identity_profiler_alert("Gallery Images succsessfuly removed. ", "alert-success", "Success!  ", "remove_gallery_image");
		var identity_profile_id = localStorage.getItem("identity_profile_id");
		var category = document.getElementById('category_id_image_remove').value;
		refresh_image_gallery(identity_profile_id, category);
	}
	return false;
}

// Image Gallery: clean up after deleting gallery images
function clean_remove_gallery_image_dialog() {
	my_identity_profiler_alert("", "", "", "remove_gallery_image");
}
//
// End Image Gallery processing
// ---------------------------------------

// ---------------------------------------
// Text file processing for Profiler
//
function upload_to_text_file_dialog(category) {
	$('#new_text_file_dialog').modal();
	document.getElementById("category_id_text").value = category;
}

// Text File:
function get_text_file() {
	var file = document.getElementById('new_text_file').files[0];
	var file_name = file.name;
	var fileType = /text.*/;
	if (!file.type.match(fileType)) {
		my_identity_profiler_alert("File: <strong>" + file_name + "</strong>, must be a .txt file type.", "alert-danger", "Error!  ", "text_file_upload");
		return;
	}

	my_identity_profiler_alert("", "", "", "text_file_upload");
	$("#text_file_file_name").val(file_name);
}

// Text File: Save Text file
function save_text_file() {
	var file = document.getElementById('new_text_file').files[0];
	if ((file === undefined) || (file === '')) {
		my_identity_profiler_alert("No file chosen to upload", "alert-warning", "Warning!  ", "text_file_upload");
		return;
	}
	my_identity_profiler_alert("", "", "text_file_upload");
	var category = document.getElementById('category_id_text').value;
	var file_name = file.name;
	var profile_name = localStorage.getItem("current_profile_name");
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var text_file_description = document.getElementById('text_file_description').value;
	var text_file_name = document.getElementById('text_file_name').value;

	//save to file system and database
	var byte_reader = new FileReader();
	if (file) {
		byte_reader.readAsText(file);
	}
	byte_reader.onload =
			function () {
				var text_file_src = byte_reader.result;
				var file_name = file.name;
				var params = "file_name=" + file_name + "&text_file_src=" + text_file_src + "&identity_profile_id=" + identity_profile_id + "&category=" + category
						+ "&profile_name=" + profile_name + "&text_file_description=" + text_file_description + "&text_file_name=" + text_file_name;
				processData(params, "update_text_file.php", "result", false);
				try {
					var result_data = localStorage.getItem("result");
					var result_obj = JSON.parse(result_data);
				} catch (err) {
					console.log(err.message)
					my_identity_profiler_alert("update_text_file: Error uploading text file = " + err.message, "alert-danger", "Error!  ", "text_file_upload");
					return;
				}

				var ret_code = result_obj.ret_code;
				if ((ret_code === -1) || (ret_code === -9)) {
					my_identity_profiler_alert(result_obj.message, "alert-danger", "Error!  ", "text_file_upload");
					return;
				}
				if (ret_code === 0) {
					my_identity_profiler_alert(result_obj.message, "alert-success", "Success!  ", "text_file_upload");
				}
				document.getElementById('new_text_file').value = '';
				refresh_text_file(identity_profile_id, category);
			}
}

// Text File: Refresh uploaded text file in Profiler
function refresh_text_file(identity_profile_id, category)  {
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	processData(params, "get_text_data.php", "text_file_data", false);
	try {
		var text_file_data = localStorage.getItem("text_file_data");
		var text_file_obj = JSON.parse(text_file_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_text_data: Error getting text file = " + err.message, "alert-danger", "Error!  ", "text_file_upload");
		return;
	}

	var ret_code = text_file_obj.ret_code;
	if (ret_code === 1) {
		var message = text_file_obj.message;
		my_identity_profiler_alert(message, "alert-info", "Info! ", "header");
		return;
	}

	var file = text_file_obj.file[0].contents;
	var decorator_section_text =
			'<div class="row" style="padding: 25px;  background-color: #d1d1d1">';
					//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
	var data_section_text =
			'<textarea readonly cols="145" rows="25" wrap="hard" style="display: block; margin-right: auto; margin-left: auto">' + file + '</textarea>';

	var section_id = "section_id" + category;
	document.getElementById(section_id).innerHTML = decorator_section_text + data_section_text  + '</div>';
}

// Text File:
function cleanup_text_file_dialog () {
	my_identity_profiler_alert("", "", "", "text_file_upload");
	$( "#text_file_name" ).val('');
	$( "#text_file_description" ).val('');
	$( "#text_file_file_name" ).val('');
}
//
// End Text File processing
// ----------------------------------------

// ---------------------------------------
// PDF file processing for Profiler
//
function upload_to_pdf_file_dialog(category) {
	$('#new_pdf_file_dialog').modal();
	document.getElementById("category_id_pdf").value = category;
}

// PDF File:
function get_pdf_file() {
	var file = document.getElementById('new_pdf_file').files[0];
	var file_name = file.name;
	var fileType = /application.*/;
	if (!file.type.match(fileType)) {
		my_identity_profiler_alert("File: <strong>" + file_name + "</strong>, must be a .pdf file type.", "alert-danger", "Error!  ", "pdf_file_upload");
		return;
	}

	my_identity_profiler_alert("", "", "", "pdf_file_upload");
	$("#pdf_file_file_name").val(file_name);
}

// PDF File: Save pdf file
function save_pdf_file() {
	var file = document.getElementById('new_pdf_file').files[0];
	if ((file === undefined) || (file === '')) {
		my_identity_profiler_alert("No file chosen to upload", "alert-warning", "Warning!  ", "pdf_file_upload");
		return;
	}
	my_identity_profiler_alert("", "", "pdf_file_upload");
	var category = document.getElementById('category_id_pdf').value;
	var file_name = file.name;
	var profile_name = localStorage.getItem("current_profile_name");
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var pdf_file_description = document.getElementById('pdf_file_description').value;
	var pdf_file_name = document.getElementById('pdf_file_name').value;

// save to file system and database
	var byte_reader = new FileReader();
	if (file) {
		byte_reader.readAsDataURL(file);
	}
	byte_reader.onload =
			function () {
				var pdf_file_src = byte_reader.result;
				var file_name = file.name;

				var params = "file_name=" + file_name + "&identity_profile_id=" + identity_profile_id + "&category=" + category + "&profile_name=" + profile_name +
						"&pdf_file_description=" + pdf_file_description + "&pdf_file_name=" + pdf_file_name + "&pdf_file_src=" + pdf_file_src ;
				processData(params, "update_pdf_file.php", "result", false);
				try {
					var result_data = localStorage.getItem("result");
					var result_obj = JSON.parse(result_data);
				} catch (err) {
					console.log(err.message)
					my_identity_profiler_alert("update_pdf_file: Error uploading pdf file = " + err.message, "alert-danger", "Error!  ", "pdf_file_upload");
					return;
				}

				var ret_code = result_obj.ret_code;
				if ((ret_code === -1) || (ret_code === -9)) {
					my_identity_profiler_alert(result_obj.message, "alert-danger", "Error!  ", "pdf_file_upload");
					return;
				}
				if (ret_code === 0) {
					my_identity_profiler_alert(result_obj.message, "alert-success", "Success!  ", "pdf_file_upload");
				}
				document.getElementById('new_pdf_file').value = '';
				refresh_pdf_file(identity_profile_id, category);
			}
}

// PDF File: Refresh uploaded pdf file in Profiler
function refresh_pdf_file(identity_profile_id, category)  {
	var params = "identity_profile_id=" + identity_profile_id + "&category=" + category;
	processData(params, "get_pdf_data.php", "pdf_file_data", false);
	try {
		var pdf_file_data = localStorage.getItem("pdf_file_data");
		var pdf_file_obj = JSON.parse(pdf_file_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_pdf_data: Error getting pdf file = " + err.message, "alert-danger", "Error!  ", "pdf_file_upload");
		return;
	}

	var ret_code = pdf_file_obj.ret_code;
	if (ret_code === 1) {
		var message = pdf_file_obj.message;
		my_identity_profiler_alert(message, "alert-info", "Info! ", "header");
		return;
	}

	var file_location = pdf_file_obj.file[0].file_location;
	var file_name = pdf_file_obj.file[0].file_name;
	var decorator_section_pdf =
			'<div class="row" style="padding: 25px;  background-color: #d1d1d1">';
					//'background-image: url(assets/seamlesstexture1_1200.jpg);" >';
	var data_section_pdf =
			'<object type="application/pdf" width="100%" height="500px" data="' + file_location + file_name + '"> ';

	var section_id = "section_id" + category;
	document.getElementById(section_id).innerHTML = decorator_section_pdf + data_section_pdf  + '</div>';
}

// PDF File:
function cleanup_pdf_file_dialog () {
	my_identity_profiler_alert("", "", "", "pdf_file_upload");
	$( "#pdf_file_name" ).val('');
	$( "#pdf_file_description" ).val('');
	$( "#pdf_file_file_name" ).val('');
}
//
// End PDF File processing
// ----------------------------------------

// -----------------------------------------------
// Profiler Category Processing
//

// Remove Category from Profiler
function remove_category() {
    my_identity_profiler_alert('', '', '', "profiler_category");
	var remove_ind = checkForChosenCategories();
	if (remove_ind === true) {
		my_identity_profiler_alert('', '', '', "profiler_category");
		$('#remove_profiler_category').modal();
	}
	if (remove_ind === false) {
		my_identity_profiler_alert("No Profiler Category(s) were chosen to remove.", "alert-warning", "Warning! ", "profiler_category");
	}
}

// Remove Category:
function checkForChosenCategories() {
	var profiler_ids_to_remove = [];
	var remove_index = 0;

	// get most current list of category ids
	var params = "identity_profile_id=" + localStorage.getItem("identity_profile_id");
	var url = "get_profiler_id.php";
	processData(params, url, "result", false);
	try {
		var identity_profiler_id_data = localStorage.getItem("result");
		var identity_profiler_id_obj = JSON.parse(identity_profiler_id_data);
	} catch (err) {
		console.log(err.message);
		my_identity_profiler_alert("get_profiler_id: Error getting identity profiler ids = " + err.message, "alert-danger", "Error!  ", "profiler_category");
		return false;
	}
	var ret_code = identity_profiler_id_obj.ret_code;
	if (ret_code === 1) {
		my_identity_profiler_alert(identity_profiler_id_obj.message, "alert-warning", "Warning! ", "profiler_category");
	}

	var identity_profiler_id = identity_profiler_id_obj.identity_profiler_ids;
	var num_categories = identity_profiler_id.length;
	for (var i = 0; i < num_categories; i++) {
		var checkbox = "category_checkbox" + i;
		if (document.getElementById(checkbox).checked) {
			profiler_ids_to_remove[remove_index] = document.getElementById(checkbox).value;
			remove_index++;
		}
	}
	if (remove_index > 0) {
        var displayed_category_count = localStorage.getItem("displayed_category_count") - remove_index;
        localStorage.setItem("displayed_category_count", displayed_category_count);
		localStorage.setItem("profiler_ids_to_remove", profiler_ids_to_remove);
		return true;
	}
	return false;
}

// Remove Category:
function update_for_delete_profiler_category() {
	var profiler_ids_to_remove = localStorage.getItem("profiler_ids_to_remove");
	var params = "profiler_ids_to_remove=" + profiler_ids_to_remove;
	var url = "update_for_delete_profiler_category.php";
	processData(params, url, "result", false);
	try {
		var profiler_data = localStorage.getItem("result");
		var profiler_obj = JSON.parse(profiler_data);
	}
    catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("update_for_delete_profiler_category: Error deleting profiler category data = " + err.message, "alert-danger", "Error!  ", "profiler_category");
        return;
	}

	var ret_code = profiler_obj.ret_code;
	if (ret_code === -1) {
		my_identity_profiler_alert(profiler_obj[0].message, "alert-danger", "Alert! ", "profiler_category");
	}
	else {
		refresh_profiler_categories();
		my_identity_profiler_alert("Profiler Category(s) successfully removed. ", "alert-success", "Success!  ", "profiler_category");
	}
}

// Remove Category:
function clean_remove_profiler_category_dialog() {
	my_identity_profiler_alert("", "", "", "remove_profiler_category");
}

// Remove Category:
function refresh_profiler_categories() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	load_profiler_categories (identity_profile_id)
}
//
// End Remove Category processing
// -----------------------------------------------

// -----------------------------------------------
// Add Category to Profile Media Info section
//
var max_categories = 7;
function add_category() {
    my_identity_profiler_alert('', '', '', "profiler_category");
	$('#new_category_dialog').modal();

	loadMediaTypesDropDown();
    var category_count = parseInt(localStorage.getItem("displayed_category_count"));
    if (category_count === max_categories) {
        my_identity_profiler_alert("You have reached the maximum number of Media Categories allowed: " + max_categories + ".   You will not be allowed to create anymore categories unless you delete an existing one. ","alert-warning", "Warning!  ", "categories");
        return;
    }

    localStorage.setItem("category_count", category_count);
    document.getElementById("category_name").value = "";
    my_identity_profiler_alert('', '', '', "categories");
}

// Add Category:
function loadMediaTypesDropDown() {
	processData("params=''", "get_media_types.php", "media_type", false);
	try {
		var media_types_data = localStorage.getItem("media_type");
		var media_types_obj = JSON.parse(media_types_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_media_types: Problem getting media types = " + err.message, "alert-danger", "Error!  ", "categories");
		return;
	}

	var media_types_list_option = '';
	for (var i = 0; i < media_types_obj.media_type.length; i++) {
		var media_types_name = media_types_obj.media_type[i];
		media_types_list_option = media_types_list_option + '<option value=' + '"' + media_types_name + '">' + media_types_name + '</option>';
	}

    var mediaTypesList = '<select name="mediaTypesList"  id="mediaTypesList" class="dropdown-wami1">' + media_types_list_option +  '</select>';
    document.getElementById("media_types_list").innerHTML = mediaTypesList;
}

// Add Category:
function save_categories() {
    my_identity_profiler_alert('', '', '', "categories");

    var category_count = parseInt(localStorage.getItem("displayed_category_count"));
    if (category_count === max_categories) {
        my_identity_profiler_alert("You have reached the maximum number of Media Categories allowed: " + max_categories, "alert-info", "Alert!  ", "categories");
        return;
    }

	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var param_str = "identity_profile_id=" + identity_profile_id  + "&";

    var category_name = document.getElementById('category_name').value;
    if (category_name === '' || category_name === null) {
        my_identity_profiler_alert("Category name cannot be blank. Please make sure category has a name.", "alert-info", "Alert! ", "categories");
        return;
    }

    var option = document.getElementById('mediaTypesList');
    var media_type = option.options[option.selectedIndex].value;

    param_str = param_str + "category_name=" + category_name + "&" + "media_type=" + media_type + "&";

	var profile_name = localStorage.getItem("current_profile_name");
	param_str = param_str +  "max_categories=" + max_categories  + "&";

	param_str = "profile_name=" + profile_name  + "&" + param_str;
	param_str = param_str.slice(0, param_str.length - 1);
	processData(param_str, "insert_profile_category.php", "messages", false);
	try {
		var messages_data = localStorage.getItem("messages");
		var messages_obj = JSON.parse(messages_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("insert_profile_category: Problem inserting new categories = " + err.message, "alert-danger", "Error!  ", "categories");
		return;
	}

	var message = messages_obj.message;
	var ret_code = messages_obj.ret_code;
	if (ret_code != 0) {
		my_identity_profiler_alert(message, "alert-danger", "Alert! ", "categories");
	}
	else {
        category_count = parseInt(localStorage.getItem("displayed_category_count")) + 1;
        localStorage.setItem("displayed_category_count", category_count);
		loadData(identity_profile_id);

        if (category_count === max_categories) {
            my_identity_profiler_alert("   " + message + "  You have reached the maximum number of Media Categories allowed: " + max_categories + ".   You will not be allowed to create anymore categories unless you delete an existing one. ", "alert-warning", "Warning!    ", "categories");
        }
        else {
            my_identity_profiler_alert(message + category_name, "alert-success", "Success!  ", "categories");
        }
	}
}
//
// End add Category processing
// ----------------------------------------------

// ----------------------------------------------
// Alert messages
//
function my_identity_profiler_alert (message, message_type_class, message_type_string, message_type, category) {
	if (message_type === "header")  {
		if (message === '') {
			document.getElementById("header_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "image_gallery_upload")  {
		if (message === '') {
			document.getElementById("new_image_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_gallery_image")  {
		if (message === '') {
			document.getElementById("remove_gallery_image_alert").innerHTML = message;
			return;
		}
	}
	if (message_type === "audio_jukebox_upload")  {
		if (message === '') {
			document.getElementById("new_audio_file_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_audio_files")  {
		if (message === '') {
			document.getElementById("remove_audio_files_alert").innerHTML = message;
			return;
		}
	}
	if (message_type === "text_file_upload")  {
		if (message === '') {
			document.getElementById("text_file_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "pdf_file_upload")  {
		if (message === '') {
			document.getElementById("pdf_file_dialog_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "categories")  {
		if (message === '') {
			document.getElementById("new_category_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "profiler_category")  {
		if (message === '') {
			document.getElementById("profiler_category_alerts").innerHTML = message;
			return;
		}
	}
	if (message_type === "remove_profiler_category")  {
		if (message === '') {
			document.getElementById("remove_profiler_category_alert").innerHTML = message;
			return;
		}
	}
    if (message_type === "show_full_size_image")  {
        if (message === '') {
            document.getElementById("show_full_size_image_alert").innerHTML = message;
            return;
        }
    }
	var alert_str = "<div class='alert " + message_type_class + " alert-dismissable'> " +
			"<button type='button' class='close' data-dismiss='alert' aria-hidden='true'>&times;</button> " +
			"<strong>" + message_type_string + "</strong> " + message + "</div>";
	if (message_type === "header") document.getElementById("header_alerts").innerHTML = alert_str;
	if (message_type === "image_gallery_upload") document.getElementById("new_image_dialog_alerts").innerHTML = alert_str;
	if (message_type === "image_gallery_dialog") document.getElementById("image_gallery_dialog_alert").innerHTML = alert_str;
	if (message_type === "image_gallery") document.getElementById("image_gallery_alert" + category).innerHTML = alert_str;
	if (message_type === "remove_gallery_image") document.getElementById("remove_gallery_image_alert").innerHTML = alert_str;
	if (message_type === "text_file_upload") document.getElementById("text_file_dialog_alerts").innerHTML = alert_str;
	if (message_type === "audio_jukebox") document.getElementById("audio_file_alert" + category).innerHTML = alert_str;
	if (message_type === "remove_audio_files") document.getElementById("remove_audio_files_alert").innerHTML = alert_str;
	if (message_type === "audio_jukebox_upload") document.getElementById("new_audio_file_dialog_alerts").innerHTML = alert_str;
	if (message_type === "categories") document.getElementById("new_category_alerts").innerHTML = alert_str;
	if (message_type === "profiler_category") document.getElementById("profiler_category_alerts").innerHTML = alert_str;
	if (message_type === "remove_profiler_category") document.getElementById("remove_profiler_category_alert").innerHTML = alert_str;
	if (message_type === "pdf_file_upload") document.getElementById("pdf_file_dialog_alerts").innerHTML = alert_str;
    if (message_type === "show_full_size_image") document.getElementById("show_full_size_image_alert").innerHTML = alert_str;
}