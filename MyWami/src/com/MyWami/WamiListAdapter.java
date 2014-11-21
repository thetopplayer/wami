package com.MyWami;

import android.app.Activity;
import android.content.Context;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.*;
import com.MyWami.model.TransmitModel;
import com.MyWami.model.WamiListModel;
import com.MyWami.dialogs.TransmitWami;

import java.util.ArrayList;

/**
 * Created by robertlanter on 1/22/14.
 */
public class WamiListAdapter extends ArrayAdapter<ListRow> {
	Context context;
	int layoutResourceId;
	ArrayList<ListRow> listRows = null;

	boolean[] checkBoxState;
	WamiListModel[] wamiListModel;

	public WamiListAdapter(Context context, int layoutResourceId, ArrayList<ListRow> listRows, WamiListModel[] wamiListModel) {
		super(context, layoutResourceId, listRows);
		this.context = context;
		this.layoutResourceId = layoutResourceId;
		this.listRows = listRows;
		this.wamiListModel = wamiListModel;

		checkBoxState = new boolean[listRows.size()];
	}

	private class ViewHolder {
		CheckBox listCheckBox;
		ImageView listImage;
		TextView listTextName;
		TextView listTextProfileName;
		ImageView listIcon;
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
			viewHolder.listButton = (Button) row.findViewById(R.id.list_transmit_btn);
			viewHolder.listIcon = (ImageView) row.findViewById(R.id.list_icon);
			row.setTag( viewHolder);
		}
		else {
			viewHolder = (ViewHolder) row.getTag();
		}

		ListRow listRow = listRows.get(position);
		Drawable imageUrlId = getDrawableImage(listRow);
		viewHolder.listImage.setImageDrawable(imageUrlId);
		viewHolder.listTextName.setText(listRow.listText);
		viewHolder.listTextProfileName.setText(wamiListModel[position].getProfileName());
		viewHolder.listCheckBox.setChecked(checkBoxState[position]);

		viewHolder.listButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				ArrayList<TransmitModel> alWamiTransmitModel = new ArrayList<TransmitModel>();
				TransmitModel transmitModel = new TransmitModel();
				transmitModel.setWamiToTransmitId(wamiListModel[position].getIdentityProfileId());
				transmitModel.setFromIdentityProfileId(wamiListModel[position].getAssignToIdentityProfileId());
				alWamiTransmitModel.add(transmitModel);
				TransmitWami transmitWami = new TransmitWami();
				transmitWami.transmitWami(alWamiTransmitModel, context, true);
			}
		});

		viewHolder.listCheckBox.setOnClickListener(new View.OnClickListener() {
			public void onClick(View v) {
				if(((CheckBox)v).isChecked()) {
					checkBoxState[position] = true;
					wamiListModel[position].setSelected(true);
				}
				else {
					checkBoxState[position] = false;
					wamiListModel[position].setSelected(false);
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