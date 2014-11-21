package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ListView;
import android.widget.Toast;
import com.MyWami.R;
import com.MyWami.SelectProfileAdapter;
import com.MyWami.WamiListActivity;
import com.MyWami.model.ProfileModel;
import com.MyWami.util.Constants;
import com.MyWami.util.GetUserId;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


/**
 * Created by robertlanter on 5/18/14.
 */
public class SelectProfile {
	private ProfileModel[] profileModel;
	private Context context;
	final private String GET_PROFILE_LIST = Constants.IP + "get_profile_list.php";
	String userIdentityProfileId;

	public SelectProfile() {

	}

	public void selectProfile(final Context context, String userIdentityProfileId) {
		this.context = context;
		this.userIdentityProfileId = userIdentityProfileId;

		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_select_profile_list);

		String userId = String.valueOf(GetUserId.getUserId(context));
		String[] postData = { userId };
		JsonGetData jsonGetData = new JsonGetData();
		jsonGetData.jsonGetData(context, GET_PROFILE_LIST, postData);
		String jsonResult = jsonGetData.getJsonResult();
		profileModel = assignData(jsonResult);
		setSelected(userIdentityProfileId);

		ListView listView = (ListView) dialog.findViewById(R.id.profile_collection_list);
		SelectProfileAdapter spa = new SelectProfileAdapter(context, R.layout.dialog_select_profile_list, profileModel);
		listView.setAdapter(spa);

		Button cancelSelectCollection = (Button) dialog.findViewById(R.id.cancelSelectCollection);
		cancelSelectCollection.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		Button selectCollection = (Button) dialog.findViewById(R.id.selectCollection);
		selectCollection.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				boolean isSelected = false;
				for (ProfileModel aProfileModel : profileModel)
					if (aProfileModel.isSelected()) {
						isSelected = true;
						String identityProfileId = String.valueOf(aProfileModel.getIdentityProfileId());
						Intent i = new Intent(context, WamiListActivity.class);
						i.putExtra("user_identity_profile_id", identityProfileId);
						i.putExtra("use_default", false);
						context.startActivity(i);
						dialog.dismiss();
					}
				if (!isSelected) {
					Toast.makeText(context, "Please select a collection, or continue using default collection and hit the Cancel button.", Toast.LENGTH_LONG).show();
				}
			}
		});

		dialog.show();
	}

	private ProfileModel[] assignData(String jsonResult) {
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			JSONArray jsonMainNode = jsonResponse.optJSONArray("profile_list_data");

			profileModel = new ProfileModel[jsonMainNode.length()];
			for (int i = 0; i < jsonMainNode.length(); i++) {
				JSONObject jsonChildNode = jsonMainNode.getJSONObject(i);
				int identityProfileId = jsonChildNode.optInt("identity_profile_id");
				String profileName = jsonChildNode.optString("profile_name");
				int defaultProfileInd = jsonChildNode.optInt("default_profile_ind");

				profileModel[i] = new ProfileModel();
				profileModel[i].setIdentityProfileId(identityProfileId);
				profileModel[i].setDefaultProfileInd(defaultProfileInd);
				profileModel[i].setProfileName(profileName);
			}
		}
		catch (JSONException e) {
			e.printStackTrace();
			Toast.makeText(context, "Error" + e.toString(), Toast.LENGTH_LONG).show();
		}

		return profileModel;
	}

	private void setSelected(String userIdentityProfileId) {
		for (int i = 0; i < profileModel.length; i++) {
			if (profileModel[i].getIdentityProfileId() == Integer.parseInt(userIdentityProfileId)) {
				profileModel[i].setSelected(true);
				return;
			}
		}

	}
}
