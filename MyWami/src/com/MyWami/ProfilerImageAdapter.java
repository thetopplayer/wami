package com.MyWami;

import android.annotation.TargetApi;
import android.content.Context;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Environment;
import android.os.NetworkOnMainThreadException;
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

import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
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

	public ProfilerImageAdapter(Context context, String[] imageName, String[] imageDescription, String[] fileLocation, String[] fileName) {
		super(context, R.layout.profiler_image, imageName);
		this.context = context;
		this.imageName = imageName;
		this.imageDescription = imageDescription;
		this.fileLocation = fileLocation;
		this.fileName = fileName;
	}

	private class ViewHolder {
		ImageView listImage;
		TextView listImageName;
		TextView listImageDescription;
	}

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
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

		InputStream inputStream = null;
		try {
//			String location = fileLocation[position] + fileName[position];
			// string off "assets" from the fileLocation
//			location = location.substring(7);
//			inputStream = getContext().getAssets().open(location);

			String extStorageDirectory = Environment.getExternalStorageDirectory().toString();
			File folder = new File(extStorageDirectory, "Image/thumbs");
			folder.mkdir();

			String path = Constants.ASSETS_IP + fileLocation + fileName;
			URL url = new URL(path);

			HttpParams httpParameters = new BasicHttpParams();
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			int timeoutConnection = 3000;
			int timeoutSocket = 5000;
			HttpConnectionParams.setSoTimeout(httpParameters, timeoutSocket);
			HttpConnectionParams.setConnectionTimeout(httpParameters, timeoutConnection);

			inputStream = connection.getInputStream();
			viewHolder.listImage.setImageBitmap(BitmapFactory.decodeStream(inputStream));
			FileOutputStream fos = new FileOutputStream(new File(folder + "/" + fileName));
			int bytesRead = 0;
			byte[] buffer = new byte[4096];
			while ((bytesRead = inputStream.read(buffer)) != -1) {
				fos.write(buffer, 0, bytesRead);
			}
			fos.close();
			inputStream.close();
			connection.disconnect();
		}
		catch (NetworkOnMainThreadException e) {
			e.printStackTrace();
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

		viewHolder.listImage.setImageBitmap(BitmapFactory.decodeStream(inputStream));
//		viewHolder.listImage.setImageDrawable(is);
		viewHolder.listImageName.setText(imageName[position]);
		viewHolder.listImageDescription.setText(imageDescription[position]);

		return row;
	}
}
