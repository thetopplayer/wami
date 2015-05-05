package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.Login;
import com.MyWami.R;
import com.MyWami.WamiListActivity;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by robertlanter on 1/31/15.
 */
public class CreateAccount {
  private Context context;
  final private String INSERT_NEW_ACCOUNT_DATA = Constants.IP + "insert_new_account_data.php";
  final private String CHECK_ACCOUNT_DATA = Constants.IP + "check_account_data.php";

  public CreateAccount() {
  }

  public void createAccount(final Context context) {
    this.context = context;

    final Dialog dialog = new Dialog(context);
    dialog.getWindow();
    dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
    dialog.setContentView(R.layout.dialog_create_account);
    dialog.setCancelable(false);

    final EditText etAccountFirstName = (EditText) dialog.findViewById(R.id.account_first_name_edit);
    final EditText etAccountLastName = (EditText) dialog.findViewById(R.id.account_last_name_edit);
    final EditText etAccountEmailAddress = (EditText) dialog.findViewById(R.id.account_email_address_edit);
    final EditText etAccountUsername = (EditText) dialog.findViewById(R.id.account_username_edit);
    final EditText etAccountPassword = (EditText) dialog.findViewById(R.id.account_password_edit);
    final EditText etAccountRetypePassword = (EditText) dialog.findViewById(R.id.account_retype_password_edit);
    final EditText etAccountFirstProfileName = (EditText) dialog.findViewById(R.id.account_first_profile_name_edit);
    final EditText etAccountTeleNumber = (EditText) dialog.findViewById(R.id.account_tele_number_edit);
    final EditText etAccountProfileDescription = (EditText) dialog.findViewById(R.id.account_profile_description_edit);

    Button btnCreateAccount = (Button) dialog.findViewById(R.id.create_account_btn);
    btnCreateAccount.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        String username = (String.valueOf(etAccountUsername.getText())).trim();
        if (username.equals("")) {
          Toast.makeText(context.getApplicationContext(), "Account Username is a required field!", Toast.LENGTH_LONG).show();
          return;
        }
        Pattern patternUserName = Pattern.compile("^[a-zA-Z0-9_-]+$");
        Matcher matcherUserName = patternUserName.matcher(username);
        if (!matcherUserName.matches()) {
          Toast.makeText(context.getApplicationContext(), "Username must only contain letters, numbers, underscores, and hyphens!", Toast.LENGTH_LONG).show();
          return;
        }

        String password = (String.valueOf(etAccountPassword.getText())).trim();
        if (password.equals("")) {
          Toast.makeText(context.getApplicationContext(), "Password is a required field!", Toast.LENGTH_LONG).show();
          return;
        }   //[!@#$%^&]
        Pattern patternPassword = Pattern.compile("^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&])(?=\\S+$).{8,20}$");
        Matcher matcherPassword = patternPassword.matcher(password);
        if (!matcherPassword.matches()) {
          Toast.makeText(context.getApplicationContext(), "Password must be at least 8 characters, at least 1 upper case letter, at least 1 lower case letter, at least 1 number," +
              " and at least 1 of the following characters: ! @ # $ % ^ & \"", Toast.LENGTH_LONG).show();
          return;
        }

        String retypePassword = ((String.valueOf(etAccountRetypePassword.getText())).trim()).trim();
        if (retypePassword.equals("")) {
          Toast.makeText(context.getApplicationContext(), "Retype Password is required!", Toast.LENGTH_LONG).show();
          return;
        }
        String emailAddress = (String.valueOf(etAccountEmailAddress.getText())).trim();
        if (emailAddress.equals("")) {
          Toast.makeText(context.getApplicationContext(), "Email Address is a required field!", Toast.LENGTH_LONG).show();
          return;
        }
        String firstProfileName = (String.valueOf(etAccountFirstProfileName.getText())).trim();
        if (firstProfileName.equals("")) {
          Toast.makeText(context.getApplicationContext(), "First Profile Name is a required field!", Toast.LENGTH_LONG).show();
          return;
        }
        Pattern patternProfileName = Pattern.compile("^[a-zA-Z0-9_-]+$");
        Matcher matcherProfileName = patternProfileName.matcher(firstProfileName);
        if (!matcherProfileName.matches()) {
          Toast.makeText(context.getApplicationContext(), "First Profile Name must only contain letters, numbers, underscores, and hyphens!", Toast.LENGTH_LONG).show();
          return;
        }

        if (!password.equals(retypePassword)) {
          Toast.makeText(context.getApplicationContext(), "Password and Retype Password must be the same!", Toast.LENGTH_LONG).show();
          return;
        }

        String[] postData = { username, emailAddress, firstProfileName };
        JsonGetData jsonGetData = new JsonGetData();
        jsonGetData.jsonGetData(context, CHECK_ACCOUNT_DATA, postData);
        String jsonResult = jsonGetData.getJsonResult();
        try {
          JSONObject jsonResponse = new JSONObject(jsonResult);
          int ret_code = jsonResponse.optInt("ret_code");
          if (ret_code == -1) {
            String message = jsonResponse.optString("message");
            Toast.makeText(context.getApplicationContext(), message, Toast.LENGTH_LONG).show();
            return;
          }
        }
        catch (JSONException e) {
          e.printStackTrace();
          return;
        }

        String firstName = (String.valueOf(etAccountFirstName.getText())).trim();
        String lastName = (String.valueOf(etAccountLastName.getText())).trim();
        String teleNumber = (String.valueOf(etAccountTeleNumber.getText())).trim();
        String description = (String.valueOf(etAccountProfileDescription.getText())).trim();
        String[] postData1 = { username, password, firstName, lastName, emailAddress, firstProfileName, teleNumber, description };
        jsonGetData = new JsonGetData();
        jsonGetData.jsonGetData(context, INSERT_NEW_ACCOUNT_DATA, postData1);
        jsonResult = jsonGetData.getJsonResult();
        try {
          JSONObject jsonResponse = new JSONObject(jsonResult);
          int ret_code = jsonResponse.optInt("ret_code");
          if (ret_code == -1) {
            String message = jsonResponse.optString("message");
            Toast.makeText(context.getApplicationContext(), message, Toast.LENGTH_LONG).show();
            return;
          }
        }
        catch (JSONException e) {
          e.printStackTrace();
          return;
        }

        Toast.makeText(context.getApplicationContext(), "Congrats...Account created. Login and start connecting...", Toast.LENGTH_LONG).show();

        Intent i = new Intent(context, Login.class);
        i.putExtra("new_account", true);
        i.putExtra("username", username);
        i.putExtra("password", password);
        context.startActivity(i);

        dialog.dismiss();
      }
    });

    Button closeFlash = (Button) dialog.findViewById(R.id.cancel_account_btn);
    closeFlash.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        dialog.dismiss();
      }
    });

    dialog.show();
  }
}
