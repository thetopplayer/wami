package com.MyWami.util;

import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.provider.ContactsContract;
import android.widget.Toast;

/**
 * Created by robertlanter on 7/15/15.
 */
public class AddToContacts {

  public void addToContacts(Context context, String telephone, String email, String profileName) {
    Intent intent = new Intent(ContactsContract.Intents.Insert.ACTION);
    intent.setType(ContactsContract.RawContacts.CONTENT_TYPE);
    intent.putExtra(ContactsContract.Intents.Insert.EMAIL, email);
    intent.putExtra(ContactsContract.Intents.Insert.EMAIL_TYPE, ContactsContract.CommonDataKinds.Email.TYPE_WORK);
    intent.putExtra(ContactsContract.Intents.Insert.PHONE, telephone);
    intent.putExtra(ContactsContract.Intents.Insert.PHONE_TYPE, ContactsContract.CommonDataKinds.Phone.TYPE_MAIN);
    intent.putExtra(ContactsContract.Intents.Insert.NAME, profileName);
    intent.putExtra("finishActivityOnSaveCompleted", true);

    boolean bExists = false;
    ContentResolver cr = context.getContentResolver();
    Cursor cur = cr.query(ContactsContract.Contacts.CONTENT_URI, null, null, null, null);
    if(cur.getCount()>0)

    {
      while (cur.moveToNext()) {
        String name = cur.getString(cur.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME));
        if (name.equals(profileName)) {
          Toast.makeText(context, "Contact: " + name + " already exists.", Toast.LENGTH_LONG).show();
          bExists = true;
          break;
        }
      }
    }

    cur.close();
    if(!bExists)

    {
      context.startActivity(intent);
    }
  }
}
