package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
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
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.*;
import java.util.ArrayList;

public class TransmitWami {
	private Context context;
	private ArrayList alWamiTransmitModel = new ArrayList();
	private ArrayList<String> alTransmitToProfiles = new ArrayList();
	private ArrayList alProfilesToTransmit = new ArrayList();
	private TransmitModel transmitModel;
	private String toastMessage = "";
  final private String INSERT_TRANSMITTED_PROFILE = Constants.IP + "insert_transmitted_profile.php";
	final private String GET_PROFILE_DATA = Constants.IP + "get_profile_data.php";
	final private String GET_PROFILE_NAMES = Constants.IP + "get_profile_names.php";
	final private String TRANSMIT_PROFILE_TO_EMAIL_ADDRESS_MOBILE = Constants.EMAIL_IP + "transmit_profile_to_email_address_mobile.php";
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
      if (profileNames == null) {
        return;
      }
			final ArrayAdapter<String> adapter = new ArrayAdapter<String> (context, R.layout.autocomplete_dropdown, profileNames);
			etWamiProfileName = (AutoCompleteTextView) dialog.findViewById(R.id.profile_name);
			etWamiProfileName.setAdapter(adapter);

			transmitWamiButton.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					int retCode = 0;
					String toProfileName;
					String toEmailAddress;
          toastMessage = "";

					EditText etEmailAddress = (EditText) dialog.findViewById(R.id.email_address);
          toProfileName = etWamiProfileName.getText().toString();
          toEmailAddress = (etEmailAddress.getText().toString()).replaceAll("\\s+", "");

					if (toEmailAddress.equals("") && toProfileName.equals("")) {
            Toast toast = Toast.makeText(context.getApplicationContext(), "Please provide a Profile Name and/or Email Address to publish to!" + "\n", Toast.LENGTH_LONG);
            toast.setGravity(Gravity.CENTER, 0, 0);
            toast.show();
						return;
					}

					if (!toProfileName.equals("")) {
						TransmitWamiData task = new TransmitWamiData();
            alTransmitToProfiles.add(toProfileName);
						task.execute(alTransmitToProfiles);
					}

					if (!toEmailAddress.equals("")) {
            retCode = emailAddressValidate(toEmailAddress);
            if (retCode == -1) {
              Toast toast = Toast.makeText(context.getApplicationContext(), "Invalid Email address. Must be in the form of user@host." + "\n", Toast.LENGTH_LONG);
              toast.setGravity(Gravity.CENTER, 0, 0);
              toast.show();
              return;
            }
            else {
              sendEmail(toEmailAddress);
            }
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

  private void sendEmail(String toEmailAddress) {
		int fromProfileId = 0;

		for (int i = 0; i < alWamiTransmitModel.size(); i++) {
			transmitModel = (TransmitModel) alWamiTransmitModel.get(i);
			String identityProfileId = String.valueOf(transmitModel.getWamiToTransmitId());
			fromProfileId = transmitModel.getFromIdentityProfileId();
      setUpEmailBody(identityProfileId, toEmailAddress, fromProfileId);

      Toast toast = Toast.makeText(context.getApplicationContext(), toastMessage, Toast.LENGTH_LONG);
      toast.setGravity(Gravity.CENTER, 0, 0);
      toast.show();
      toastMessage = "";
		}
  }

  private void setUpEmailBody(String identityProfileId, String toEmailAddress, int fromProfileId) {
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
		String fromFirstName;
		String fromLastName;
		String fromProfileName;
		String fromEmail;

		String[] postData = { identityProfileId, String.valueOf(fromProfileId), "NA"};

		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(context, GET_PROFILE_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
    try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int retCode = jsonResponse.optInt("ret_code");
			if (retCode == 1 || retCode == -1) {
				String message = jsonResponse.optString("message");
        toastMessage = toastMessage + message + "\n" ;
				return;
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
			fromFirstName = jsonChildNode.optString("from_first_name");
			fromLastName = jsonChildNode.optString("from_last_name");
			fromProfileName = jsonChildNode.optString("from_profile_name");
			fromEmail = jsonChildNode.optString("from_email");

		}
		catch (JSONException e) {
			e.printStackTrace();
      toastMessage = toastMessage + "Problem sending email. Email not delivered." + "\n" ;
			return;
		}

		String contactName = firstName + ' ' + lastName;
		postData = new String[] { toEmailAddress, "rob@roblanter.com", profileName,  fromFirstName, fromLastName, fromProfileName, contactName,
		email, profileType, description, streetAddress, city, state, zipcode, country, telephone, tags, createDate };

		jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(context, TRANSMIT_PROFILE_TO_EMAIL_ADDRESS_MOBILE, postData);
		jsonResult = jsonGetData.getJsonResult();
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
      int retCode = jsonResponse.optInt("retCode");
      if (retCode == 1) {
        toastMessage = toastMessage + "Problem sending email. Email not delivered." + "\n" ;
      }
      else {
        String message = profileName + " profile info emailed to " + toEmailAddress;
        toastMessage = toastMessage + message + "\n" ;
      }
		}
		catch (JSONException e) {
			e.printStackTrace();
      toastMessage = toastMessage + "Problem sending email. Email not delivered." + "\n" ;
		}
  }

	private class TransmitWamiData extends AsyncTask<ArrayList, Void, JSONObject> {
		@Override
		protected void onPostExecute(JSONObject resultObject) {
      int retCode = resultObject.optInt("ret_code");
      int noRecExistRetCode = resultObject.optInt("no_rec_found_ret_code");
      int recExistRetCode = resultObject.optInt("rec_exist_ret_code");

      if (retCode == -1) {
        String message = resultObject.optString("db_error");
        toastMessage = toastMessage + message + "\n" ;
      }

      if (noRecExistRetCode == 1 || recExistRetCode == 1 ) {
        String message = resultObject.optString("message");
        toastMessage = toastMessage + message + "\n" ;
      }

      if (retCode == 0) {
        String numProfilesTransmitted = String.valueOf(resultObject.optInt("num_profiles_transmitted"));
        toastMessage = toastMessage + "\nNumber of profiles published = " + numProfilesTransmitted;
      }
			Toast toast = Toast.makeText(context.getApplicationContext(), toastMessage, Toast.LENGTH_LONG);
			toast.setGravity(Gravity.CENTER, 0, 0);
			toast.show();
			toastMessage = "";
		}

		@Override
		protected JSONObject doInBackground(ArrayList... params) {
			JSONObject jsonResponse = null;
			try {
				ArrayList alTransmitToProfiles = params[0];
        String profilesToTransmit = "";
				int fromProfileId = 0;
				for (int i = 0; i < alWamiTransmitModel.size(); i++) {
					transmitModel = (TransmitModel) alWamiTransmitModel.get(i);
					alProfilesToTransmit.add(transmitModel.getWamiToTransmitId());
					fromProfileId = transmitModel.getFromIdentityProfileId();
          profilesToTransmit = transmitModel.getWamiToTransmitId() + "," + profilesToTransmit;
				}
        profilesToTransmit = profilesToTransmit.substring(0, (profilesToTransmit.length() -1));
				int numToTransmit = alProfilesToTransmit.size();
        String transmitToProfile = (String) alTransmitToProfiles.get(0);
				JSONObject json = new JSONObject();
        json.put("param1", numToTransmit);
        json.put("param2", fromProfileId);
        json.put("param3", profilesToTransmit);
        json.put("param4", transmitToProfile);
				HttpParams httpParams = new BasicHttpParams();
				HttpConnectionParams.setConnectionTimeout(httpParams, 5000);
				HttpConnectionParams.setSoTimeout(httpParams, 5000);
				HttpClient client = new DefaultHttpClient(httpParams);

				HttpPost request = new HttpPost(INSERT_TRANSMITTED_PROFILE);
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
				e.printStackTrace();
				return null;
			}
			catch (JSONException e) {
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
		}
		return answer;
	}

  private int emailAddressValidate(String toEmailAddressList) {
    String tmpEmailAddress = toEmailAddressList.replaceAll("\\s+","");

    if (!tmpEmailAddress.contains("@")) return -1;
    else return 0;
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
				return null;
			}
			JSONArray jsonNode = jsonResponse.optJSONArray("profile_names");
			profileNames = new String[jsonNode.length()];
			for (int i = 0; i < jsonNode.length(); i++) {
				profileNames[i] = jsonNode.optString(i);
			}
		}
		catch (JSONException e) {
			e.printStackTrace();
      Toast.makeText(context, "Problem publishing profile.", Toast.LENGTH_LONG).show();
			return null;
		}

		return profileNames;
	}
}