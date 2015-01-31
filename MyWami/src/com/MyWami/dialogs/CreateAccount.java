package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.R;
import com.MyWami.util.Constants;
/**
 * Created by robertlanter on 1/31/15.
 */
public class CreateAccount {
  private Context context;
  final private String INSERT_NEW_ACCOUNT = Constants.IP + "inert_new_account.php";

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
//
//        String[] postData = { newFlashMsg};
//        JsonGetData jsonGetData = new JsonGetData();
//        jsonGetData.jsonGetData(context, INSERT_FLASH, postData);
//        try {
//          Method m = Flash.class.getMethod("refreshFlash");
//          m.invoke(context);
//        }
//        catch (NoSuchMethodException e) {
//          e.printStackTrace();
//        }
//        catch (InvocationTargetException e) {
//          e.printStackTrace();
//        }
//        catch (IllegalAccessException e) {
//          e.printStackTrace();
//        }
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
