package com.MyWami;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import com.MyWami.dialogs.MoreInfo;
import com.MyWami.model.SearchListModel;

import java.util.ArrayList;

/**
 * Created by robertlanter on 7/18/14.
 */
public class SearchResultsListAdapter  extends ArrayAdapter<ListRow> {
	Context context;
	int layoutResourceId;
	ArrayList<ListRow> listRows = null;

	boolean[] checkBoxState;
	SearchListModel[] searchListModel;

	public SearchResultsListAdapter(Context context, int layoutResourceId, ArrayList<ListRow> listRows, SearchListModel[] searchListModel) {
		super(context, layoutResourceId, listRows);

		this.context = context;
		this.layoutResourceId = layoutResourceId;
		this.listRows = listRows;
		this.searchListModel = searchListModel;
		checkBoxState = new boolean[listRows.size()];
	}

	private class ViewHolder {
		CheckBox listCheckBox;
		ImageView listImage;
		TextView listTextName;
		TextView listTextProfileName;
		TextView listTextRating;
		TextView listTextEmailName;
		Button listButton;
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
			viewHolder.listTextRating = (TextView) row.findViewById(R.id.list_text_rating);
			viewHolder.listTextEmailName = (TextView) row.findViewById(R.id.list_text_email_name);
			viewHolder.listButton = (Button) row.findViewById(R.id.list_more_info_btn);
			row.setTag( viewHolder);
		}
		else {
			viewHolder = (ViewHolder) row.getTag();
		}

		ListRow listRow = listRows.get(position);
		Drawable imageUrlId = getDrawableImage(listRow);
		viewHolder.listImage.setImageDrawable(imageUrlId);
		viewHolder.listTextName.setText(listRow.listText);
		viewHolder.listTextProfileName.setText(searchListModel[position].getProfileName());
		viewHolder.listTextRating.setText(searchListModel[position].getRating());
		viewHolder.listTextEmailName.setText(searchListModel[position].getEmail());
		viewHolder.listCheckBox.setChecked(checkBoxState[position]);

		viewHolder.listButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String content = "";
				String profileName = searchListModel[position].getProfileName();
				String description = searchListModel[position].getDescriptiom();
				if ((description.equals("")) || (description == null) || (description.equals("null"))) {
					content = profileName + ": " + "No more info exists";
				}
				else {
					content = profileName + ": \n" + description;
				}
				MoreInfo moreInfo = new MoreInfo();
				moreInfo.moreInfo(context, content);
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

	private Drawable getDrawableImage(ListRow listRow) {
		String imageUrl = listRow.listImageURL;
		Drawable imageUrlId;

		imageUrlId = context.getResources().getDrawable(context.getResources().getIdentifier(imageUrl, "drawable", context.getPackageName()));
		return imageUrlId;
	}
}
