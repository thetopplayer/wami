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
	processData(params, "get_identity_profiler_data.php", "identity_profiler_data", false);
	try {
		var identity_profiler_data = localStorage.getItem("identity_profiler_data");
		var identity_profiler_obj = JSON.parse(identity_profiler_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("Error getting data for identity profiler: status = " + err.message, "alert-danger", "Error!  ", "header");
		return;
	}

// Check return code and messages from get_identity_profiler_data.php
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
								'<h3 class="panel-title"><input type="checkbox" id="category_checkbox' + i + '" style="margin-right: 10px; margin-bottom: 7px">' +
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
									'<span class="span-scroll-profile" style="height: 555px; width: 1063px; margin-left: 10px">' +
										'<div style="height: 553px; width: 1050px" id="section_id' + category + '"></div>' +
									'</span>' +
									'<div id="actions_id' + category + '"></div>' +
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
			var actions_id = '';
			var decorator_section = '';
			var data_section = '';

// Image gallery category
			if (media_type === 'Image') {
				decorator_section =
						'<div class="row" style="padding: 10px; height: 600px;  background-color: #d1d1d1">';
								//'background-image: url(assets/seamlesstexture1_1200.jpg); background-repeat: repeat" >';

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
						var location = images[j].file_location + images[j].file_name;
						var image_name = images[j].image_name;
						if ((image_name === '') || (image_name === undefined) || (image_name === null)) {
							image_name = images[j].file_name;
						}

						data_section =
									'<div class="col-md-2">' +
										'<a class="thumbnail" title="' + image_name + '" href="' + location + '"><img src="' + location + '" width="200%" height="200%"   ></a>' +
										'<input type="checkbox" id="image_checkbox' + category + num_gallery_images + '">' +
										'<label style="padding-left: 5px; padding-bottom: 5px">' + image_name + '</label>' +
									'</div>' + data_section;

						num_gallery_images++;
					}
				}

				var image_actions =
						'<div class="row" style="padding-left: 10px; width: 1200px">'  +
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
//								'<button type="button" class="btn btn-sm btn-primary" style="margin-left: 20px" onclick="download_file_dialog()">Download File </button>' +
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
						'<div class="row" style="padding: 25px; height: 550px; background-color: #d1d1d1">';
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
						if ((audio_file_name === '') || (audio_file_name === undefined) || (audio_file_name === null)) {
							audio_file_name = audio_files[j].file_name;
						}
						data_section_audio =
								'<div class="col-md-2" style="width: 320px">' +
									'<audio controls="controls" style="padding-right: 15px"><source type="audio/mpeg" src="' + file_location + '"/></audio> ' +
									'<input type="checkbox" id="audio_checkbox' + category + num_audio_files + '">' +
									'<label style="padding-left: 5px; padding-bottom: 20px">' + audio_file_name + '</label>' +
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
			if ((audio_file_name === '') || (audio_file_name === undefined) || (audio_file_name === null)) {
				audio_file_name = audio_files[j].file_name;
			}

			data_section_audio =
					'<div class="col-md-2" style="width: 300px">' +
						'<audio controls="controls" style="padding-right: 15px"><source type="audio/mpeg" src="' + file_location + '"/></audio> ' +
						'<input type="checkbox" id="audio_checkbox' + category + num_audio_files + '">' +
						'<label style="padding-left: 5px; padding-bottom: 20px">' + audio_file_name + '</label>' +
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
					//'background-repeat: repeat; background-image: url(assets/seamlesstexture1_1200.jpg);" >';

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
			var location = gallery_images[i].file_location + gallery_images[i].file_name;
			var image_name = gallery_images[i].image_name;
			if ((image_name === '') || (image_name === undefined) || (image_name === null)) {
				image_name = gallery_images[i].file_name;
			}
			data_section =
					'<div class="col-md-2">' +
						'<a class="thumbnail" title="' + image_name + '" href="' + location + '"><img src="' + location + '" width="200%" height="200%"   ></a>' +
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
	} catch (err) {
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
	} catch (err) {
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


//	document.getElementById("pdf_upload").submit();
//	var file = document.getElementById('new_pdf_file').files[0];
//	var formData = new FormData();
//	formData.append('pdf_file_src', file);
//	var xhr = new XMLHttpRequest();
//	xhr.open('POST', 'update_pdf_file.php');
//	xhr.send(formData);


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
	var remove_ind = checkForChosenCategories();
	if (remove_ind === true) {
		my_identity_profiler_alert("", "", "", "profiler_category");
		$('#remove_profiler_category').modal();
	}
	if (remove_ind === false) {
		my_identity_profiler_alert("No Profiler Categories were chosen to remove.", "alert-warning", "Warning! ", "profiler_category");
	}
}

// Remove Category:
function checkForChosenCategories() {
	var profiler_ids_to_remove = [];
	var remove_index = 0;

	// get most current list of category ids
	var params = "identity_profile_id=" + localStorage.getItem("identity_profile_id");
	var url = "get_identity_profiler_id.php";
	processData(params, url, "result", false);
	try {
		var identity_profiler_id_data = localStorage.getItem("result");
		var identity_profiler_id_obj = JSON.parse(identity_profiler_id_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_identity_profiler_id: Error getting identity profiler ids = " + err.message, "alert-danger", "Error!  ", "profiler_category");
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
			profiler_ids_to_remove[remove_index] = identity_profiler_id[i];
			remove_index++;
		}
	}
	if (remove_index > 0) {
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
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("update_for_delete_profiler_category: Error deleting profiler category data = " + err.message, "alert-danger", "Error!  ", "remove_profiler_category");
		return false;
	}

	var ret_code = profiler_obj.ret_code;
	if (ret_code === -1) {
		my_identity_profiler_alert(profiler_obj[0].message, "alert-danger", "Alert! ", "remove_flash");
	}
	else {
		refresh_profiler_categories();
		my_identity_profiler_alert("Profiler Categories succsessfuly removed. ", "alert-success", "Success!  ", "remove_profiler_category");
	}
	return false;
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
// Add Category to Profiler processing
//
function add_category() {
	$('#new_category_dialog').modal();
	processData("params=''", "get_profiler_template.php", "templates", false);
	try {
		var template_data = localStorage.getItem("templates");
		var template_obj = JSON.parse(template_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_profiler_template: Error adding new category = " + err.message, "alert-danger", "Error!  ", "category");
		return;
	}

	var template_list_dropdown = '<select name="templateList" id="templateList" class="dropdown-wami" onchange="loadCategory(this.value)" >';
	var template_list_option = '';
	for (var i = 0; i < template_obj.template.length; i++) {
		var template_name = template_obj.template[i];
		template_list_option = template_list_option + '<option value=' + '"' + template_name + '">' + template_name + '</option>';
	}

	template_list_dropdown = template_list_dropdown + template_list_option + '</select>';
	document.getElementById("templateListDropDown").innerHTML = template_list_dropdown;

	localStorage.setItem("new_row", '');
	loadCategory(template_obj.template[0]);

	loadMediaTypesDropDown();
}

// Add Category:
var category_pool = [];
function loadCategory(template) {
	processData("template=" + template, "get_profiler_template_category.php", "category", false);
	try {
		var category_data = localStorage.getItem("category");
		var category_obj = JSON.parse(category_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("get_profiler_template_category: Error loading new category = " + err.message, "alert-danger", "Error!  ", "category");
		return;
	}

	var category_name = [];
	var media_type = [];
	for (var i = 0; i < category_obj.category.length; i++) {
		category_name[i] = category_obj.category[i].category;
		media_type[i] = category_obj.category[i].media_type;
	}
	var category_info = '';
	var checkbox_list = ''
	for (var i = 0; i < category_name.length; i++) {
		checkbox_list = checkbox_list +  '<input checked type="checkbox" id="checkbox' + i + '">' + '<br><hr>';
	}
	document.getElementById("checkboxList").innerHTML = checkbox_list;

	var category_list = ''
	for (var i = 0; i < category_name.length; i++) {
		category_list = category_list +  category_name[i] + '<br><hr>';
	}
	document.getElementById("categoryList").innerHTML = category_list;

	var media_type_list = ''
	for (var i = 0; i < category_name.length; i++) {
		media_type_list = media_type_list +  media_type[i] + '<br><hr>';
	}
	document.getElementById("mediaTypeList").innerHTML = media_type_list;
	localStorage.setItem("row_num", 0);

	for (var i = 0; i < 20; i++) {
		category_pool[i] = 'free'
		var new_category = "newUserDefinedCategory" + i;
		document.getElementById(new_category).innerHTML = '';
	}

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

	localStorage.setItem("media_types_list_option", media_types_list_option);
}

// Add Category:
function add_user_defined_category() {
	my_identity_profiler_alert("", "", "", "categories");
	var row_num = get_free_category();
	if (row_num === 999) {
		my_identity_profiler_alert("You've reached the maximum number of User Defined Categories...sorry", "alert-info", "Info!  ", "categories");
		return
	}

	var media_types_list_option = localStorage.getItem("media_types_list_option");
	var new_row =
			'<div class="row" style="width: 800px">'  +
				'<div class="col-md-1" style="width: 150px">'  +
					'<h5></h5>' +
				'</div>' +
				'<div class="col-md-1" style="width: 200px; text-align: center; padding-left: 0px; padding-right: 0px">' +
					'<div style="font-size: 15px; padding-top: 10px">' +
						'<input type="checkbox" id="removeCheckbox' + row_num + '">' +
					'</div>' +
				'</div>' +
				'<div class="col-md-1" style="width: 200px; text-align: center; padding-left: 0px; padding-right: 0px">' +
					'<div style="font-size: 15px; padding-top: 10px">' +
						'<input type="text" class="input-wami" placeholder="Enter Category Name" name="userDefinedCategory' + row_num + '" id="userDefinedCategory' + row_num + '" style="width: 200px; height: 23px">' +
					'</div>' +
				'</div>' +
				'<div class="col-md-1" style="width: 200px; text-align: center; padding-left: 0px; padding-right: 0px; padding-top: 10px">' +
					'<select name="mediaTypesList' + row_num + '" id="mediaTypesList' + row_num + '" class="dropdown-wami1">' + media_types_list_option +  '</select>' +
				'</div>' +
			'</div>'

	var new_category = "newUserDefinedCategory" + row_num;
	document.getElementById(new_category).innerHTML = new_row;
	category_pool_maintenance(row_num, "taken");
}

// Add Category:
function remove_user_defined_category() {
	my_identity_profiler_alert("", "", "", "categories");
	var categories_to_remove =[];
	var index = 0;
	for (var i = 0; i < 20; i++) {
		var checkbox = "removeCheckbox" + i;
		var element = document.getElementById(checkbox);
		if (element === null || element.value == '') {
			continue;
		}
		if (element.checked) {
			categories_to_remove[index] = "newUserDefinedCategory" + i;
			category_pool_maintenance(i, "free");
			index++;
		}
	}
	if (categories_to_remove.length === 0) {
		my_identity_profiler_alert("Nothing to remove. No Categories were checked!", "alert-info", "Info!  ", "categories");
		return;
	}

	for (var i = 0; i < index; i++) {
		var category = categories_to_remove[i];
		document.getElementById(category).innerHTML = '';
	}
}

// Add Category:
function category_pool_maintenance (row_num, action) {
	category_pool[row_num] = action;
}

// Add Category:
function get_free_category () {
	for (var i = 0; i < 20; i++) {
		if (category_pool[i] === "free") return i;
	}
	return 999;
}

// Add Category:
function save_categories() {
	var identity_profile_id = localStorage.getItem("identity_profile_id");
	var category_name = '';
	var media_type = '';
	var num_categories = 0;
	var param_str = "identity_profile_id=" + identity_profile_id  + "&";
	for (var i = 0; i < 20; i++) {
		if (category_pool[i] === "taken") {
			category_name = document.getElementById('userDefinedCategory' + i).value;
			if (category_name === '' || category_name === null) {
				continue;
			}

			var option = document.getElementById('mediaTypesList' + i);
			media_type =  option.options[option.selectedIndex].value;

			param_str = param_str + "category_names" + i + "=" + category_name + "&" + "media_types" + i + "=" + media_type + "&";
			num_categories++;
		}
	}

	var template_option = document.getElementById('templateList');
	var template =  template_option.options[template_option.selectedIndex].value;
	if (num_categories === 0 && template === "") {
		my_identity_profiler_alert("No new categories were chosen to add to Profiler.", "alert-warning", "Warning!  ", "categories");
		return;
	}
	var profile_name = localStorage.getItem("current_profile_name");
	param_str = param_str +  "template=" + template  + "&";

	param_str =  "profile_name=" + profile_name  + "&" + "num_categories=" + num_categories + "&" + param_str;
	param_str = param_str.slice(0, param_str.length - 1);
	processData(param_str, "insert_profiler_categories.php", "messages", false);
	try {
		var messages_data = localStorage.getItem("messages");
		var messages_obj = JSON.parse(messages_data);
	} catch (err) {
		console.log(err.message)
		my_identity_profiler_alert("insert_profiler_categories: Problem inserting new categories = " + err.message, "alert-danger", "Error!  ", "categories");
		return;
	}

	var message = messages_obj.message;
	var ret_code = messages_obj.ret_code;
	if (ret_code != 0) {
		my_identity_profiler_alert(message, "alert-danger", "Alert! ", "categories");
	}
	else {
		loadData(identity_profile_id);
		my_identity_profiler_alert(message, "alert-success", "Success!  ", "categories");
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
}