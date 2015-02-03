package com.MyWami;

import android.content.Context;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import com.MyWami.dialogs.MoreInfo;

/**
 * Created by robertlanter on 3/9/14.
 */
public class ProfilerAudioAdapter extends ArrayAdapter<String> {
	private final Context context;
	private final String[] audioFileName;
	private final String[] audioDescription;

	public ProfilerAudioAdapter(Context context, String[] audioFileName, String[] audioDescription) {
		super(context, R.layout.profiler_audio, audioFileName);
		this.context = context;
		this.audioFileName = audioFileName;
		this.audioDescription = audioDescription;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		View rowView = inflater.inflate(R.layout.profiler_audio, parent, false);
		TextView listText = (TextView) rowView.findViewById(R.id.audio_file_name);
		Button listButton = (Button) rowView.findViewById(R.id.audio_description);
		listText.setText(audioFileName[position]);

		listButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String description = audioDescription[position];
				MoreInfo moreInfo = new MoreInfo();
				moreInfo.moreInfo(context, description);
			}
		});

		return rowView;
	}
}
