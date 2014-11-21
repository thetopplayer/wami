package com.MyWami.model;

/**
 * Created by robertlanter on 3/12/14.
 */
public class FlashModel {
	private int identityProfileId;
	private String flash;
	private String createDate;
	private String media_url;


	public String getMedia_url() {
		return media_url;
	}

	public void setMedia_url(String media_url) {
		this.media_url = media_url;
	}

	public String getFlash() {
		return flash;
	}

	public int getIdentityProfileId() {
		return identityProfileId;
	}

	public void setIdentityProfileId(int identityProfileId) {
		this.identityProfileId = identityProfileId;
	}

	public void setFlash(String flash) {
		this.flash = flash;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}
}
