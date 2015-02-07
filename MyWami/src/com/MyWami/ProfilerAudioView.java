package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.ListActivity;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.*;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
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
public class ProfilerAudioView extends ListActivity {
	private String[] fileName;
	private String[] fileLocation;
	private String[] audioDescription;

	private String identityProfileId;
	private String imageUrl;
	private String profileName;
	private String firstName;
	private String lastName;
	private String userIdentityProfileId;
	private boolean useDefault;
	private Context that;

	private ProgressDialog pd;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		that = this;

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_profiler_audio);
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
		String[] audioFileName = extras.getStringArray("audio_file_name");
		fileName = extras.getStringArray("file_name");
	  fileLocation = extras.getStringArray("file_location");
		audioDescription = extras.getStringArray("audio_description");

		setListAdapter(new ProfilerAudioAdapter(this, audioFileName, audioDescription));
	}

	protected void onListItemClick(ListView l, View v, int position, long id) {
		ProfilerAudioAdapter profileAudioAdapter = (ProfilerAudioAdapter) getListAdapter();
		String selectedValue = profileAudioAdapter.getItem(position);
		Toast.makeText(this, selectedValue, Toast.LENGTH_SHORT).show();

		GetFile task = new GetFile();
		String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
		File folder = new File(extStorageDirectory, "Audio");
		folder.mkdir();
		ArrayList<String> params = new ArrayList<String>();
		params.add(fileLocation[position]);
		params.add(fileName[position]);
		params.add(String.valueOf(folder));
		task.execute(new ArrayList[]{params});

		try {
      Intent intent = new Intent();
      intent.setAction(Intent.ACTION_VIEW);
      File fileToRead = new File(folder + "/" + fileName[position]);
      Uri uri = Uri.fromFile(fileToRead.getAbsoluteFile());
      intent.setDataAndType(uri, "audio/mp3");
      startActivity(intent);
    }
    catch (ActivityNotFoundException activityNotFoundException) {
      activityNotFoundException.printStackTrace();
      Toast.makeText(this, "There doesn't seem to be an Audio player installed.",	Toast.LENGTH_LONG).show();
    }
    catch (Exception ex) {
      ex.printStackTrace();
      Toast.makeText(this, "Cannot open the selected file.",	Toast.LENGTH_LONG).show();
    }
	}

	public boolean onCreateOptionsMenu(Menu menu) {
		getMenuInflater().inflate(R.menu.profiler_audio_menu, menu);
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
			Intent i = new Intent(ProfilerAudioView.this, WamiListActivity.class);
			i.putExtra("user_identity_profile_id", userIdentityProfileId);
			i.putExtra("use_default", useDefault);
			startActivity(i);
		}

// Logout
		if (id == R.id.action_logout) {
			this.finish();
			Intent i = new Intent(ProfilerAudioView.this, Login.class);
			startActivity(i);
		}
		return super.onOptionsItemSelected(item);
	}

	public class GetFile extends AsyncTask<ArrayList, Void, Void> {

		@Override
		protected void onPreExecute() {
			super.onPreExecute();
			pd = new ProgressDialog(that);
			pd.setTitle("Getting File...");
			pd.setMessage("Please wait.");
			pd.setCancelable(true);
			pd.setCanceledOnTouchOutside(true);
			pd.setIndeterminate(true);
			pd.show();
		}

		@Override
		protected void onPostExecute(Void result) {
			super.onPostExecute(result);
			if (pd != null)	{
				pd.dismiss();
			}
		}

			@Override
		protected Void doInBackground(ArrayList... params) {
			try {
				String fileLocation = String.valueOf(params[0].get(0));
				String fileName = String.valueOf(params[0].get(1));
				String folder = String.valueOf(params[0].get(2));

				String path = Constants.ASSETS_IP + fileLocation + fileName;
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