package com.MyWami;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.provider.ContactsContract;
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

    String contactName = wamiListModel[position].getFirstName() + wamiListModel[position].getLastName();
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
				Intent intent = new Intent(ContactsContract.Intents.Insert.ACTION);
				intent.setType(ContactsContract.RawContacts.CONTENT_TYPE);

				String mContactName = wamiListModel[position].getProfileName();
				String mPhoneNumber = wamiListModel[position].getTelephone();
				String mEmailAddress = wamiListModel[position].getEmail();

				intent.putExtra(ContactsContract.Intents.Insert.EMAIL, mEmailAddress);
				intent.putExtra(ContactsContract.Intents.Insert.EMAIL_TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);
				intent.putExtra(ContactsContract.Intents.Insert.PHONE, mPhoneNumber);
				intent.putExtra(ContactsContract.Intents.Insert.PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MAIN);
				intent.putExtra(ContactsContract.Intents.Insert.NAME, mContactName);
				intent.putExtra("finishActivityOnSaveCompleted", true);

				String targetName = (String) mContactName;
				boolean bExists = false;
				ContentResolver cr = context.getContentResolver();
				Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
				if (cur.getCount() > 0) {
					while (cur.moveToNext()) {
						String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
						if (name.equals(targetName)) {
							Toast.makeText(context, "Contact: " + name + " already exists.", Toast.LENGTH_LONG).show();
							bExists = true;
							break;
						}
					}
				}
				cur.close();
				if (!bExists) {
					context.startActivity(intent);
				}

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