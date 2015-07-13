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
public class MoreInfoAudio {
  public MoreInfoAudio() {}

  public void moreInfo(final Context context, final String description, String songTitle, String fileName) {
    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_more_info_audio);

    TextView tvFileName = (TextView) dialog.findViewById(R.id.file_name);
    tvFileName.setText(fileName);

    TextView tvSongTitle = (TextView) dialog.findViewById(R.id.song_title);
    tvSongTitle.setText(songTitle);

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
