package com.MyWami.model;

/**
 * Created by robertlanter on 2/26/14.
 */
public class SearchListModel {
	private int identityProfileId;
	private String firstName;
	private String lastName;
	private String profileName;
	private String tags;
	private String imageUrl;
	private String rating;
	private String descriptiom;
	private String email;
	private boolean selected;

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public int getIdentityProfileId() {
		return identityProfileId;
	}

	public void setIdentityProfileId(int identityProfileId) {
		this.identityProfileId = identityProfileId;
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

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getDescriptiom() {
		return descriptiom;
	}

	public void setDescriptiom(String descriptiom) {
		this.descriptiom = descriptiom;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
}
