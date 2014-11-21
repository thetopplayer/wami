package com.MyWami.model;

/**
 * Created by robertlanter on 2/26/14.
 */
public class WamiListModel {
	private int identityProfileId;
	private int assignToIdentityProfileId;
	private String firstName;
	private String lastName;
	private String profileName;
	private String tags;
	private boolean selected;
	private String imageUrl;
	private String rating;

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public int getAssignToIdentityProfileId() {
		return assignToIdentityProfileId;
	}

	public void setAssignToIdentityProfileId(int assignToIdentityProfileId) {
		this.assignToIdentityProfileId = assignToIdentityProfileId;
	}

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

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}
}
