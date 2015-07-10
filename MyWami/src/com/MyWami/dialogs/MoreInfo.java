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
public class MoreInfo {
	public MoreInfo() {}

	public void moreInfo(final Context context, final String description, String profileName) {
		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_more_info);

    TextView tvProfileName = (TextView) dialog.findViewById(R.id.profile_name);
    tvProfileName.setText(profileName);

//    final TextView tags = (TextView) dialog.findViewById(R.id.tags);
//    moreInfo.setText(tags);

    final TextView tvDescription = (TextView) dialog.findViewById(R.id.description);
    tvDescription.setText(description);

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
