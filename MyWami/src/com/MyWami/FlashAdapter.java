package com.MyWami;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;
import com.MyWami.model.FlashModel;

/**
 * Created by robertlanter on 3/10/14.
 */
public class FlashAdapter extends ArrayAdapter<FlashModel> {
	private final Context context;
	private FlashModel[] flashModel;

	public FlashAdapter(Context context, int layoutResourceId, FlashModel[] flashModel) {
		super(context, layoutResourceId, flashModel);
		this.context = context;
		this.flashModel = flashModel;

	}

	public View getView(int position, View convertView, ViewGroup parent) {
		LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);

		View rowView = inflater.inflate(R.layout.flash, parent, false);

		if (flashModel[position].getFlash() == "") {
			return null;
		}

		String imageUrl = flashModel[position].getMedia_url();
		if ((!imageUrl.equals("null")) && (!imageUrl.equals("")) && (imageUrl != null)) {
			try {
				Drawable imageUrlId = getDrawableImage(imageUrl);
				ImageView flashImage = (ImageView) rowView.findViewById(R.id.flash_image);
				flashImage.setImageDrawable(imageUrlId);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}

		TextView dateText = (TextView) rowView.findViewById(R.id.flash_list_date);
		dateText.setText(flashModel[position].getCreateDate());

		TextView flashText = (TextView) rowView.findViewById(R.id.flash_list_text);
		flashText.setText(flashModel[position].getFlash());

		return rowView;
	}

	private Drawable getDrawableImage(String imageUrl) {
		Drawable imageUrlId;

		imageUrlId = context.getResources().getDrawable(context.getResources().getIdentifier(imageUrl, "drawable", context.getPackageName()));
		return imageUrlId;
	}
}
