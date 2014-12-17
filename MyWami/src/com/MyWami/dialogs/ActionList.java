package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.Toast;
import com.MyWami.*;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Created by robertlanter on 8/6/14.
 */
public class ActionList {
	private Context context;
	private String identityProfileId;
	private String imageUrl;
	private String profileName;
	private String firstName;
	private String lastName;
	private String userIdentityProfileId;
	private boolean useDefault;

	public ActionList() {
	}

	public void actionList(final Context context, final String identityProfileId, final String imageUrl, final String profileName,
	                       final String firstName, final String lastName, final String userIdentityProfileId, final boolean useDefault) {

		final String GET_IDENTITY_PROFILER_DATA = Constants.IP + "get_identity_profiler_data.php";
		this.context = context;
		this.identityProfileId = identityProfileId;
		this.imageUrl = imageUrl;
		this.profileName = profileName;
		this.firstName = firstName;
		this.lastName = lastName;
		this.userIdentityProfileId = userIdentityProfileId;
		this.useDefault = useDefault;


		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_action_list);

		Button openProfileInfo = (Button) dialog.findViewById(R.id.open_profile_info);
		openProfileInfo.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(WamiInfoExtended.class);
				dialog.dismiss();
			}
		});

		Button openProfiler = (Button) dialog.findViewById(R.id.open_profiler);
		openProfiler.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {

				String[] postData = { identityProfileId };
				JsonGetData jsonGetData = new JsonGetData();
				jsonGetData.jsonGetData(context, GET_IDENTITY_PROFILER_DATA, postData);
				String jsonResult = jsonGetData.getJsonResult();
				JSONObject jsonResponse = null;
				try {
					jsonResponse = new JSONObject(jsonResult);
				}
				catch (JSONException e) {
					e.printStackTrace();
//					Log.e("**** Profiler: json error: ", e.toString(), e);
				}
				assert jsonResponse != null;
				int ret_code = jsonResponse.optInt("ret_code");
				if (ret_code == 1) {
					String message = jsonResponse.optString("message");
					Toast.makeText(context, message, Toast.LENGTH_LONG).show();
					return;
				}
				if (ret_code == -1) {
//					Log.e("**** Get Identity Profiler DBError", jsonResponse.optString("db_error"));
					return;
				}

				startActivity(Profiler.class);
				dialog.dismiss();
			}
		});

		Button openFlash = (Button) dialog.findViewById(R.id.open_flash);
		openFlash.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(Flash.class);
				dialog.dismiss();
			}
		});

		Button openProfileCollection = (Button) dialog.findViewById(R.id.open_profile_collection);
		openProfileCollection.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				startActivity(WamiListActivity.class);
				dialog.dismiss();
			}
		});

		Button closeActionList = (Button) dialog.findViewById(R.id.close_Action_list);
		closeActionList.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		dialog.show();
	}

	private void startActivity(Class<?> activityClass)  {
		Intent i = new Intent(context, activityClass);
		i.putExtra("identity_profile_id", identityProfileId);
		i.putExtra("image_url", imageUrl);
		i.putExtra("profile_name", profileName);
		i.putExtra("first_name", firstName);
		i.putExtra("last_name", lastName);
		i.putExtra("user_identity_profile_id", userIdentityProfileId);
		i.putExtra("use_default", useDefault);
		context.startActivity(i);
	}
}
