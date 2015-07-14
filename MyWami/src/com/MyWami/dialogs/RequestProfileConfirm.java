package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.R;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;

/**
 * Created by robertlanter on 7/29/14.
 */
public class RequestProfileConfirm {
  private Context context;
  private String confirmMsg;
  private JsonGetData jsonGetData;
  private String userIdentityProfileId;
  private ArrayList<String> emailTo;
  final private String GET_PROFILE_NAME = Constants.IP + "get_profile_name.php";
  final private String TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE = Constants.EMAIL_IP + "transmit_request_to_email_address_mobile.php";

  public RequestProfileConfirm() {
  }

  public void requestProfileConfirm(final Context context, final String userIdentityProfileId, final ArrayList<String> emailTo) {
    this.context = context;
    this.userIdentityProfileId = userIdentityProfileId;
    this.emailTo = emailTo;

    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_confirm_request_profile);
    dialog.setCancelable(false);

    confirmMsg = "You are about to send REQUEST(s) to add the chosen profile(s) to your collection. Are you sure?";
    final TextView tvConfirmMsg = (TextView) dialog.findViewById(R.id.confirm_msg);
    tvConfirmMsg.setText(confirmMsg);

    Button btnSendRequest = (Button) dialog.findViewById(R.id.send_request_btn);
    btnSendRequest.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {

        jsonGetData = new JsonGetData();
        String[] postData = {userIdentityProfileId};
        jsonGetData.jsonGetData(context, GET_PROFILE_NAME, postData);
        String jsonResult = jsonGetData.getJsonResult();
        String fromProfileName = null;
        String fromEmail = null;
        try {
          JSONObject jsonResponse = new JSONObject(jsonResult);
          fromProfileName = jsonResponse.getString("profile_name");
          fromEmail = jsonResponse.getString("email");
        }
        catch (JSONException e) {
          Toast.makeText(context, "Error" + e.toString(), Toast.LENGTH_LONG).show();
          e.printStackTrace();
        }

        String emails = null;
        for (int i = 0; i < emailTo.size(); i++) {
          emails = emails + "," + emailTo.get(i);
        }

        assert emails != null;
        emails = emails.substring(5);
        postData = new String[]{fromEmail, emails, fromEmail, fromProfileName};

        JsonGetData jsonGetData = new JsonGetData();
        jsonGetData.jsonGetData(context, TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE, postData);
        jsonResult = jsonGetData.getJsonResult();
        try {
          JSONObject jsonResponse = new JSONObject(jsonResult);
          boolean ret_code = jsonResponse.optBoolean("ret_code");

          String message = jsonResponse.optString("message");
          Toast.makeText(context, message, Toast.LENGTH_LONG).show();
        }
        catch (JSONException e) {
          e.printStackTrace();
        }

        dialog.dismiss();
      }
    });

    Button closeSendRequest = (Button) dialog.findViewById(R.id.close_send_request_btn);
    closeSendRequest.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        dialog.dismiss();
      }
    });

    dialog.show();
  }
}
