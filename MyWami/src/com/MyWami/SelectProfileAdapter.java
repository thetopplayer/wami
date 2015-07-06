package com.MyWami;

import android.content.Context;
import android.content.res.Resources;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.TextView;
import com.MyWami.model.ProfileModel;

/**
 * Created by robertlanter on 3/10/14.
 */
public class SelectProfileAdapter extends ArrayAdapter<ProfileModel> {
	private final Context context;
	private ProfileModel[] profileModel;
	boolean[] checkBoxState;

	public SelectProfileAdapter(Context context, int layoutResourceId, ProfileModel[] profileModel) {
		super(context, layoutResourceId, profileModel);
		this.context = context;
		this.profileModel = profileModel;

		checkBoxState = new boolean[profileModel.length];
	}

	public View getView(final int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		View rowView = inflater.inflate(R.layout.select_profile, parent, false);

		TextView profileName = (TextView) rowView.findViewById(R.id.profile_name_text);
		profileName.setText(profileModel[position].getProfileName());

		CheckBox cb = (CheckBox) rowView.findViewById(R.id.checkbox1);
		int id = Resources.getSystem().getIdentifier("btn_radio_holo_light", "drawable", "android");
		cb.setButtonDrawable(id);
		cb.setChecked(checkBoxState[position]);
		if (profileModel[position].isSelected()) {
			checkBoxState[position] = true;
			cb.setSelected(checkBoxState[position]);
			cb.setChecked(true);
		}

		cb.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				if(((CheckBox)v).isChecked()) {
					checkBoxState[position] = true;
					profileModel[position].setSelected(true);
					clearChecked(position);
				}
				else {
					checkBoxState[position] = false;
					profileModel[position].setSelected(false);
				}
			}
		});

		return rowView;
	}

	private void clearChecked(int position) {
		for (int i = 0; i < profileModel.length; i++) {
			if (i == position) continue;
			profileModel[i].setSelected(false);
			checkBoxState[i] = false;
			notifyDataSetChanged();
		}
	}

}
