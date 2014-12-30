package com.MyWami.dialogs;

import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.view.View;
import android.view.Window;
import android.widget.*;
import com.MyWami.R;
import com.MyWami.SearchResults;

/**
 * Created by robertlanter on 7/17/14.
 */
public class SearchForProfiles {
	private Context context;
	private String userIdentityProfileId;
	private boolean useDefault;

	public SearchForProfiles() {

	}

	public void searchForProfiles(final Context context, final String userIdentityProfileId, final boolean useDefault) {
		this.context = context;
		this.useDefault = useDefault;
		this.userIdentityProfileId = userIdentityProfileId;

		final Dialog dialog = new Dialog(context);
		dialog.getWindow();
		dialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
		dialog.setContentView(R.layout.dialog_search_for_profiles);

		final Spinner dropdown = (Spinner)dialog.findViewById(R.id.search_in_edit);
		String[] items = new String[]{"Profile Name", "First Name", "Last Name", "Tags", "Description"};
		ArrayAdapter<String> adapter = new ArrayAdapter<String>(context, android.R.layout.simple_spinner_dropdown_item, items);
		dropdown.setAdapter(adapter);

		dropdown.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
			@Override
			public void onItemSelected(AdapterView<?> parentView, View selectedItemView, int position, long id) {
				((TextView) parentView.getChildAt(0)).setTextColor(Color.BLACK);
			}

			@Override
			public void onNothingSelected(AdapterView<?> parent) {

			}
		});

		final EditText searchStrEdit = (EditText) dialog.findViewById(R.id.search_str_edit);

		RadioGroup searchWithinRadioGroup = (RadioGroup) dialog.findViewById(R.id.search_within_edit);
		RadioButton checkedRadioButton = (RadioButton)searchWithinRadioGroup.findViewById(searchWithinRadioGroup.getCheckedRadioButtonId());
		searchWithinRadioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
			public void onCheckedChanged(RadioGroup rGroup, int checkedId) {
				RadioButton checkedRadioButton = (RadioButton)rGroup.findViewById(checkedId);
				boolean isChecked = checkedRadioButton.isChecked();
				if (isChecked) {

				}
			}
		});

		Button closeSearch = (Button) dialog.findViewById(R.id.closeSearch);
		closeSearch.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				dialog.dismiss();
			}
		});

		final Button searchForProfiles = (Button) dialog.findViewById(R.id.searchForProfiles);
		searchForProfiles.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				if ((searchStrEdit.getText().toString()).equals("")) {
					Toast.makeText(context, "Please enter a search string.", Toast.LENGTH_LONG).show();
					return;
				}
				Intent i = new Intent(context, SearchResults.class);
				i.putExtra("user_identity_profile_id", userIdentityProfileId);
				i.putExtra("use_default", useDefault);
				i.putExtra("selected_item", dropdown.getSelectedItem().toString());
				i.putExtra("search_str", searchStrEdit.getText().toString());
				context.startActivity(i);
			}
		});

		dialog.show();
	}
}
