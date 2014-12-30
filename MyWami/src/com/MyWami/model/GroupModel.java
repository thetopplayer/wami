package com.MyWami.model;

/**
 * Created by robertlanter on 12/29/14.
 */
public class GroupModel {
  private int identityProfileId;
  private String groupName;
  private int profileGroupId;
  private boolean selected;

  public int getIdentityProfileId() {
    return identityProfileId;
  }

  public void setIdentityProfileId(int identityProfileId) {
    this.identityProfileId = identityProfileId;
  }

  public String getGroupName() {
    return groupName;
  }

  public void setGroupName(String groupName) {
    this.groupName = groupName;
  }

  public int getProfileGroupId() {
    return profileGroupId;
  }

  public void setProfileGroupId(int profileGroupId) {
    this.profileGroupId = profileGroupId;
  }

  public boolean isSelected() {
    return selected;
  }

  public void setSelected(boolean selected) {
    this.selected = selected;
  }
}
