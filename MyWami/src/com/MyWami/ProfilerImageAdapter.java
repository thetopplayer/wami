package com.MyWami;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.StrictMode;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import com.MyWami.util.Constants;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;

import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

/**
 * Created by robertlanter on 3/9/14.
 */
public class ProfilerImageAdapter extends ArrayAdapter<String> {
	private final Context context;
	private final String[] imageName;
	private final String[] imageDescription;
	private final String[] fileLocation;
	private final String[] fileName;

	@TargetApi(Build.VERSION_CODES.GINGERBREAD)
	public ProfilerImageAdapter(Context context, String[] imageName, String[] imageDescription, String[] fileLocation, String[] fileName) {
		super(context, R.layout.profiler_image, imageName);
		this.context = context;
		this.imageName = imageName;
		this.imageDescription = imageDescription;
		this.fileLocation = fileLocation;
		this.fileName = fileName;

		StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
		StrictMode.setThreadPolicy(policy);
	}

	private class ViewHolder {
		ImageView listImage;
		TextView listImageName;
		TextView listImageDescription;
	}

	@Override
	public View getView(int position, View row, ViewGroup parent) {
		ViewHolder viewHolder;

		if (row == null) {
			LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
			row = inflater.inflate(R.layout.profiler_image, parent, false);
			viewHolder = new ViewHolder();

			viewHolder.listImage = (ImageView) row.findViewById(R.id.list_image);
			viewHolder.listImageName = (TextView) row.findViewById(R.id.image_name);
			viewHolder.listImageDescription = (TextView) row.findViewById(R.id.image_description);
			row.setTag( viewHolder);
		}
		else {
			viewHolder = (ViewHolder) row.getTag();
		}

		InputStream is = null;
		try {
			String location = fileLocation[position] + fileName[position];
			// string off "assets" from the fileLocation
//			location = location.substring(7);
			location = Constants.ASSETS_IP + location;

			URL u = new URL(location);

			HttpParams httpParameters = new BasicHttpParams();
			HttpURLConnection c = (HttpURLConnection) u.openConnection();
			int timeoutConnection = 3000;
			int timeoutSocket = 5000;
			HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);
			HttpConnectionParams.setConnectionTimeout(httpParameters, timeoutConnection);

			is = c.getInputStream();
		}
		catch (IOException ex) {
			ex.printStackTrace();
		}

		viewHolder.listImage.setImageBitmap(BitmapFactory.decodeStream(is));
		viewHolder.listImageName.setText(imageName[position]);
		viewHolder.listImageDescription.setText(imageDescription[position]);

		return row;
	}
}
