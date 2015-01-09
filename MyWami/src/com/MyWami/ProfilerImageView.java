package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;
import com.MyWami.dialogs.ActionList;
import com.MyWami.util.Constants;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.concurrent.ExecutionException;

/**
 * Created by robertlanter on 3/4/14.
 */
public class ProfilerImageView extends ListActivity {
	private TextView textView;
	private WebView webView;
	private String[] fileName;
	private String[] fileLocation;
	private String[] imageDescription;
	private String[] imageName;

	private String identityProfileId;
	private String imageUrl;
	private String profileName;
	private String firstName;
	private String lastName;
	private String userIdentityProfileId;
	private boolean useDefault;
	private Context that;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_profiler_image);
		actionBar.setDisplayShowTitleEnabled(true);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

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

		Bundle extras = getIntent().getExtras();
		imageName = extras.getStringArray("image_name");
		fileName = extras.getStringArray("file_name");
		fileLocation = extras.getStringArray("file_location");
		imageDescription = extras.getStringArray("image_description");

		setListAdapter(new ProfilerImageAdapter(this, imageName, imageDescription, fileLocation, fileName));

		ImageView ivHome = (ImageView) findViewById(R.id.actionBarHome);
		ivHome.setOnClickListener(new ImageView.OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent i = new Intent(ProfilerImageView.this, WamiListActivity.class);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				startActivity(i);
			}
		});
	}

	protected void onListItemClick(ListView l, View v, int position, long id) {
		ProfilerImageAdapter profileImageAdapter = (ProfilerImageAdapter) getListAdapter();
		String selectedValue = profileImageAdapter.getItem(position);
		Toast.makeText(this, selectedValue, Toast.LENGTH_SHORT).show();

		GetFile task = new GetFile();
		try {
			String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
			File folder = new File(extStorageDirectory, "Image");
			folder.mkdir();
			ArrayList<String> params = new ArrayList<String>();
			params.add(fileLocation[position]);
			params.add(fileName[position]);
			params.add(String.valueOf(folder));
			task.execute(new ArrayList[] { params }).get();

			try {
				Intent intent = new Intent();
				intent.setAction(Intent.ACTION_VIEW);
				File fileToRead = new File(folder + "/" + fileName[position]);
				Uri uri = Uri.fromFile(fileToRead.getAbsoluteFile());
				intent.setDataAndType(uri, "image/*");
				startActivity(intent);
			}
			catch (ActivityNotFoundException activityNotFoundException) {
				activityNotFoundException.printStackTrace();
				Toast.makeText(this, "There doesn't seem to be an Image viewer installed.",	Toast.LENGTH_LONG).show();
			}
			catch (Exception ex) {
				ex.printStackTrace();
				Toast.makeText(this, "Cannot open the selected file.",	Toast.LENGTH_LONG).show();
			}
		}
		catch (InterruptedException e) {
			e.printStackTrace();
		}
		catch (ExecutionException e) {
			e.printStackTrace();
		}
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.profiler_image_menu, menu);
		return true;
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		int id = item.getItemId();

		switch (id) {
			case android.R.id.home:
				super.onBackPressed();
				return true;
		}

		// Navigate to action
		if (id == R.id.action_navigate_to) {
			ActionList actionList = new ActionList();
			actionList.actionList(that, identityProfileId, imageUrl, profileName, firstName, lastName, userIdentityProfileId, useDefault);
		}

// My Wami Network
		if (id == R.id.action_home) {
			Intent i = new Intent(ProfilerImageView.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(ProfilerImageView.this, Login.class);
			startActivity(i);
		}
		return super.onOptionsItemSelected(item);
	}

	public class GetFile extends AsyncTask<ArrayList, Void, Void> {

		@Override
		protected Void doInBackground(ArrayList... params) {
			try {
				String fileLocation = String.valueOf(params[0].get(0));
				fileLocation = fileLocation.substring(0, fileLocation.length() - 7);
				String fileName = String.valueOf(params[0].get(1));
				String folder = String.valueOf(params[0].get(2));

				String path = Constants.ASSETS_IP + fileLocation + fileName;
//				String ipNoSlash = Constants.IP.substring(0, Constants.IP.length() - 1);
//				String path = ipNoSlash + ":80/" + fileLocation + fileName;

				URL u = new URL(path);

				HttpParams httpParameters = new BasicHttpParams();
				HttpURLConnection c = (HttpURLConnection) u.openConnection();
				int timeoutConnection = 3000;
				int timeoutSocket = 5000;
				HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);
				HttpConnectionParams.setConnectionTimeout(httpParameters, timeoutConnection);

				InputStream is = c.getInputStream();
				FileOutputStream fos = new FileOutputStream(new File(folder + "/" + fileName));
				int bytesRead = 0;
				byte[] buffer = new byte[4096];
				while ((bytesRead = is.read(buffer)) != -1) {
					fos.write(buffer, 0, bytesRead);
				}
				fos.close();
				is.close();
				c.disconnect();
			}
			catch (MalformedURLException e) {
				e.printStackTrace();
			}
			catch (FileNotFoundException e) {
				e.printStackTrace();
			}
			catch (IOException e) {
				e.printStackTrace();
			}
			return null;
		}
	}
}