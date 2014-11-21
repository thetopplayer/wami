package com.MyWami.model;

/**
 * Created by robertlanter on 2/13/14.
 */
public class ProfilerModel {

	private int identityProfileId;
	private String category;
	private String url;
	private String textDoc;
	private String mediaType;
	private String fileName;
	private String fileLocation;
	private AudioFileModel audioFileModel[];
	private ImageFileModel imageFileModel[];

	public ImageFileModel[] getImageFileModel() {
		return imageFileModel;
	}

	public void setImageFileModel(ImageFileModel[] imageFileModel) {
		this.imageFileModel = imageFileModel;
	}

	public AudioFileModel[] getAudioFileModel() {
		return audioFileModel;
	}

	public void setAudioFileModel(AudioFileModel[] audioFileModel) {
		this.audioFileModel = audioFileModel;
	}

	public String getFileLocation() {
		return fileLocation;
	}

	public void setFileLocation(String fileLocation) {
		this.fileLocation = fileLocation;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getMediaType() {
		return mediaType;
	}

	public void setMediaType(String mediaType) {
		this.mediaType = mediaType;
	}

	public String getTextDoc() {
		return textDoc;
	}

	public void setTextDoc(String textDoc) {
		this.textDoc = textDoc;
	}

	public int getIdentityProfileId() {
		return identityProfileId;
	}

	public void setIdentityProfileId(int identityProfileId) {
		this.identityProfileId = identityProfileId;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}
}

