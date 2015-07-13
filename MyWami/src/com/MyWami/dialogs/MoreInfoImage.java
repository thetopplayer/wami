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
public class MoreInfoImage {
  public MoreInfoImage() {}

  public void moreInfo(final Context context, final String description, String imageName, String fileName) {
    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_more_info_image);

    TextView tvFileName = (TextView) dialog.findViewById(R.id.file_name);
    tvFileName.setText(fileName);

    TextView tvImageName = (TextView) dialog.findViewById(R.id.image_name);
    tvImageName.setText(imageName);

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
