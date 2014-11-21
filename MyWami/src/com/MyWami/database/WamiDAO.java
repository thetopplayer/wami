package com.MyWami.database;

import android.content.Context;
import android.os.AsyncTask;
import com.MyWami.model.WamiListModel;
import com.MyWami.model.UserModel;
import com.MyWami.model.ProfilerModel;
import com.MyWami.model.TransmitModel;
import com.MyWami.util.Constants;

import java.util.ArrayList;

/**
 * Created by robertlanter on 3/1/14.
 */
public class WamiDAO {
	private String jsonResult;

	final private String INSERT_TRANSMITTED_PROFILE_DATA = Constants.IP + "insert_transmitted_profile_data.php";
	final private String GET_USER_WAMI_LIST = Constants.IP + "get_user_wami_list.php";
	final private String GET_USER_PROFILE_DATA = Constants.IP + "get_user_profile_data.php";

	Context that;
	WamiListModel[] listModel;
	ArrayList alWamiTransmitModel = new ArrayList();
	TransmitModel transmitModel;
	UserModel userModel;
	ProfilerModel profilerModel;

	public class JsonGetUserProfileData extends AsyncTask<String, Void, String> {

		@Override
		protected String doInBackground(String... params) {
			return null;
		}

		@Override
		protected void onPostExecute(String result){

		}
	}

}
