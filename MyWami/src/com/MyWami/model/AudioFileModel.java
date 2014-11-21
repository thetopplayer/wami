package com.MyWami.model;

/**
 * Created by robertlanter on 10/13/14.
 */
public class AudioFileModel {
	private String fileName;
	private String audioFileName;
	private String fileLocation;
	private String audioDescription;

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getAudioFileName() {
		return audioFileName;
	}

	public void setAudioFileName(String audioFileName) {
		this.audioFileName = audioFileName;
	}

	public String getFileLocation() {
		return fileLocation;
	}

	public void setFileLocation(String fileLocation) {
		this.fileLocation = fileLocation;
	}

	public String getAudioDescription() {
		return audioDescription;
	}

	public void setAudioDescription(String audioDescription) {
		this.audioDescription = audioDescription;
	}
}
