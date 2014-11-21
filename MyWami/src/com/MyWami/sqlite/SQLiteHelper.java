package com.MyWami.sqlite;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.database.sqlite.SQLiteStatement;
import com.MyWami.model.UserModel;

import java.util.ArrayList;

/**
 * Created by robertlanter on 2/12/14.
 */
public class SQLiteHelper extends SQLiteOpenHelper {

	private static final int DATABASE_VERSION = 23;
	private static String DB_NAME = "wamilocal.db";
	private static String DB_PATH = "/Users/robertlanter/projects/";
	private SQLiteDatabase myDataBase;
	private final Context context;

	public SQLiteHelper(Context context) {
		super(context, DB_NAME, null, DATABASE_VERSION);
		this.context = context;
	}

	@Override
	public void onCreate(SQLiteDatabase db) {
		// SQL statements to create tables
		String CREATE_USER_TABLE = "CREATE TABLE user " +
					"( " +
					"user_id INTEGER NOT NULL, " +
					"username TEXT NOT NULL, " +
					"password TEXT NOT NULL " +
					")";
		db.execSQL(CREATE_USER_TABLE);

//		String CREATE_USER_PROFILE_TABLE = "CREATE TABLE user_profile " +
//					"( " +
//					"user_profile_id INTEGER PRIMARY KEY," +
//					"user_id INTEGER, " +
//					"category TEXT, " +
//					"media_type TEXT, " +
//					"location TEXT, " +
//					"create_date TEXT NOT NULL, " +
//					"modified_date TEXT NOT NULL, " +
//					"FOREIGN KEY ( user_id ) REFERENCES user ( user_id ) DEFERRABLE INITIALLY DEFERRED " +
//					")";
//		db.execSQL(CREATE_USER_PROFILE_TABLE);
//
//		String CREATE_USER_WAMI_LIST_TABLE = "CREATE TABLE user_wami_list "  +
//					"( " +
//					"user_wami_list_id INTEGER PRIMARY KEY, " +
//					"user_id INTEGER NOT NULL,  " +
//					"user_wami_id INTEGER NOT NULL,  " +
//					"from_user_id INTEGER NOT NULL,   " +
//					"transmission_receive_date TEXT NOT NULL,  " +
//					"transmission_accept_date TEXT DEFAULT NULL, " +
//					"transmission_status TEXT NOT NULL,   " +
//					"create_date TEXT NOT NULL,      " +
//					"modified_date TEXT NOT NULL,   " +
//					"FOREIGN KEY ( user_id ) REFERENCES user ( user_id ) DEFERRABLE INITIALLY DEFERRED ,            " +
//					"FOREIGN KEY ( user_wami_id ) REFERENCES user ( user_id ) DEFERRABLE INITIALLY DEFERRED    " +
//					")";
//		db.execSQL(CREATE_USER_WAMI_LIST_TABLE);


	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// Drop older table if existed
		db.execSQL("DROP TABLE IF EXISTS user");
//		db.execSQL("DROP TABLE IF EXISTS user_profile");
//		db.execSQL("DROP TABLE IF EXISTS USER_WAMI_LIST");

		// create fresh books table
		this.onCreate(db);
	}

	// Getting All Categories
//	public ArrayList<ArrayList> getUserProfileData(int userId) {
//		ArrayList<ArrayList> alUserProfileData = new ArrayList<ArrayList>();
//		ArrayList<String> alCategories = new ArrayList<String>();
//		ArrayList<String> alLocations = new ArrayList<String>();
//
//		String selectQuery = "SELECT category, location FROM user_profile WHERE user_id = " + userId;
//
//		SQLiteDatabase db = this.getWritableDatabase();
//		Cursor cursor = db.rawQuery(selectQuery, null);
//
//		if (cursor.moveToFirst()) {
//			do {
//				String category = cursor.getString(0);
//				String location = cursor.getString(1);
//				alCategories.add(category);
//				alLocations.add(location);
//			} while (cursor.moveToNext());
//		}
//
//		cursor.close();
//
//		alUserProfileData.add(alCategories);
//		alUserProfileData.add(alLocations);
//		return alUserProfileData;
//	}

	public boolean setUserProfileData (int userId, ArrayList<ArrayList> alProfileData) {

		return true;
	}

	// Save user info
	public void saveUserInfo(UserModel um) {
		int userId = um.getUserId();
		String username = um.getUserName();
		String password = um.getPassWord();

		String deleteSQL = "DELETE from user";

		SQLiteDatabase db = this.getWritableDatabase();
		db.execSQL(deleteSQL);

		String sql = "INSERT INTO user (user_id, username, password) VALUES (?,?,?)";
		SQLiteStatement mInsertAttributeStatement = db.compileStatement(sql);
		mInsertAttributeStatement.bindLong(1, userId);
		mInsertAttributeStatement.bindString(2, username);
		mInsertAttributeStatement.bindString(3, password);
		mInsertAttributeStatement.execute();

		mInsertAttributeStatement.close();
	}

	// Get user info
	public UserModel getUserInfo() {
		UserModel userModel = new UserModel();

		String selectQuery = "SELECT user_id, username, password FROM user";

		SQLiteDatabase db = this.getWritableDatabase();
		Cursor cursor = db.rawQuery(selectQuery, null);
		if (cursor.moveToFirst()) {
			do {
				int userId = cursor.getInt(0);
				String username = cursor.getString(1);
				String password = cursor.getString(2);
				userModel.setUserId(userId);
				userModel.setUserName(username);
				userModel.setPassWord(password);
			} while (cursor.moveToNext());
		}
		else {
			userModel = null;
		}

		cursor.close();
		return userModel;
	}
}


