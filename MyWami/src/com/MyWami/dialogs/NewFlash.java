package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.Flash;
import com.MyWami.R;
import com.MyWami.util.Constants;
import com.MyWami.webservice.JsonGetData;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

/**
 * Created by robertlanter on 7/29/14.
 */
public class NewFlash {
	private Context context;
	private String identityProfileId;
	private String toastMessage = "";
	private String newFlashMsg;
	final private String INSERT_FLASH = Constants.IP + "insert_flash.php";

	public NewFlash() {
	}

	public void newFlash(final Context context, final String identityProfileId) {
		this.context = context;
		this.identityProfileId = identityProfileId;

		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_new_flash);
		dialog.setCancelable(false);

		final EditText etNewFlash = (EditText) dialog.findViewById(R.id.new_flash_edit);
		Button btnSaveFlash = (Button) dialog.findViewById(R.id.save_flash_btn);
		btnSaveFlash.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				newFlashMsg = etNewFlash.getText().toString();
				if (newFlashMsg.length() == 0) {
					formatToast("Flash message can't be empty");
					return;
				}
				String[] postData = { newFlashMsg, identityProfileId };
				JsonGetData jsonGetData = new JsonGetData();
				jsonGetData.jsonGetData(context, INSERT_FLASH, postData);
				try {
					Method m = Flash.class.getMethod("refreshFlash");
					m.invoke(context);
				}
				catch (NoSuchMethodException e) {
					e.printStackTrace();
				}
				catch (InvocationTargetException e) {
					e.printStackTrace();
				}
				catch (IllegalAccessException e) {
					e.printStackTrace();
				}
			}
		});

		final TextWatcher mTextEditorWatcher = new TextWatcher() {
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if (count > 109) {
					formatToast("Max number of characters reached...110.");
					return;
				}
			}
			public void afterTextChanged(Editable s) {
			}
		};
		etNewFlash.addTextChangedListener(mTextEditorWatcher);

		Button closeFlash = (Button) dialog.findViewById(R.id.close_flash_btn);
		closeFlash.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		dialog.show();
	}

	private void formatToast(String msg) {
		LinearLayout  layout = new LinearLayout(context);
		layout.setBackgroundResource(R.color.black);

		TextView  tv = new TextView(context);
		tv.setTextColor(Color.WHITE);
		tv.setTextSize(17);
		tv.setGravity(Gravity.CENTER);
		tv.setHeight(80);
		tv.setWidth(450);
		tv.setText(msg);

		layout.addView(tv);
		Toast toast = new Toast(context);
		toast.setView(layout);
		toast.setGravity(Gravity.TOP, 0, 120);
		toast.setDuration(Toast.LENGTH_LONG);
		toast.show();
	}
}
