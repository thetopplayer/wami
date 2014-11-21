package com.MyWami.model;

/**
 * Created by robertlanter on 2/24/14.
 */
public class TransmitModel {
	private int fromIdentityProfileId;
	private int wamiToTransmitId;
	private String toProfileName;
	private String toEmailAddress;


	public String getToProfileName() {
		return toProfileName;
	}

	public void setToProfileName(String toProfileName) {
		this.toProfileName = toProfileName;
	}

	public String getToEmailAddress() {
		return toEmailAddress;
	}

	public void setToEmailAddress(String toEmailAddress) {
		this.toEmailAddress = toEmailAddress;
	}

	public int getFromIdentityProfileId() {
		return fromIdentityProfileId;
	}

	public void setFromIdentityProfileId(int fromIdentityProfileId) {
		this.fromIdentityProfileId = fromIdentityProfileId;
	}

	public int getWamiToTransmitId() {
		return wamiToTransmitId;
	}

	public void setWamiToTransmitId(int wamiToTransmitId) {
		this.wamiToTransmitId = wamiToTransmitId;
	}
}
