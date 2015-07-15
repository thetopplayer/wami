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
import com.MyWami.util.AddToContacts;

import java.util.ArrayList;

/**
 * Created by robertlanter on 1/22/14.
 */
public class WamiListAdapter extends ArrayAdapter {
	Context context;
	int layoutResourceId;
	boolean[] checkBoxState;
	WamiListModel[] wamiListModel;


public WamiListAdapter(Context context, int layoutResourceId, WamiListModel[] wamiListModel) {
		super(context, layoutResourceId);

		this.context = context;
		this.layoutResourceId = layoutResourceId;
		this.wamiListModel = wamiListModel;

    checkBoxState = new boolean[wamiListModel.length];
	}

  @Override
  public int getCount() {
    return wamiListModel.length;
  }

  private class ViewHolder {
		CheckBox listCheckBox;
		ImageView listImage;
		TextView listTextName;
		TextView listTextProfileName;
		ImageView listIcon;
		Button listButtonTransmit;
		Button listButtonAddToContacts;
	}

	@Override
	public View getView(final int position, View row, ViewGroup parent) {
		final ViewHolder viewHolder;

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
			viewHolder.listButtonTransmit = (Button) row.findViewById(R.id.list_transmit_btn);
			viewHolder.listButtonAddToContacts = (Button) row.findViewById(R.id.list_add_to_contacts);
			viewHolder.listIcon = (ImageView) row.findViewById(R.id.list_icon);
			row.setTag( viewHolder);
		}
		else {
			viewHolder = (ViewHolder) row.getTag();
		}

    String imageUrl = wamiListModel[position].getImageUrl();
    Drawable imageUrlId;
    imageUrlId = context.getResources().getDrawable(context.getResources().getIdentifier(imageUrl, "drawable", context.getPackageName()));
		viewHolder.listImage.setImageDrawable(imageUrlId);

    String contactName = wamiListModel[position].getFirstName() +  " " + wamiListModel[position].getLastName();
    viewHolder.listTextName.setText(contactName);

		viewHolder.listTextProfileName.setText(wamiListModel[position].getProfileName());
		viewHolder.listCheckBox.setChecked(checkBoxState[position]);

		viewHolder.listButtonTransmit.setOnClickListener(new View.OnClickListener() {
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

		viewHolder.listButtonAddToContacts.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
        String mContactName = wamiListModel[position].getProfileName();
        String mPhoneNumber = wamiListModel[position].getTelephone();
        String mEmailAddress = wamiListModel[position].getEmail();
        AddToContacts addToContacts = new AddToContacts();
        addToContacts.addToContacts(context, mPhoneNumber, mEmailAddress, mContactName);
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
}