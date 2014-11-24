package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.R;
import com.MyWami.model.TransmitModel;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class TransmitWami {
	private Context context;
	private ArrayList alWamiTransmitModel = new ArrayList();
	private ArrayList<String> alTransmitToProfiles = new ArrayList();
	private ArrayList<String> alTransmitToEmailAddress = new ArrayList();
	private ArrayList alProfilesToTransmit = new ArrayList();
	private TransmitModel transmitModel;
	private String toastMessage = "";
	final private String INSERT_TRANSMITTED_PROFILE_DATA = Constants.IP + "insert_transmitted_profile_data.php";
	final private String GET_IDENTITY_PROFILE_DATA = Constants.IP + "get_identity_profile_data.php";
	final private String GET_PROFILE_NAMES = Constants.IP + "get_profile_names.php";
	private String profileNames[];
	private AutoCompleteTextView etWamiProfileName;

	public TransmitWami() {
	}

	public void transmitWami(ArrayList alWamiTransmitModel, final Context context, boolean isSelected ) {
		this.context = context;
		this.alWamiTransmitModel = alWamiTransmitModel;

		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		if (isSelected) {
			dialog.setContentView(R.layout.dialog_transmit_wami);
			Button transmitWamiButton = (Button) dialog.findViewById(R.id.dialogButtonTransmitWami);

			profileNames = getProfileNames(context);
			final ArrayAdapter<String> adapter = new ArrayAdapter<String> (context, R.layout.autocomplete_dropdown, profileNames);
			etWamiProfileName = (AutoCompleteTextView) dialog.findViewById(R.id.profile_name);
			etWamiProfileName.setAdapter(adapter);

			transmitWamiButton.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					int retCode;
					String toProfileNames;
					String toEmailAddress;

					EditText etEmailAddress = (EditText) dialog.findViewById(R.id.email_address);
					toProfileNames = etWamiProfileName.getText().toString();
					toEmailAddress = etEmailAddress.getText().toString();
					if (toEmailAddress.equals("") && toProfileNames.equals("")) {
						Toast.makeText(context.getApplicationContext(), "Enter Wami Profile Name(s), Email Address(s) and/or Wami Group(s)", Toast.LENGTH_LONG).show();
						return;
					}

					if (!toProfileNames.equals("")) retCode = parseToProfileName(toProfileNames);
					else retCode = 0;
					if (retCode == -1) {
						Toast.makeText(context.getApplicationContext(), "Profile names must be six or more characters.", Toast.LENGTH_LONG).show();
						return;
					}
					if (retCode == -2) {
						Toast.makeText(context.getApplicationContext(), "Profile names must only contain letters, numbers, dashes and hyphens.", Toast.LENGTH_LONG).show();
						return;
					}

					if (retCode == 1) {
						TransmitWamiData task = new TransmitWamiData();
						task.execute(alTransmitToProfiles);
					}

					if (!toEmailAddress.equals("")) retCode = parseToEmailAddress(toEmailAddress);
					else retCode = 0;
					if (retCode == -1) {
						Toast.makeText(context.getApplicationContext(), "Invalid Email address. Must be in the form of user@host.", Toast.LENGTH_LONG).show();
						return;
					}

					if (retCode == 1) sendEmail(alTransmitToEmailAddress);
					if (toProfileNames.equals("")) {
						Toast toast = Toast.makeText(context.getApplicationContext(), toastMessage, Toast.LENGTH_LONG);
						toast.setGravity(Gravity.BOTTOM, 0, 0);
						toast.show();
					}
				}
			});

			Button closeTransmitWamiButton = (Button) dialog.findViewById(R.id.closeTransmitWami);
			closeTransmitWamiButton.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});
		}
		else {
			dialog.setContentView(R.layout.dialog_no_wami_to_transmit);
			Button closeTransmitWamiButton = (Button) dialog.findViewById(R.id.closeTransmitWami);
			closeTransmitWamiButton.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					dialog.dismiss();
				}
			});
		}
		dialog.show();
	}

	private void sendEmail(ArrayList<String> alEmailList) {
		String body = "";
		String[] emails = new String[alEmailList.size()];
		alEmailList.toArray(emails);

		for (int i = 0; i < alWamiTransmitModel.size(); i++) {
			transmitModel = (TransmitModel) alWamiTransmitModel.get(i);
			String identityProfileId = String.valueOf(transmitModel.getWamiToTransmitId());
			body = getEmailBody(identityProfileId) + body;
		}

		final Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
		emailIntent.setType("plain/text");
		emailIntent.putExtra(android.content.Intent.EXTRA_EMAIL, emails);
		emailIntent.putExtra(android.content.Intent.EXTRA_SUBJECT, "Wami Profile(s)");
		emailIntent.putExtra(android.content.Intent.EXTRA_TEXT, body);
		context.startActivity(Intent.createChooser(emailIntent, "Send mail..."));
		toastMessage = toastMessage + "\n\nNumber of profiles emailed = " + alEmailList.size();
	}

	private String getEmailBody(String identityProfileId) {
		String firstName;
		String lastName;
		String profileName;
		String description;
		String email;
		String profileType;
		String streetAddress;
		String city;
		String state;
		String zipcode;
		String country;
		String telephone;
		String createDate;
		 String tags;

		String body;
		String[] postData = { identityProfileId };
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(context, GET_IDENTITY_PROFILE_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int ret_code = jsonResponse.optInt("ret_code");
			if (ret_code == 0) {
				String message = jsonResponse.optString("message");
				Toast.makeText(context, message, Toast.LENGTH_LONG).show();
				return "";
			}
			if (ret_code == -1) {
//				Log.e("**** Get Identity Profile data DBError", jsonResponse.optString("db_error"));
				return "";
			}

			JSONArray jsonNode = jsonResponse.optJSONArray("identity_profile_data");
			JSONObject jsonChildNode = jsonNode.getJSONObject(0);
			profileName = jsonChildNode.optString("profile_name");
			description = jsonChildNode.optString("description");
			firstName = jsonChildNode.optString("first_name");
			lastName = jsonChildNode.optString("last_name");
			profileType = jsonChildNode.optString("profile_type");
			tags = jsonChildNode.optString("tags");
			email = jsonChildNode.optString("email");
			streetAddress = jsonChildNode.optString("street_address");
			city = jsonChildNode.optString("city");
			state = jsonChildNode.optString("state");
			zipcode = jsonChildNode.optString("zipcode");
			country = jsonChildNode.optString("country");
			telephone = jsonChildNode.optString("telephone");
			createDate = (jsonChildNode.optString("create_date")).substring(0, 10);
		}
		catch (JSONException e) {
//			Log.e("****TransmitWami Error", e.toString(), e);
			e.printStackTrace();
			return "";
		}

		body = "\n" +
						"Profile Name: " + profileName + "\n"  +
						"Contact Name: " + firstName + " " + lastName + "\n"  +
						"Email Address: " + email + "\n"        +
						"Profile Type: " + profileType + "\n" +
						"Description: " + description + "\n"  +
						"Street Address: " + streetAddress + "\n" +
						"City: " + city + "\n"         +
						"State: " + state + "\n"        +
						"Zipcode: " + zipcode + "\n"      +
						"Country: " + country + "\n"      +
						"Telephone Number: " + telephone + "\n"    +
						"Tags: " + tags + "\n"         +
						"Profile Create Date: " + createDate + "\n\n" +
						"For extended profiler info download the Wami app from the Apple App Store or Google Play! \n" +
						"-----------------------------------------------------------------------------\n";
		return(body);
	}

	public class TransmitWamiData extends AsyncTask<ArrayList, Void, JSONObject> {

		@Override
		protected void onPostExecute(JSONObject resultObject) {
			JSONObject jsonDbError = resultObject.optJSONObject("db_error");
//			Log.e("****TransmitWami DBError", String.valueOf(jsonDbError));

			JSONArray jsonSQL = resultObject.optJSONArray("sql");
			for (int i = 0; i < jsonSQL.length(); i++) {
//				Log.i("****TransmitWami SQL", jsonSQL.optString(i));
			}

			JSONArray jsonNoRecordsFound = resultObject.optJSONArray("no_records_found");
			String [] noRecordsFound = new String[jsonNoRecordsFound.length()];
			for (int i = 0; i < noRecordsFound.length; i++) {
				noRecordsFound[i] = jsonNoRecordsFound.optString(i);
				toastMessage = toastMessage + noRecordsFound[i] + "\n\n" ;
			}

			JSONArray jsonRecordAlreadyExist = resultObject.optJSONArray("record_already_exist");
			String [] recordAlreadyExist = new String[jsonRecordAlreadyExist.length()];
			for (int i = 0; i < recordAlreadyExist.length; i++) {
				recordAlreadyExist[i] = jsonRecordAlreadyExist.optString(i);
				toastMessage = toastMessage + recordAlreadyExist[i] + "\n\n";
			}

			String numProfilesTransmitted = String.valueOf(resultObject.optInt("num_profiles_transmitted"));
			if (numProfilesTransmitted != null) {
				toastMessage = toastMessage + "\nNumber of profiles transmitted = " + numProfilesTransmitted;
			}

			Toast toast = Toast.makeText(context.getApplicationContext(), toastMessage, Toast.LENGTH_LONG);
			toast.setGravity(Gravity.BOTTOM, 0, 0);
			toast.show();
			toastMessage = "";
		}

		@Override
		protected JSONObject doInBackground(ArrayList... params) {
			JSONObject jsonResponse = null;
			try {
				ArrayList alTransmitToProfiles = params[0];
				int numTransmitTo = alTransmitToProfiles.size();
				int fromProfileId = 0;
				for (int i = 0; i < alWamiTransmitModel.size(); i++) {
					transmitModel = (TransmitModel) alWamiTransmitModel.get(i);
					alProfilesToTransmit.add(transmitModel.getWamiToTransmitId());
					fromProfileId = transmitModel.getFromIdentityProfileId();
				}
				int numToTransmit = alProfilesToTransmit.size();
				JSONObject json = new JSONObject();
				json.put("num_transmit_to", numTransmitTo);
				json.put("transmit_to_profiles", alTransmitToProfiles);
				json.put("num_to_transmit", numToTransmit);
				json.put("profiles_to_transmit", alProfilesToTransmit);
				json.put("from_profile_id", fromProfileId);

				HttpParams httpParams = new BasicHttpParams();
				HttpConnectionParams.setConnectionTimeout(httpParams, 5000);
				HttpConnectionParams.setSoTimeout(httpParams, 5000);
				HttpClient client = new DefaultHttpClient(httpParams);

				HttpPost request = new HttpPost(INSERT_TRANSMITTED_PROFILE_DATA);
				request.setEntity(new ByteArrayEntity(json.toString().getBytes()));
				request.setHeader("json", json.toString());
				HttpResponse response = client.execute(request);
				HttpEntity entity = response.getEntity();

				alTransmitToProfiles.clear();
				alProfilesToTransmit.clear();

				if (entity != null) {
					InputStream instream = entity.getContent();
					try {
						String jsonResult = inputStreamToString(instream).toString();
						jsonResponse = new JSONObject(jsonResult);
					}
					finally {
						instream.close();
					}
				}
			}
			catch (IOException e) {
//				Log.e("****TransmitWami Error", e.toString(), e);
				e.printStackTrace();
				return null;
			}
			catch (JSONException e) {
//				Log.e("****TransmitWami Error", e.toString(), e);
				e.printStackTrace();
				return null;
			}
			return jsonResponse;
		}
	}

	private StringBuilder inputStreamToString(InputStream is) {
		String rLine;
		StringBuilder answer = new StringBuilder();
		BufferedReader rd = new BufferedReader(new InputStreamReader(is));

		try {
			while ((rLine = rd.readLine()) != null) {
				answer.append(rLine);
			}
		}

		catch (IOException e) {
			e.printStackTrace();
//			Log.e("****TransmitWami Error", e.toString(), e);
		}
		return answer;
	}

	private int parseToEmailAddress(String toEmailAddressList) {
		String list;
		String toEmailAddress;
		int begPos = 0;
		int endPos;

		list = toEmailAddressList.replaceAll("\\s+","");
		endPos = list.indexOf(";");
		if (endPos == -1) {
			toEmailAddress = list.substring(begPos, list.length());
			if (!toEmailAddress.contains("@")) return -1;
			alTransmitToEmailAddress.add(toEmailAddress);
			return 1;
		}
		while (true) {
			toEmailAddress = list.substring(begPos, endPos);
			if (!toEmailAddress.contains("@")) return -1;
			alTransmitToEmailAddress.add(toEmailAddress);
			begPos = endPos;
			if (list.indexOf(";", begPos + 1) == -1) {
				toEmailAddress = list.substring(begPos + 1, list.length());
				if (!toEmailAddress.contains("@")) return -1;
				alTransmitToEmailAddress.add(toEmailAddress);
				break;
			}
			endPos = list.indexOf(";", begPos + 1);
		}

		return 1;
	}

	private int parseToProfileName(String toProfileNameList) {
		String list;
		String toProfileName;
		int begPos = 0;
		int endPos;

		list = toProfileNameList.replaceAll("\\s+","");
		endPos = list.indexOf(";");
		if (endPos == -1) {
			toProfileName = list.substring(begPos, list.length());
			if (toProfileName.length() < 7) return -1;
			if (!toProfileName.matches("^[a-zA-Z0-9-_]*$")) return -2;
			alTransmitToProfiles.add(toProfileName);
			return 1;
		}
		while (true) {
			toProfileName = list.substring(begPos, endPos);
			if (toProfileName.length() < 7) return -1;
			if (!toProfileName.matches("^[a-zA-Z0-9-_]*$")) return -2;
			alTransmitToProfiles.add(toProfileName);
			begPos = endPos;
			if (list.indexOf(";", begPos + 1) == -1) {
				toProfileName = list.substring(begPos + 1, list.length());
				if (toProfileName.length() < 7) return -1;
				if (!toProfileName.matches("^[a-zA-Z0-9-_]*$")) return -2;
				alTransmitToProfiles.add(toProfileName);
				break;
			}
			endPos = list.indexOf(";", begPos + 1);
		}

		return 1;
	}

	private String[] getProfileNames(Context context) {
		String profileNames[] = null;
		String postData[] = new String[1];

		postData[0] = null;
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(context, GET_PROFILE_NAMES, postData);
		String jsonResult = jsonGetData.getJsonResult();

		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int ret_code = jsonResponse.optInt("ret_code");
			if (ret_code == 1) {
				String message = jsonResponse.optString("message");
				Toast.makeText(context, message, Toast.LENGTH_LONG).show();
				return null;
			}
			if (ret_code == -1) {
//				Log.e("**** Get Profile Names list DBError", jsonResponse.optString("db_error"));
				return null;
			}
			JSONArray jsonNode = jsonResponse.optJSONArray("profile_names");
			profileNames = new String[jsonNode.length()];
			for (int i = 0; i < jsonNode.length(); i++) {
//				JSONObject jsonChildNode = jsonNode.getJSONObject(i);
				profileNames[i] = jsonNode.optString(i);
			}
		}
		catch (JSONException e) {
//			Log.e("****TransmitWami Error", e.toString(), e);
			e.printStackTrace();
			return null;
		}

		return profileNames;
	}
}