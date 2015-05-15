package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;
import com.MyWami.dialogs.SearchForProfiles;
import com.MyWami.model.SearchListModel;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by robertlanter on 7/18/14.
 */
public class SearchResults extends ListActivity {
	final private String GET_SEARCH_PROFILE_DATA = Constants.IP + "get_search_profile_data.php";
	final private String GET_PROFILE_NAME = Constants.IP + "get_profile_name.php";
	final private String TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE = Constants.EMAIL_IP + "transmit_request_to_email_address_mobile.php";
	private JsonGetData jsonGetData;
	private SearchListModel[] listModel;
	private String selectedItem;
	private String searchStr;
	private String userIdentityProfileId;
	private int searchIndex;
	private boolean useDefault;

	private Context that;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_search_results);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(false);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		if (savedInstanceState == null) {
			Bundle extras = getIntent().getExtras();
			userIdentityProfileId = extras.getString("user_identity_profile_id");
			useDefault = extras.getBoolean("use_default");
		}

		Bundle extras = getIntent().getExtras();
		selectedItem = extras.getString("selected_item");
		searchStr = extras.getString("search_str");
		searchIndex = extras.getInt("searchIndex");

		View header = getLayoutInflater().inflate(R.layout.search_results_header, null);
		ListView listView = getListView();
		listView.addHeaderView(header);

		Button newSearch = (Button) this.findViewById(R.id.newSearch);
		newSearch.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				SearchForProfiles searchForProfiles = new SearchForProfiles();
				searchForProfiles.searchForProfiles(that, userIdentityProfileId, useDefault);
			}
		});

		Button request = (Button) this.findViewById(R.id.requestProfiles);
		request.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				boolean isSelected = false;
				ArrayList<String> emailTo = new ArrayList<String>();
				int numItemsInList = listModel.length;
				for (int i = 0; i < numItemsInList; i++) {
					 if (listModel[i].isSelected()) {
						emailTo.add(listModel[i].getEmail());
						isSelected = true;
					 }
				}
				if (!isSelected) {
					Toast.makeText(getApplicationContext(), "No Profiles were chosen to be requested.", Toast.LENGTH_LONG).show();
					return;
				}
				jsonGetData = new JsonGetData();
				String[] postData = {userIdentityProfileId};
				jsonGetData.jsonGetData(getApplicationContext(), GET_PROFILE_NAME, postData);
				String jsonResult = jsonGetData.getJsonResult();
				String fromProfileName = null;
				String fromEmail = null;
				try {
					JSONObject jsonResponse = new JSONObject(jsonResult);
					fromProfileName = jsonResponse.getString("profile_name");
					fromEmail = jsonResponse.getString("email");
				}
				catch (JSONException e) {
					Toast.makeText(getApplicationContext(), "Error" + e.toString(), Toast.LENGTH_LONG).show();
//					Log.e("****Request Profile Error", e.toString(), e);
					e.printStackTrace();
				}

				String emails = null;
				for (int i = 0; i < emailTo.size(); i++) {
					emails = emails + "," + emailTo.get(i);
				}

				assert emails != null;
				emails = emails.substring(5);
				postData = new String[]{fromEmail, emails, fromEmail, fromProfileName};

				JsonGetData jsonGetData = new JsonGetData();
				jsonGetData.jsonGetData(getApplicationContext(), TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE, postData);
				jsonResult = jsonGetData.getJsonResult();
				try {
					JSONObject jsonResponse = new JSONObject(jsonResult);
					boolean ret_code = jsonResponse.optBoolean("ret_code");

					String message = jsonResponse.optString("message");
					Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				}
				catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});

		Button home = (Button) this.findViewById(R.id.home);
		home.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(SearchResults.this, WamiListActivity.class);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				startActivity(i);
			}
		});

//		ImageView ivHome = (ImageView) findViewById(R.id.actionBarHome);
//		ivHome.setOnClickListener(new ImageView.OnClickListener() {
//			@Override
//			public void onClick(View v) {
//				Intent i = new Intent(SearchResults.this, WamiListActivity.class);
//				i.putExtra("user_identity_profile_id", userIdentityProfileId);
//				i.putExtra("use_default", useDefault);
//				startActivity(i);
//			}
//		});

		jsonGetData = new JsonGetData();
		String[] postData = {selectedItem, searchStr, String.valueOf(searchIndex), userIdentityProfileId};
		jsonGetData.jsonGetData(this, GET_SEARCH_PROFILE_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
		ListData(jsonResult);
	}

	private void ListData(String jsonResult) {
		ArrayList<ListRow> alListRow = new ArrayList<ListRow>();

		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			JSONArray jsonMainNode;
			jsonMainNode = jsonResponse.optJSONArray("profile_list");

			listModel = new SearchListModel[jsonMainNode.length()];
			for (int i = 0; i < jsonMainNode.length(); i++) {
				JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
				String firstName = jsonChildNode.optString("first_name");
				String lastName = jsonChildNode.optString("last_name");
				String profileName = jsonChildNode.optString("profile_name");
				String tags = jsonChildNode.optString("tags");
				String imageURL = jsonChildNode.optString("image_url");
				String description = jsonChildNode.optString("description");
				String email = jsonChildNode.optString("email");
//				String rating = jsonChildNode.optString("rating");
				int identityProfileId = jsonChildNode.optInt("identity_profile_id");
				String contactName = firstName + " " + lastName;
				ListRow listRow = new ListRow(imageURL, contactName);

				alListRow.add(listRow);
				listModel[i] = new SearchListModel();
				listModel[i].setFirstName(firstName);
				listModel[i].setLastName(lastName);
				listModel[i].setProfileName(profileName);
				listModel[i].setTags(tags);
				listModel[i].setDescriptiom(description);
				listModel[i].setEmail(email);
//				listModel[i].setRating(rating);
				listModel[i].setImageUrl(imageURL);
				listModel[i].setIdentityProfileId(identityProfileId);
			}
		}
		catch (JSONException e) {
			Toast.makeText(getApplicationContext(), "Error" + e.toString(), Toast.LENGTH_LONG).show();
//			Log.e("****Request Profile Error", e.toString(), e);
			e.printStackTrace();
		}

		setListAdapter(new SearchResultsListAdapter(that, R.layout.search_results, alListRow, listModel));
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.search_results_menu, menu);
		return super.onCreateOptionsMenu(menu);
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();

// My Wami Network
		if (id == R.id.action_home) {
			Intent i = new Intent(SearchResults.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(SearchResults.this, Login.class);
			startActivity(i);
		}

		return super.onOptionsItemSelected(item);
	}
}

