package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.MyWami.dialogs.CreateAccount;
import com.MyWami.model.UserModel;
import com.MyWami.sqlite.SQLiteHelper;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

public class Login extends Activity {
	final private String GET_USER_DATA = Constants.IP + "get_user_data.php";
	final private String GET_DEFAULT_IDENTITY_PROFILE_ID = Constants.IP + "get_default_identity_profile_id.php";
	private UserModel userModel;
	private Context that;
	private int userId;

	@TargetApi(Build.VERSION_CODES.JELLY_BEAN)
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_heading);
		actionBar.setDisplayShowTitleEnabled(true);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		SQLiteHelper sqLiteHelper = new SQLiteHelper(this);
		userModel = sqLiteHelper.getUserInfo();

		if ((userModel == null) || (!userModel.getUserName().equals("") && !userModel.getPassWord().equals(""))) {
			EditText etUserName = (EditText) findViewById(R.id.login_username);
			EditText etPassword = (EditText) findViewById(R.id.login_password);
			if (userModel == null) {
				userModel = new UserModel();
			}
			etUserName.setText(userModel.getUserName());
			etPassword.setText(userModel.getPassWord());
		}

		final Button btnLogin = (Button) findViewById(R.id.btnLogin);
		btnLogin.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				String userName;
				String password;
				EditText etUserName = (EditText) findViewById(R.id.login_username);
				EditText etPassword = (EditText) findViewById(R.id.login_password);
				userName = etUserName.getText().toString().trim();
				password = etPassword.getText().toString().trim();

				if (userName.equals("") && password.equals("")) {
					Toast.makeText(that.getApplicationContext(), "Please enter password and username", Toast.LENGTH_LONG).show();
				}
				else {
					JsonGetData jsonGetData = new JsonGetData();
					String[] postData = {userName, password};
					jsonGetData.jsonGetData(that, GET_USER_DATA, postData);
					String jsonResult = jsonGetData.getJsonResult();
					boolean result = assignData(jsonResult);
					if (result) {
						String userIdStr = String.valueOf(userId);
						postData = new String[] { userIdStr };
						jsonGetData.jsonGetData(that, GET_DEFAULT_IDENTITY_PROFILE_ID, postData);
						jsonResult = jsonGetData.getJsonResult();
						JSONObject jsonResponse = null;
						String identityProfileId = null;
						try {
							jsonResponse = new JSONObject(jsonResult);
							JSONArray jsonMainNode = jsonResponse.optJSONArray("default_identity_profile_id");
							JSONObject jsonChildNode = jsonMainNode.getJSONObject(0);
							identityProfileId = String.valueOf(jsonChildNode.optInt("identity_profile_id"));
						}
							catch (JSONException e) {
							e.printStackTrace();
						}
						Intent i = new Intent(Login.this, WamiListActivity.class);
						i.putExtra("user_identity_profile_id", identityProfileId);
						i.putExtra("use_default", true);
						startActivity(i);
						return;
					}
					Toast.makeText(that.getApplicationContext(), "Invalid password or username, please re-enter", Toast.LENGTH_LONG).show();
				}
			}
		});

		final Button btnCreateAccount = (Button) findViewById(R.id.btnCreateAccount);
		btnCreateAccount.setOnClickListener(new Button.OnClickListener() {
			@Override
			public void onClick(View v) {
				CreateAccount createAccount = new CreateAccount();
				createAccount.createAccount(that);
			}
		});
	}

	private boolean assignData(String jsonResult) {
		try {
			JSONObject jsonResponse = new JSONObject(jsonResult);
			int ret_code = jsonResponse.optInt("ret_code");
			if (ret_code == 0) {
				String message = jsonResponse.optString("message");
				Toast.makeText(getApplicationContext(), message, Toast.LENGTH_LONG).show();
				return false;
			}
			if (ret_code == -1) {
//				Log.e("**** Get User data DBError", jsonResponse.optString("db_error"));
				return false;
			}

			JSONArray jsonNode = jsonResponse.optJSONArray("user_info");
			JSONObject jsonChildNode = jsonNode.getJSONObject(0);

			userModel = new UserModel();
			userId = jsonChildNode.optInt("user_id");
			String userName = jsonChildNode.optString("username");
			String passWord = jsonChildNode.optString("password");
			userModel.setUserId(userId);
			userModel.setUserName(userName);
			userModel.setPassWord(passWord);

			SQLiteHelper sqLiteHelper = new SQLiteHelper(this);
			sqLiteHelper.saveUserInfo(userModel);
			return true;
		}

		catch (JSONException e) {
			Toast.makeText(this, "Error" + e.toString(), Toast.LENGTH_LONG).show();
			e.printStackTrace();
			return false;
		}
	}
}
