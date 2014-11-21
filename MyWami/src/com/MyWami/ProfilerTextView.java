package com.MyWami;

import android.annotation.TargetApi;
import android.app.ActionBar;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.webkit.WebView;
import android.widget.ImageView;
import android.widget.TextView;

/**
 * Created by robertlanter on 3/4/14.
 */
public class ProfilerTextView extends Activity {
	private TextView textView;
	private WebView webView;

	@TargetApi(Build.VERSION_CODES.HONEYCOMB)
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.profiler_text_view);

		final ActionBar actionBar = getActionBar();
		actionBar.setCustomView(R.layout.actionbar_profiler_textfile);
		actionBar.setDisplayShowTitleEnabled(true);
		actionBar.setDisplayShowCustomEnabled(true);
		actionBar.setDisplayHomeAsUpEnabled(true);
		actionBar.setBackgroundDrawable(getResources().getDrawable(R.color.black));

		ImageView ivHome = (ImageView) findViewById(R.id.actionBarHome);
		ivHome.setVisibility(View.INVISIBLE);

		Bundle extras = getIntent().getExtras();
		String textDoc = extras.getString("text_doc");

		webView = (WebView)findViewById(R.id.web_view);
		textView = (TextView)findViewById(R.id.text_view);
		webView.setVisibility(View.GONE);
		textView.setText(textDoc);
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {
			case android.R.id.home:
				super.onBackPressed();
				return true;
		}
		return super.onOptionsItemSelected(item);
	}
}