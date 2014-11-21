package com.MyWami.model;

/**
 * Created by robertlanter on 2/26/14.
 */
public class ProfileModel {
	private int identityProfileId;
	private String profileName;
	private int defaultProfileInd;
	private boolean selected;

	public int getIdentityProfileId() {
		return identityProfileId;
	}

	public void setIdentityProfileId(int identityProfileId) {
		this.identityProfileId = identityProfileId;
	}

	public String getProfileName() {
		return profileName;
	}

	public void setProfileName(String profileName) {
		this.profileName = profileName;
	}

	public int getDefaultProfileInd() {
		return defaultProfileInd;
	}

	public void setDefaultProfileInd(int defaultProfileInd) {
		this.defaultProfileInd = defaultProfileInd;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}
}
