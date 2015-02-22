package com.MyWami.webservice;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Build;
import android.widget.Toast;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

/**
 * Created by robertlanter on 3/02/14.
 */
public class JsonGetData {
	private String jsonResult;
	private Context context;

	@TargetApi(Build.VERSION_CODES.CUPCAKE)
	public String jsonGetData(Context context, String url, String[] postData) {
		this.context = context;

		GetData task = new GetData();
		try {
			ArrayList<String> params = new ArrayList<String>();
			params.add(url);
			if (postData[0] != null) {
				for (int i = 0; i < postData.length; i++) {
					params.add(postData[i]);
				}
			}
			task.execute(new ArrayList[] { params }).get();
		}
		catch (InterruptedException e) {
			e.printStackTrace();
		}
		catch (ExecutionException e) {
			e.printStackTrace();
		}
		return null;
	}

	@TargetApi(Build.VERSION_CODES.CUPCAKE)
	public class GetData extends AsyncTask<ArrayList, Void, String> {
		@Override
		protected String doInBackground(ArrayList... params) {
			HttpClient httpclient = new DefaultHttpClient();
			ArrayList url = params[0];
			HttpPost httppost = new HttpPost((String) url.get(0));

			List<NameValuePair> nameValuePairs = new ArrayList<NameValuePair>();
			int numParams = params[0].size();
			for (int i = 1; i < numParams; i++) {
				nameValuePairs.add(new BasicNameValuePair("param".concat(String.valueOf(i)), (String) params[0].get(i)));
			}
			try {
				httppost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
			}
			catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}

			try {
				HttpResponse response = httpclient.execute(httppost);
				try {
					HttpEntity entity = response.getEntity();
					if (entity != null) {
						InputStream instream = entity.getContent();
						try {
							jsonResult = inputStreamToString(instream).toString();
						}
						finally {
							instream.close();
						}
					}
				}
				catch (IOException e) {
					e.printStackTrace();
				}
			}
			catch (ClientProtocolException e) {
				e.printStackTrace();
			}
			catch (IOException e) {
				e.printStackTrace();
			}
			return jsonResult;
		}

		private StringBuilder inputStreamToString(InputStream is) {
			String rLine = "";
			StringBuilder answer = new StringBuilder();
			BufferedReader rd = new BufferedReader(new InputStreamReader(is));

			try {
				while ((rLine = rd.readLine()) != null) {
					answer.append(rLine);
				}
			}

			catch (IOException e) {
				e.printStackTrace();
				Toast.makeText(context.getApplicationContext(), "Error..." + e.toString(), Toast.LENGTH_LONG).show();
			}
			return answer;
		}

		@Override
		protected void onPostExecute(String result){

		}
	}

	public String getJsonResult() {
		return jsonResult;
	}

}