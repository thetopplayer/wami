package com.MyWami;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import com.MyWami.dialogs.MoreInfoProfile;
import com.MyWami.dialogs.MoreInfoProfile;
import com.MyWami.model.SearchListModel;
import com.MyWami.util.Constants;
import com.squareup.picasso.Picasso;

import java.util.ArrayList;

/**
 * Created by robertlanter on 7/18/14.
 */
public class SearchResultsListAdapter  extends ArrayAdapter {
	Context context;
	int layoutResourceId;
	boolean[] checkBoxState;
	SearchListModel[] searchListModel;

public SearchResultsListAdapter(Context context, int layoutResourceId, SearchListModel[] searchListModel) {
  super(context, layoutResourceId);

		this.context = context;
		this.layoutResourceId = layoutResourceId;
		this.searchListModel = searchListModel;
    checkBoxState = new boolean[searchListModel.length];
	}

	private class ViewHolder {
		CheckBox listCheckBox;
		ImageView listImage;
		TextView listTextName;
		TextView listTextProfileName;
		TextView listTextEmailName;
		Button listButton;
	}

  @Override
  public int getCount() {
    return searchListModel.length;
  }

	@Override
	public View getView(final int position, View row, ViewGroup parent) {
		ViewHolder viewHolder;

		if (row == null) {
			LayoutInflater inflater = ((Activity)context).getLayoutInflater();
			row = inflater.inflate(layoutResourceId, parent, false);
			viewHolder = new ViewHolder();

			viewHolder.listCheckBox = (CheckBox) row.findViewById(R.id.checkbox1);
			int id = Resources.getSystem().getIdentifier("btn_check_holo_light", "drawable", "android");
			viewHolder.listCheckBox.setButtonDrawable(id);

			viewHolder.listImage = (ImageView) row.findViewById(R.id.list_image);
			viewHolder.listTextName = (TextView) row.findViewById(R.id.list_text_name);
			viewHolder.listTextProfileName = (TextView) row.findViewById(R.id.list_text_profile_name);
			viewHolder.listTextEmailName = (TextView) row.findViewById(R.id.list_text_email_name);
			viewHolder.listButton = (Button) row.findViewById(R.id.list_more_info_btn);
			row.setTag( viewHolder);
		}
		else {
			viewHolder = (ViewHolder) row.getTag();
		}

    String imageUrl = searchListModel[position].getImageUrl();
    String imagePath = Constants.ASSETS_IP + Constants.MAIN_IMAGE_PATH + imageUrl + ".png";
    Picasso.with(context).invalidate(imagePath);
    Picasso.with(context).load(imagePath).into(viewHolder.listImage);

    String contactName = searchListModel[position].getFirstName() + searchListModel[position].getLastName();
    viewHolder.listTextName.setText(contactName);

		viewHolder.listTextProfileName.setText(searchListModel[position].getProfileName());
		viewHolder.listTextEmailName.setText(searchListModel[position].getEmail());
		viewHolder.listCheckBox.setChecked(checkBoxState[position]);

		viewHolder.listButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String profileName = searchListModel[position].getProfileName();
				String description = searchListModel[position].getDescriptiom();
        String tags = searchListModel[position].getTags();
				MoreInfoProfile moreInfo = new MoreInfoProfile();
				moreInfo.moreInfo(context, description, tags, profileName);
			}
		});

		viewHolder.listCheckBox.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				if(((CheckBox)v).isChecked()) {
					checkBoxState[position] = true;
					searchListModel[position].setSelected(true);
				}
				else {
					checkBoxState[position] = false;
					searchListModel[position].setSelected(false);
				}
			}
		});

		return row;
	}
}
