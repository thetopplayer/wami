package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Paint;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.ContactsContract;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import com.MyWami.dialogs.ActionList;
import com.MyWami.dialogs.TransmitWami;
import com.MyWami.model.TransmitModel;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;

public class WamiInfoExtended extends Activity {
	final private String GET_PROFILE_DATA = Constants.IP + "get_profile_data.php";
	final private String GET_PROFILER_DATA = Constants.IP + "get_profiler_data.php";
	final private String GET_PROFILE_NAME = Constants.IP + "get_profile_name.php";
	JsonGetData jsonGetData;
	private String userIdentityProfileId;
	private boolean useDefault;
	private ArrayList alWamiTransmitModel = new ArrayList();
	private Context that;

	private String identityProfileId;
	private String firstName;
	private String lastName;
	private String profileName;
	private String description;
	private String imageUrl;
	private String email;
	private String profileType;
	private String streetAddress;
	private String city;
	private String state;
	private String zipcode;
	private String country;
	private String telephone;
	private String createDate;
	private String tags;
	private String groups = "";
	private String searchable;
	private String activeInd;
	private String rating;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.wami_info_extended);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_wami_info);
		actionBar.setDisplayShowTitleEnabled(true);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		Bundle extras = getIntent().getExtras();
		identityProfileId = extras.getString("identity_profile_id");
		userIdentityProfileId = extras.getString("user_identity_profile_id");
		useDefault = extras.getBoolean("use_default");

		String jsonResult = getJsonData(identityProfileId, userIdentityProfileId);
		boolean result = assignData(jsonResult);
		if (result) {

			TextView tvProfileName = (TextView) findViewById(R.id.profile_name);
			tvProfileName.setText(profileName);

			TextView tvDescription = (TextView) findViewById(R.id.description);
			tvDescription.setText(description);

			TextView tvContactName = (TextView) findViewById(R.id.contact_name);
			tvContactName.setText(firstName + " " + lastName);

			TextView tvTags = (TextView) findViewById(R.id.tags);
			tvTags.setText(tags);

			TextView tvEmail = (TextView) findViewById(R.id.email);
			tvEmail.setText(email);
			tvEmail.setPaintFlags(tvEmail.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
			tvEmail.setOnClickListener(new View.OnClickListener() {
				public void onClick(View v) {
					Intent intent = new Intent(Intent.ACTION_SENDTO);
					intent.setData(Uri.parse("mailto:"));
					intent.putExtra(Intent.EXTRA_EMAIL, new String[] { email });
					String userProfileName = null;

					jsonGetData = new JsonGetData();
					String[] postData = {userIdentityProfileId};
					jsonGetData.jsonGetData(getApplicationContext(), GET_PROFILE_NAME, postData);
					String jsonResult = jsonGetData.getJsonResult();
					try {
						JSONObject jsonResponse = new JSONObject(jsonResult);
						userProfileName = jsonResponse.getString("profile_name");
					}
					catch (JSONException e) {
						Toast.makeText(getApplicationContext(), "Error" + e.toString(), Toast.LENGTH_LONG).show();
//					Log.e("****Request Profile Error", e.toString(), e);
						e.printStackTrace();
					}

					intent.putExtra(Intent.EXTRA_SUBJECT, "Message From Wami Profile: " + userProfileName);
					if (intent.resolveActivity(getPackageManager()) != null) {
						startActivity(intent);
					}
				}
			});

			TextView tvTelephone = (TextView) findViewById(R.id.telephone);
			tvTelephone.setText(telephone);
			tvTelephone.setPaintFlags(tvTelephone.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
			tvTelephone.setOnClickListener(new View.OnClickListener() {
				public void onClick(View v) {
					Intent intent = new Intent(Intent.ACTION_DIAL);
					intent.setData(Uri.parse("tel:" + telephone));
					if (intent.resolveActivity(getPackageManager()) != null) {
						startActivity(intent);
					}
				}
			});

			TextView tvProfileType = (TextView) findViewById(R.id.profile_type);
			tvProfileType.setText(profileType);

			TextView tvStreetAddress = (TextView) findViewById(R.id.street_address);
			tvStreetAddress.setText(streetAddress);

			TextView tvCity = (TextView) findViewById(R.id.city);
			tvCity.setText(city);

			TextView tvState = (TextView) findViewById(R.id.state);
			tvState.setText(state);

			TextView tvZipcode = (TextView) findViewById(R.id.zipcode);
			tvZipcode.setText(zipcode);

			TextView tvCountry = (TextView) findViewById(R.id.country);
			tvCountry.setText(country);

			TextView tvCreateDate = (TextView) findViewById(R.id.create_date);
			tvCreateDate.setText(createDate);

			TextView tvSearchable = (TextView) findViewById(R.id.searchable);
			tvSearchable.setText(searchable);

			TextView tvProfileStatus = (TextView) findViewById(R.id.active_ind);
			tvProfileStatus.setText(activeInd);

			TextView tvGroups = (TextView) findViewById(R.id.groups);
			tvGroups.setText(groups);

		}
		else Toast.makeText(this, "Error: Problem getting Identity Profile data!" , Toast.LENGTH_LONG).show();

		Drawable imageUrlId;
		imageUrlId = this.getResources().getDrawable(this.getResources().getIdentifier(imageUrl, "drawable", this.getPackageName()));
		ImageView imageView = (ImageView) findViewById(R.id.wami_heading_image);
		imageView.setImageDrawable(imageUrlId);

		RelativeLayout rlWamiInfoExtended = (RelativeLayout) findViewById(R.id.wami_info_extended);
		rlWamiInfoExtended.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				String[] postData = { identityProfileId };
				JsonGetData jsonGetData = new JsonGetData();
				jsonGetData.jsonGetData(getApplicationContext(), GET_PROFILER_DATA, postData);
				String jsonResult = jsonGetData.getJsonResult();
				JSONObject jsonResponse = null;
				try {
					jsonResponse = new JSONObject(jsonResult);
				}
				catch (JSONException e) {
					e.printStackTrace();
//					Log.e("**** Profiler: json error: ", e.toString(), e);
				}
				int ret_code = jsonResponse.optInt("ret_code");
				int no_categories_ret_code = jsonResponse.optInt("no_categories_ret_code");
				if (ret_code == 1) {
					String message = jsonResponse.optString("message");
					Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				}
				if (no_categories_ret_code == 1) {
					String message = jsonResponse.optString("message");
					String toastMessage = message.substring(2, message.length() - 2);
					Toast.makeText(getApplicationContext(), toastMessage, Toast.LENGTH_LONG).show();
					return;
				}
				if (ret_code == -1) {
//					Log.e("**** Get Identity Profiler DBError", jsonResponse.optString("db_error"));
					return;
				}

				Intent i = new Intent(WamiInfoExtended.this, Profiler.class);
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

		ImageView ivHome = (ImageView) findViewById(R.id.actionBarHome);
		ivHome.setOnClickListener(new ImageView.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(WamiInfoExtended.this, WamiListActivity.class);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				startActivity(i);
			}
		});
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.wami_info_extended_menu, menu);
		return true;
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

// Export to contacts
		if (id == R.id.action_add_to_contact_list) {
			Intent intent = new Intent(ContactsContract.Intents.Insert.ACTION);
			intent.setType(ContactsContract.RawContacts.CONTENT_TYPE);
			TextView mPhoneNumber = (TextView) findViewById(R.id.telephone);
			TextView mEmailAddress = (TextView) findViewById(R.id.email);
			TextView mContactName = (TextView) findViewById(R.id.profile_name);

			intent.putExtra(ContactsContract.Intents.Insert.EMAIL, mEmailAddress.getText());
			intent.putExtra(ContactsContract.Intents.Insert.EMAIL_TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);
			intent.putExtra(ContactsContract.Intents.Insert.PHONE, mPhoneNumber.getText());
			intent.putExtra(ContactsContract.Intents.Insert.PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MAIN);
			intent.putExtra(ContactsContract.Intents.Insert.NAME, mContactName.getText());
			intent.putExtra("finishActivityOnSaveCompleted", true);

			String targetName = (String) mContactName.getText();
			boolean bExists = false;
			ContentResolver cr = getContentResolver();
			Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
			if (cur.getCount() > 0) {
				while (cur.moveToNext()) {
					String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));

					if (name.equals(targetName)) {
						Toast.makeText(getApplicationContext(), "Contact: " + name + " already exists.", Toast.LENGTH_LONG).show();
						bExists = true;
						break;
					}
				}
			}
			cur.close();
			if (!bExists) {
				startActivity(intent);
			}
		}

// Navigate to action
		if (id == R.id.action_navigate_to) {
			ActionList actionList = new ActionList();
			actionList.actionList(that, identityProfileId, imageUrl, profileName, firstName, lastName, userIdentityProfileId, useDefault);
		}

// My Wami Network
		if (id == R.id.action_home) {
			Intent i = new Intent(WamiInfoExtended.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(WamiInfoExtended.this, Login.class);
			startActivity(i);
		}
		return super.onOptionsItemSelected(item);
	}

	private boolean assignData(String jsonResult) {
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int ret_code = jsonResponse.optInt("ret_code");
			int group_ret_code = jsonResponse.optInt("group_ret_code");
			if (ret_code == 1) {
				String message = jsonResponse.optString("message");
				Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				return false;
			}
			if (ret_code == -1) {
//				Log.e("**** Get Identity Profile data DBError", jsonResponse.optString("db_error"));
				return false;
			}

			JSONObject jsonChildNode = null;
			JSONArray jsonNode = jsonResponse.optJSONArray("identity_profile_data");
			//No Group data found
			if (group_ret_code == 2) {
				jsonChildNode = jsonNode.getJSONObject(0);
			}
			else {
				jsonChildNode = jsonNode.getJSONObject(1);
			}
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
			imageUrl = jsonChildNode.optString("image_url");
			rating = jsonChildNode.optString("rating");
			createDate = (jsonChildNode.optString("create_date")).substring(0, 10);
			String searchableStr = jsonChildNode.optString("searchable");
			if (searchableStr.equals("1")) {
				searchable = "Yes";
			}
			else {
				searchable = "No";
			}
			String activeIndStr = jsonChildNode.optString("active_ind");
			if (activeIndStr.equals("1")) {
				activeInd = "Active";
			}
			else {
				activeInd = "Inactive";
			}

			if (group_ret_code == 2) {
				return true;
			}

			JSONObject jsonGroups = jsonNode.getJSONObject(0);
			JSONArray jsonArray =  jsonGroups.getJSONArray("group_data");
			for (int i = 0; i < jsonArray.length(); i++) {
				jsonChildNode = jsonArray.getJSONObject(i);
				String group = jsonChildNode.optString("group");
				groups = groups + ", " + group;
			}
			groups = groups.substring(2);

			return true;
		}

		catch (JSONException e) {
			Toast.makeText(this, "Error" + e.toString(), Toast.LENGTH_LONG).show();
			e.printStackTrace();
			return false;
		}
	}

	private String getJsonData(String identityProfileId, String userIdentityProfileId) {
		jsonGetData = new JsonGetData();
		identityProfileId = String.valueOf(identityProfileId);
		userIdentityProfileId = String.valueOf(userIdentityProfileId);
		String fromProfileId = "NA";
		String[] postData = { identityProfileId, fromProfileId, userIdentityProfileId};
		jsonGetData.jsonGetData(this, GET_PROFILE_DATA, postData);

		return jsonGetData.getJsonResult();
	}
}
