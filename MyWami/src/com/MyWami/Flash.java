package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
import com.MyWami.dialogs.ActionList;
import com.MyWami.dialogs.NewFlash;
import com.MyWami.dialogs.TransmitWami;
import com.MyWami.model.FlashModel;
import com.MyWami.model.TransmitModel;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;


/**
 * Created by robertlanter on 1/29/14.
 */
public class Flash extends ListActivity {
	private String identityProfileId;
	private String imageUrl;
	private String profileName;
	private String firstName;
	private String lastName;
	private FlashModel[] flashModel;
	private String userIdentityProfileId;
	private boolean useDefault;
	private ArrayList alWamiTransmitModel = new ArrayList();
	private Context that;

	final private String GET_PROFILE_FLASH_DATA = Constants.IP + "get_profile_flash_data.php";


	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_wami_flash);
		actionBar.setDisplayShowTitleEnabled(false);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		that = this;

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

		View header = getLayoutInflater().inflate(R.layout.wami_header_flash, null);
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

		ImageView heading_icon = (ImageView) findViewById(R.id.wami_heading_icon_right);
		heading_icon.setVisibility(View.GONE);

		header.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				Intent i = new Intent(Flash.this, Profiler.class);
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
				Intent i = new Intent(Flash.this, WamiListActivity.class);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				startActivity(i);
			}
		});

		ImageView ivListDialog = (ImageView) findViewById(R.id.actionList);
		ivListDialog.setOnClickListener(new ImageView.OnClickListener() {
			@Override
			public void onClick(View v) {
				ActionList actionList = new ActionList();
				actionList.actionList(that, identityProfileId, imageUrl, profileName, firstName, lastName, userIdentityProfileId, useDefault);
			}
		});

		Button btnNewFlash = (Button) findViewById(R.id.new_flash_btn);
		btnNewFlash.setOnClickListener(new  Button.OnClickListener() {
			@Override
			public void onClick(View v) {
				NewFlash newFlashAnouncement = new NewFlash();
				newFlashAnouncement.newFlash(that, identityProfileId);
			}
		});

		Button btnRefresh = (Button) findViewById(R.id.refresh_btn);
		btnRefresh.setOnClickListener(new  Button.OnClickListener() {
			@Override
			public void onClick(View v) {
				refreshFlash();
			}
		});

		String[] postData = { identityProfileId };
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(this, GET_PROFILE_FLASH_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
		flashModel = assignData(jsonResult);
		if (flashModel == null) {

		}
		setListAdapter(new FlashAdapter(this, R.layout.flash, flashModel));
	}

	private FlashModel[] assignData(String jsonResult) {
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			JSONArray jsonMainNode = jsonResponse.optJSONArray("profile_flash_data");

			if (jsonMainNode == null) {
				flashModel = new FlashModel[1];
				flashModel[0] = new FlashModel();
				flashModel[0].setIdentityProfileId(Integer.parseInt(userIdentityProfileId));
				flashModel[0].setFlash("");
				flashModel[0].setCreateDate("");
				flashModel[0].setMedia_url("");
			}

			else {
				flashModel = new FlashModel[jsonMainNode.length()];
				for (int i = 0; i < jsonMainNode.length(); i++) {
					JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
					int identityProfileId = jsonChildNode.optInt("identity_profile_id");
					String flash = jsonChildNode.optString("flash");
					String createDate = jsonChildNode.optString("create_date");
					String flashImageUrl = jsonChildNode.optString("media_url");

					flashModel[i] = new FlashModel();
					flashModel[i].setIdentityProfileId(identityProfileId);
					flashModel[i].setFlash(flash);
					flashModel[i].setCreateDate(createDate);
					flashModel[i].setMedia_url(flashImageUrl);
				}
			}
		}
		catch (JSONException e) {
			e.printStackTrace();
			Toast.makeText(getApplicationContext(), "Error" + e.toString(), Toast.LENGTH_LONG).show();
		}

		return flashModel;
	}

	@Override
	protected void onSaveInstanceState(Bundle savedInstanceState) {
		savedInstanceState.putString("profile_name", profileName);
		savedInstanceState.putString("image_url", imageUrl);
		savedInstanceState.putString("identity_profile_id", identityProfileId);
		savedInstanceState.putString("first_name", firstName);
		savedInstanceState.putString("last_name", lastName);
		savedInstanceState.putString("user_identity_profile_id", userIdentityProfileId);
		savedInstanceState.putBoolean("use_default", useDefault);
		super.onSaveInstanceState(savedInstanceState);
	}

	@Override
	public void onRestoreInstanceState(Bundle savedInstanceState) {
		super.onRestoreInstanceState(savedInstanceState);
		imageUrl = savedInstanceState.getString(imageUrl);
		profileName = savedInstanceState.getString(profileName);
		identityProfileId = savedInstanceState.getString(identityProfileId);
		firstName = savedInstanceState.getString(firstName);
		lastName = savedInstanceState.getString(lastName);
		userIdentityProfileId = savedInstanceState.getString(userIdentityProfileId);
		useDefault = savedInstanceState.getBoolean(String.valueOf(useDefault));
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.flash_menu, menu);
		return super.onCreateOptionsMenu(menu);
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();
		switch (id) {
			case android.R.id.home:
				super.onBackPressed();
				return true;
		}

// New Flash
		if (id == R.id.action_new_flash) {
			NewFlash newFlash = new NewFlash();
			newFlash.newFlash(that, identityProfileId);
		}

// Transmit wami
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
			Intent i = new Intent(Flash.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(Flash.this, Login.class);
			startActivity(i);
		}

		return super.onOptionsItemSelected(item);
	}

	public void refreshFlash () {
		String[] postData = { identityProfileId };
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(that, GET_PROFILE_FLASH_DATA, postData);
		String jsonResult = jsonGetData.getJsonResult();
		flashModel = assignData(jsonResult);
		setListAdapter(new FlashAdapter(that, R.layout.flash, flashModel));
	}
}
