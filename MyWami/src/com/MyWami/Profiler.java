package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import com.MyWami.dialogs.ActionList;
import com.MyWami.dialogs.TransmitWami;
import com.MyWami.model.AudioFileModel;
import com.MyWami.model.ImageFileModel;
import com.MyWami.model.ProfilerModel;
import com.MyWami.model.TransmitModel;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

/**
 * Created by robertlanter on 3/9/14.
 */
public class Profiler extends ListActivity {
	private ProfilerModel[] profilerModel;
	private AudioFileModel[] audioFileModel;
	private ImageFileModel[] imageFileModel;
	private String identityProfileId;
	private String imageUrl;
	private String profileName;
	private String firstName;
	private String lastName;
	private String userIdentityProfileId;
	private boolean useDefault;
	private ArrayList alWamiTransmitModel = new ArrayList();

	private int no_images_ret_code;
	private int no_text_ret_code;
	private int no_pdf_ret_code;
	private int no_audio_ret_code;

	private Context that;

	final private String GET_PROFILER_DATA = Constants.IP + "get_profiler_data.php";


//	@TargetApi(Build.VERSION_CODES.ICE_CREAM_SANDWICH)
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_profiler);
		actionBar.setDisplayShowTitleEnabled(true);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		if (savedInstanceState == null) {
			Bundle extras = getIntent().getExtras();
			imageUrl = extras.getString("image_url");
			profileName = extras.getString("profile_name");
			identityProfileId = extras.getString("identity_profile_id");
			firstName = extras.getString("first_name");
			lastName = extras.getString("last_name");
			userIdentityProfileId = extras.getString("user_identity_profile_id");
			useDefault = extras.getBoolean("use_default");
		}

		View header = getLayoutInflater().inflate(R.layout.wami_header, null);
		ListView listView = getListView();
		listView.addHeaderView(header);

		TextView textView = (TextView) findViewById(R.id.wami_heading_text_entity);
		textView.setText(profileName);
		textView = (TextView) findViewById(R.id.wami_heading_text_user_name);
		textView.setText(firstName + " " + lastName);

		Drawable imageUrlId;
		imageUrlId = this.getResources().getDrawable(this.getResources().getIdentifier(imageUrl, "drawable", this.getPackageName()));
		ImageView imageView = (ImageView) findViewById(R.id.wami_heading_image);
		imageView.setImageDrawable(imageUrlId);

		header.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				Intent i = new Intent(Profiler.this, Flash.class);
				i.putExtra("identity_profile_id", identityProfileId);
				i.putExtra("image_url", imageUrl);
				i.putExtra("profile_name", profileName);
				i.putExtra("first_name", firstName);
				i.putExtra("last_name", lastName);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				startActivity(i);
			}
		});

		String[] postData = { identityProfileId };
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(this, GET_PROFILER_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
		profilerModel = assignData(jsonResult);
		if (profilerModel == null) {
			return;
		}

		String[] profileList = new String[profilerModel.length];
		for (int j = 0; j < (profilerModel.length); j++) {
			profileList[j] = profilerModel[j].getCategory();
		}

		setListAdapter(new ProfilerAdapter(this, profileList));
	}

	@Override
	protected void onSaveInstanceState(Bundle savedInstanceState) {
		savedInstanceState.putString("identity_profile_id", identityProfileId);
		super.onSaveInstanceState(savedInstanceState);
	}

	@Override
	public void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState);
		identityProfileId = savedInstanceState.getString(identityProfileId);
	}

	private ProfilerModel[] assignData(String jsonResult) {
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int ret_code = jsonResponse.optInt("ret_code");
			int no_categories_ret_code = jsonResponse.optInt("no_categories_ret_code");
			no_images_ret_code = jsonResponse.optInt("no_images_ret_code");
			no_text_ret_code = jsonResponse.optInt("no_text_ret_code");
			no_pdf_ret_code = jsonResponse.optInt("no_pdf_ret_code");
			no_audio_ret_code = jsonResponse.optInt("no_audio_ret_code");
			if (ret_code == 1) {
				String message = jsonResponse.optString("message");
				Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				//return null;
			}
			if (ret_code == -1) {
//				Log.e("**** Get Identity Profiler DBError", jsonResponse.optString("db_error"));
				return null;
			}
			if (no_categories_ret_code == 1) {
				String message = jsonResponse.optString("message");
				Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				return null;
			}
			JSONArray jsonMainNode = jsonResponse.optJSONArray("identity_profiler_data");

			profilerModel = new ProfilerModel[jsonMainNode.length()];
			for (int i = 0; i < jsonMainNode.length(); i++) {
				JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
				int identityProfileId = jsonChildNode.optInt("identity_profile_id");
				String category = jsonChildNode.optString("category");
				String mediaType = jsonChildNode.optString("media_type");

				profilerModel[i] = new ProfilerModel();
				String fileLocation;
				String fileName;
				String textDoc;

				if ((mediaType.equals("Text")) && (no_text_ret_code != 1)) {
					JSONObject fileObj = jsonChildNode.getJSONObject("file");
					fileLocation = fileObj.getString("file_location");
					fileName = fileObj.getString("file_name");
					profilerModel[i].setFileLocation(fileLocation);
					profilerModel[i].setFileName(fileName);
				}

				if ((mediaType.equals("PDF")) && (no_pdf_ret_code != 1)) {
					JSONObject fileObj = jsonChildNode.getJSONObject("file");
					fileLocation = fileObj.getString("file_location");
					fileName = fileObj.getString("file_name");
					profilerModel[i].setFileLocation(fileLocation);
					profilerModel[i].setFileName(fileName);
				}

				if ((mediaType.equals("Audio")) && (no_audio_ret_code != 1)) {
					JSONObject fileObj = jsonChildNode.getJSONObject("file");
					JSONArray audioFiles =  fileObj.getJSONArray("audio");
					audioFileModel = new AudioFileModel[audioFiles.length()];
					for (int j = 0; j < audioFiles.length(); j++) {
						audioFileModel[j] = new AudioFileModel();
						fileLocation = audioFiles.getJSONObject(j).getString("file_location");
						fileName = audioFiles.getJSONObject(j).getString("file_name");
						String audioFileDescription = audioFiles.getJSONObject(j).getString("audio_file_description");
						String audioFileName = audioFiles.getJSONObject(j).getString("audio_file_name");
						audioFileModel[j].setFileLocation(fileLocation);
						audioFileModel[j].setFileName(fileName);
						audioFileModel[j].setAudioDescription(audioFileDescription);
						audioFileModel[j].setAudioFileName(audioFileName);
					}
					profilerModel[i].setAudioFileModel(audioFileModel);
				}

				if ((mediaType.equals("Image")) && (no_images_ret_code != 1)) {
					JSONObject fileObj = jsonChildNode.getJSONObject("file");
					JSONArray imageFiles =  fileObj.getJSONArray("image");
					imageFileModel = new ImageFileModel[imageFiles.length()];
					for (int j = 0; j < imageFiles.length(); j++) {
						imageFileModel[j] = new ImageFileModel();
						fileLocation = imageFiles.getJSONObject(j).getString("file_location");
						fileName = imageFiles.getJSONObject(j).getString("file_name");
						String imageDescription = imageFiles.getJSONObject(j).getString("image_description");
						String imageName = imageFiles.getJSONObject(j).getString("image_name");
						imageFileModel[j].setFileLocation(fileLocation);
						imageFileModel[j].setFileName(fileName);
						imageFileModel[j].setImageDescription(imageDescription);
						imageFileModel[j].setImageName(imageName);
					}
					profilerModel[i].setImageFileModel(imageFileModel);
				}

				profilerModel[i].setIdentityProfileId(identityProfileId);
				profilerModel[i].setCategory(category);
				profilerModel[i].setMediaType(mediaType);
			}
		}
		catch (JSONException e) {
			e.printStackTrace();
//			Log.e("**** Profiler: json error: ", e.toString(), e);
			return null;
		}

		return profilerModel;
	}

	protected void onListItemClick(ListView l, View v, int position, long id) {
		position--;
		ProfilerAdapter profileAdapter = (ProfilerAdapter) getListAdapter();
		String selectedValue = profileAdapter.getItem(position);
		Toast.makeText(this, selectedValue, Toast.LENGTH_SHORT).show();

		if (profilerModel[position].getMediaType().equals("Audio")) {
			if (no_audio_ret_code != 1) {
				audioFileModel = profilerModel[position].getAudioFileModel();
				String[] audioFileName = new String[audioFileModel.length];
				String[] fileName = new String[audioFileModel.length];
				String[] fileLocation = new String[audioFileModel.length];
				String[] audioDescription = new String[audioFileModel.length];
				for (int i = 0; i < (audioFileModel.length); i++) {
					audioFileName[i] = audioFileModel[i].getAudioFileName();
					fileName[i] = audioFileModel[i].getFileName();
					fileLocation[i] = audioFileModel[i].getFileLocation();
					audioDescription[i] = audioFileModel[i].getAudioDescription();
				}
				Intent intent = new Intent(Profiler.this, ProfilerAudioView.class);
				intent.putExtra("audio_file_name", audioFileName);
				intent.putExtra("file_name", fileName);
				intent.putExtra("file_location", fileLocation);
				intent.putExtra("audio_description", audioDescription);

				intent.putExtra("image_url", imageUrl);
				intent.putExtra("profile_name", profileName);
				intent.putExtra("identity_profile_id", identityProfileId);
				intent.putExtra("first_name", firstName);
				intent.putExtra("last_name", lastName);
				intent.putExtra("user_identity_profile_id", userIdentityProfileId);
				intent.putExtra("use_default", useDefault);

				startActivity(intent);
			}
			if (no_audio_ret_code == 1) {
				Toast.makeText(this, "No audio files have been uploaded yet!", Toast.LENGTH_LONG).show();
			}
		}


		if (profilerModel[position].getMediaType().equals("Image")) {
			if (no_images_ret_code != 1) {
				imageFileModel = profilerModel[position].getImageFileModel();
				String[] imageName = new String[imageFileModel.length];
				String[] fileName = new String[imageFileModel.length];
				String[] fileLocation = new String[imageFileModel.length];
				String[] imageDescription = new String[imageFileModel.length];
				for (int i = 0; i < (imageFileModel.length); i++) {
					imageName[i] = imageFileModel[i].getImageName();
					fileName[i] = imageFileModel[i].getFileName();
					fileLocation[i] = imageFileModel[i].getFileLocation();
					imageDescription[i] = imageFileModel[i].getImageDescription();
				}
				Intent intent = new Intent(Profiler.this, ProfilerImageView.class);
				intent.putExtra("image_name", imageName);
				intent.putExtra("file_name", fileName);
				intent.putExtra("file_location", fileLocation);
				intent.putExtra("image_description", imageDescription);

				intent.putExtra("image_url", imageUrl);
				intent.putExtra("profile_name", profileName);
				intent.putExtra("identity_profile_id", identityProfileId);
				intent.putExtra("first_name", firstName);
				intent.putExtra("last_name", lastName);
				intent.putExtra("user_identity_profile_id", userIdentityProfileId);
				intent.putExtra("use_default", useDefault);

				startActivity(intent);
			}
			if (no_images_ret_code == 1) {
				Toast.makeText(this, "No images files have been uploaded yet!", Toast.LENGTH_LONG).show();
			}
		}

		if (profilerModel[position].getMediaType().equals("PDF")) {
			if (no_pdf_ret_code != 1) {
				GetFile task = new GetFile();
				try {
					String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
					File folder = new File(extStorageDirectory, "pdf");
					folder.mkdir();
					ArrayList<String> params = new ArrayList<String>();
					params.add(profilerModel[position].getFileLocation());
					params.add(profilerModel[position].getFileName());
					params.add(String.valueOf(folder));
					task.execute(new ArrayList[]{params}).get();

					try {
						Intent intent = new Intent();
						intent.setAction(Intent.ACTION_VIEW);
						File fileToRead = new File(folder + "/" + profilerModel[position].getFileName());
						Uri uri = Uri.fromFile(fileToRead.getAbsoluteFile());
						intent.setDataAndType(uri, "application/pdf");
						startActivity(intent);
					} catch (ActivityNotFoundException activityNotFoundException) {
						activityNotFoundException.printStackTrace();
						Toast.makeText(this, "There doesn't seem to be a PDF reader installed.", Toast.LENGTH_LONG).show();
					} catch (Exception ex) {
						ex.printStackTrace();
						Toast.makeText(this, "Cannot open the selected file.", Toast.LENGTH_LONG).show();
					}
				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (ExecutionException e) {
					e.printStackTrace();
				}
			}
			if (no_pdf_ret_code == 1) {
				Toast.makeText(this, "No pdf files have been uploaded yet!", Toast.LENGTH_LONG).show();
			}
		}

		if (profilerModel[position].getMediaType().equals("Text")) {
			if (no_text_ret_code != 1) {
				GetFile task = new GetFile();
				try {
					String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
					File folder = new File(extStorageDirectory, "text");
					folder.mkdir();
					ArrayList<String> params = new ArrayList<String>();
					params.add(profilerModel[position].getFileLocation());
					params.add(profilerModel[position].getFileName());
					params.add(String.valueOf(folder));
					task.execute(new ArrayList[]{params}).get();

					try {
						Intent intent = new Intent();
						intent.setAction(Intent.ACTION_VIEW);
						File fileToRead = new File(folder + "/" + profilerModel[position].getFileName());
						Uri uri = Uri.fromFile(fileToRead.getAbsoluteFile());
						intent.setDataAndType(uri, "text/plain");
						startActivity(intent);
					} catch (ActivityNotFoundException activityNotFoundException) {
						activityNotFoundException.printStackTrace();
						Toast.makeText(this, "There doesn't seem to be a Text reader installed.", Toast.LENGTH_LONG).show();
					} catch (Exception ex) {
						ex.printStackTrace();
						Toast.makeText(this, "Cannot open the selected file.", Toast.LENGTH_LONG).show();
					}

				} catch (InterruptedException e) {
					e.printStackTrace();
				} catch (ExecutionException e) {
					e.printStackTrace();
				}
			}
			if (no_text_ret_code == 1) {
				Toast.makeText(this, "No text files have been uploaded yet!", Toast.LENGTH_LONG).show();
			}
		}
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.profiler_menu, menu);
		return super.onCreateOptionsMenu(menu);
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		switch (id) {
			case android.R.id.home:
				super.onBackPressed();
				return true;
		}

//Transmit wami
		if (id == R.id.action_transmit_wami) {
			alWamiTransmitModel.clear();
			TransmitModel transmitModel = new TransmitModel();
			transmitModel.setWamiToTransmitId(Integer.parseInt(identityProfileId));
			transmitModel.setFromIdentityProfileId(Integer.parseInt(userIdentityProfileId));
			alWamiTransmitModel.add(transmitModel);
			TransmitWami transmitWami = new TransmitWami();
			transmitWami.transmitWami(alWamiTransmitModel, that, true);
		}

// My Wami Network
		if (id == R.id.action_home) {
			Intent i = new Intent(Profiler.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

//Navigatio action
		if (id == R.id.action_navigate_to) {
			ActionList actionList = new ActionList();
			actionList.actionList(that, identityProfileId, imageUrl, profileName, firstName, lastName, userIdentityProfileId, useDefault);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(Profiler.this, Login.class);
			startActivity(i);
		}
		return super.onOptionsItemSelected(item);
	}

	public class GetFile extends AsyncTask<ArrayList, Void, Void> {
		@Override
		protected Void doInBackground(ArrayList... params) {
			try {
				String fileLocation = String.valueOf(params[0].get(0));
				String fileName = String.valueOf(params[0].get(1));
				String folder = String.valueOf(params[0].get(2));

				String path = Constants.ASSETS_IP + fileLocation + fileName;
				URL u = new URL(path);

				HttpParams httpParameters = new BasicHttpParams();
				HttpURLConnection c = (HttpURLConnection) u.openConnection();
				int timeoutConnection = 3000;
				int timeoutSocket = 5000;
				HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);
				HttpConnectionParams.setConnectionTimeout(httpParameters, timeoutConnection);

				InputStream is = c.getInputStream();
				FileOutputStream fos = new FileOutputStream(new File(folder + "/" + fileName));
				int bytesRead = 0;
				byte[] buffer = new byte[4096];
				while ((bytesRead = is.read(buffer)) != -1) {
					fos.write(buffer, 0, bytesRead);
				}
				fos.close();
				is.close();
				c.disconnect();
			}
			catch (MalformedURLException e) {
				e.printStackTrace();
			}
			catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}
	}
}
