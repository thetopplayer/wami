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
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// Drop older table if existed
		db.execSQL("DROP TABLE IF EXISTS user");
		this.onCreate(db);
	}

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
		db.close();
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
		db.close();
		return userModel;
	}
}


