package com.MyWami.util;

import android.content.Context;
import com.MyWami.model.UserModel;
import com.MyWami.sqlite.SQLiteHelper;

/**
 * Created by robertlanter on 5/21/14.
 */
public class GetUserId {

	static public int getUserId (Context context) {
		UserModel userModel;
		SQLiteHelper sqLiteHelper = new SQLiteHelper(context);
		userModel = sqLiteHelper.getUserInfo();

		return userModel.getUserId();
	}

}
