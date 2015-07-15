package com.MyWami;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

/**
 * Created by robertlanter on 3/9/14.
 */
public class ProfilerAdapter extends ArrayAdapter<String> {
	private final Context context;
	private final String[] categories;

	public ProfilerAdapter(Context context, int layoutResourceId, String[] categories) {
		super(context, layoutResourceId, categories);
		this.context = context;
		this.categories = categories;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		View rowView = inflater.inflate(R.layout.profiler, parent, false);

    if (categories[position].equals("empty")) {
      return null;
    }

		TextView listText = (TextView) rowView.findViewById(R.id.profile_text);
		listText.setText(categories[position]);

		return rowView;
	}
}
