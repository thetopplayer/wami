package com.MyWami;

import android.content.Context;
import android.os.Handler;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import com.MyWami.dialogs.MoreInfoAudio;

/**
 * Created by robertlanter on 3/9/14.
 */
public class ProfilerAudioAdapter extends ArrayAdapter<String> {
	private final Context context;
	private final String[] songTitle;
  private final String[] fileName;
	private final String[] audioDescription;

	public ProfilerAudioAdapter(Context context, String[] songTitle, String[] fileName, String[] audioDescription) {
		super(context, R.layout.profiler_audio, songTitle);
		this.context = context;
		this.songTitle = songTitle;
    this.fileName = fileName;
		this.audioDescription = audioDescription;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		View rowView = inflater.inflate(R.layout.profiler_audio, parent, false);
		TextView listText = (TextView) rowView.findViewById(R.id.audio_file_name);
		Button listButton = (Button) rowView.findViewById(R.id.audio_description);
		listText.setText(songTitle[position]);

		listButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String audioDescription1 = audioDescription[position];
        String fileName1 = fileName[position];
        String songTitle1 = songTitle[position];
				MoreInfoAudio moreInfo = new MoreInfoAudio();
				moreInfo.moreInfo(context, audioDescription1, songTitle1, fileName1);
			}
		});

		return rowView;
	}
}
