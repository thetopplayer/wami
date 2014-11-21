package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;
import com.MyWami.R;

/**
 * Created by robertlanter on 7/22/14.
 */
public class SearchMoreInfo {
	private Context context;
	private String description;

	public SearchMoreInfo() {

	}

	public void searchMoreInfo(final Context context, final String description) {
		this.context = context;
		this.description = description;

		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_search_more_info);

		final TextView moreInfo = (TextView) dialog.findViewById(R.id.dialog_text);
		moreInfo.setText(description);

		Button closeMoreInfo = (Button) dialog.findViewById(R.id.close_more_info);
		closeMoreInfo.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		dialog.show();
	}
}
