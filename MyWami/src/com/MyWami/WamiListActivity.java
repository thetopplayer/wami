package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import com.MyWami.dialogs.FilterCollection;
import com.MyWami.dialogs.SearchForProfiles;
import com.MyWami.dialogs.SelectProfile;
import com.MyWami.dialogs.TransmitWami;
import com.MyWami.model.TransmitModel;
import com.MyWami.model.WamiListModel;
import com.MyWami.util.Constants;
import com.MyWami.util.GetUserId;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class WamiListActivity extends ListActivity {
	final private String GET_DEFAULT_PROFILE_COLLECTION = Constants.IP + "get_default_profile_collection.php";
	final private String GET_PROFILE_COLLECTION = Constants.IP + "get_profile_collection.php";
	final private String GET_PROFILE_NAME = Constants.IP + "get_profile_name.php";
	final private String GET_DEFAULT_IDENTITY_PROFILE_ID = Constants.IP + "get_default_identity_profile_id.php";
	final private String GET_PROFILE_COLLECTION_FILTERED = Constants.IP + "get_profile_collection_filtered.php";

	private Context that;
	private WamiListModel[] listModel;
	private ArrayList alWamiTransmitModel = new ArrayList();
	private String userIdentityProfileId;
	private boolean useDefault;
	private String profileName;
	private String groupName;
	private int profileGroupId;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_wami_list);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		Bundle extras = getIntent().getExtras();
		useDefault = extras.getBoolean("use_default");
		userIdentityProfileId = extras.getString("user_identity_profile_id");
		groupName = extras.getString("group_name_selected");
		profileGroupId = extras.getInt("profile_group_id");

		String jsonResult = getJsonData();
		ListData(jsonResult);

		profileName = getProfileName();
		TextView tvProfileName = (TextView) findViewById(R.id.collectionProfileName);
		tvProfileName.setText(profileName);
	}

	public void onResume() {
		super.onResume();
		Bundle extras = getIntent().getExtras();
		useDefault = extras.getBoolean("use_default");
		userIdentityProfileId = extras.getString("user_identity_profile_id");
		groupName = extras.getString("group_name_selected");
		profileGroupId = extras.getInt("profile_group_id");

		String jsonResult = getJsonData();
		ListData(jsonResult);

		profileName = getProfileName();
		TextView tvProfileName = (TextView) findViewById(R.id.collectionProfileName);
		tvProfileName.setText(profileName);
	}

	@Override
	protected void onListItemClick(ListView l, View v, int position, long id) {
		WamiListAdapter wamiListAdapter = (WamiListAdapter) getListAdapter();
		Intent i = new Intent(WamiListActivity.this, WamiInfoExtended.class);
		i.putExtra("identity_profile_id", String.valueOf(wamiListAdapter.wamiListModel[position].getIdentityProfileId()));
		i.putExtra("user_identity_profile_id", userIdentityProfileId);
		i.putExtra("use_default", useDefault);
		startActivity(i);
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();

		if (id == android.R.id.home) {
			super.onBackPressed();
			return true;
		}

//Transmit wami
		if (id == R.id.action_transmit_wami) {
			boolean isSelected = false;
			alWamiTransmitModel.clear();
			for (WamiListModel aListModel : listModel)
				if (aListModel.isSelected()) {
					isSelected = true;
					TransmitModel transmitModel = new TransmitModel();
					transmitModel.setWamiToTransmitId(aListModel.getIdentityProfileId());
					transmitModel.setFromIdentityProfileId(Integer.parseInt(userIdentityProfileId));
					alWamiTransmitModel.add(transmitModel);
				}
			TransmitWami transmitWami = new TransmitWami();
			transmitWami.transmitWami(alWamiTransmitModel, that, isSelected);
		}

// Select a Profile collection
		if (id == R.id.action_select_profile) {
			SelectProfile selectProfile = new SelectProfile();
			selectProfile.selectProfile(that, userIdentityProfileId);
		}

// Filter collection by group
		if (id == R.id.action_filter_collection) {
			FilterCollection filterCollection = new FilterCollection();
			filterCollection.filterCollection(that, userIdentityProfileId);
		}

// Search for Profiles
		if (id == R.id.action_search_for_profiles) {
			SearchForProfiles searchForProfiles = new SearchForProfiles();
			searchForProfiles.searchForProfiles(that, userIdentityProfileId, useDefault);
		}

// Refresh list
		if (id == R.id.action_refresh_wami_list) {
			Toast.makeText(that, "Refreshing your Profiler collection...", Toast.LENGTH_LONG).show();
			String jsonResult = getJsonData();
			ListData(jsonResult);
			return true;
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(WamiListActivity.this, Login.class);
			startActivity(i);
		}


		return super.onOptionsItemSelected(item);
	}

	private void ListData(String jsonResult) {
		ArrayList<ListRow> alListRow = new ArrayList<ListRow>();

		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			JSONArray jsonMainNode;
			jsonMainNode = jsonResponse.optJSONArray("profile_collection");

			listModel = new WamiListModel[jsonMainNode.length()];
			for (int i = 0; i < jsonMainNode.length(); i++) {
				JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
				String firstName = jsonChildNode.optString("first_name");
				String lastName = jsonChildNode.optString("last_name");
				String profileName = jsonChildNode.optString("profile_name");
				String tags = jsonChildNode.optString("tags");
				String imageURL = jsonChildNode.optString("image_url");
				int identityProfileId = jsonChildNode.optInt("identity_profile_id");
				int assignToIdentityProfileId = jsonChildNode.optInt("assign_to_identity_profile_id");
				String email = jsonChildNode.optString("email");
				String telephone = jsonChildNode.optString("telephone");

				String listName = firstName + " " + lastName;
				ListRow listRow = new ListRow(imageURL, listName);
				alListRow.add(listRow);
				listModel[i] = new WamiListModel();
				listModel[i].setFirstName(firstName);
				listModel[i].setLastName(lastName);
				listModel[i].setProfileName(profileName);
				listModel[i].setTags(tags);
				listModel[i].setImageUrl(imageURL);
				listModel[i].setIdentityProfileId(identityProfileId);
				listModel[i].setAssignToIdentityProfileId(assignToIdentityProfileId);
				listModel[i].setEmail(email);
				listModel[i].setTelephone(telephone);
			}
		}
		catch (JSONException e) {
			Toast.makeText(getApplicationContext(), "Error" + e.toString(), Toast.LENGTH_LONG).show();
			e.printStackTrace();
		}

		setListAdapter(new WamiListAdapter(that, R.layout.wami_list, alListRow, listModel));
	}

	private String getProfileName() {
		String identityProfileId = null;
		JSONObject jsonResponse = null;
		JsonGetData jsonGetData = new JsonGetData();
		if (useDefault) {
			String userId = String.valueOf(GetUserId.getUserId(that));
			String[] postData = { userId };
			jsonGetData.jsonGetData(this, GET_DEFAULT_IDENTITY_PROFILE_ID, postData);

			try {
				jsonResponse = new JSONObject(jsonGetData.getJsonResult());
				JSONArray jsonMainNode = jsonResponse.optJSONArray("default_identity_profile_id");
				JSONObject jsonChildNode = jsonMainNode.getJSONObject(0);
				identityProfileId = String.valueOf(jsonChildNode.optInt("identity_profile_id"));
				postData = new String[]{identityProfileId};
				jsonGetData.jsonGetData(this, GET_PROFILE_NAME, postData);
				jsonResponse = new JSONObject(jsonGetData.getJsonResult());
				profileName = jsonResponse.optString("profile_name");
			}
				catch (JSONException e) {
				e.printStackTrace();
			}
		}
		else {
			String[] postData = {userIdentityProfileId};
			jsonGetData.jsonGetData(this, GET_PROFILE_NAME, postData);
			try {
				jsonResponse = new JSONObject(jsonGetData.getJsonResult());
			}
				catch (JSONException e) {
				e.printStackTrace();
			}
			profileName = jsonResponse.optString("profile_name");
		}
		return profileName;
	}

	private String getJsonData() {
		JsonGetData jsonGetData = new JsonGetData();
		if (useDefault) {
			String userId = String.valueOf(GetUserId.getUserId(that));
			String[] postData = { userId };
			jsonGetData.jsonGetData(this, GET_DEFAULT_PROFILE_COLLECTION, postData);
		}
		else {
			if ( (profileGroupId == 999999) || (profileGroupId == 0 && groupName == null) ) {
				String[] postData = {userIdentityProfileId};
				jsonGetData.jsonGetData(this, GET_PROFILE_COLLECTION, postData);
			}
			else {
				String[] postData = {userIdentityProfileId, String.valueOf(profileGroupId)};
				jsonGetData.jsonGetData(this, GET_PROFILE_COLLECTION_FILTERED, postData);
			}
		}

		return jsonGetData.getJsonResult();
	}
}
