//
//  AudioProfilerModel.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class AudioProfilerModel {
    var audioFileLocation = ""
    var audioFileName = ""
    var audioSongTitle = ""
    var audioFileDescription = ""
    var audioFileId = 0
    var audioCategory = ""
    
    func setAudioCategory(audioCategory: String) {
        self.audioCategory = audioCategory
    }
    
    func getAudioCategory() -> String {
        return self.audioCategory
    }

    func setAudioFileLocation(audioFileLocation: String) {
        self.audioFileLocation = audioFileLocation
    }
    
    func getAudioFileLocation() -> String {
        return self.audioFileLocation
    }
    
    func setAudioFileName(audioFileName: String) {
        self.audioFileName = audioFileName
    }
    
    func getAudioFileName() -> String {
        return self.audioFileName
    }
    
    func setAudioSongTitle(audioSongTitle: String) {
        self.audioSongTitle = audioSongTitle
    }
    
    func getAudioSongTitle() -> String {
        return self.audioSongTitle
    }
    
    func setAudioFileDescription(audioFileDescription: String) {
        self.audioFileDescription = audioFileDescription
    }
    
    func getAudioFileDescription() -> String {
        return self.audioFileDescription
    }
    
    func setAudioFileId(audioFileId: Int) {
        self.audioFileId = audioFileId
    }
    
    func getAudioFileId() -> Int {
        return self.audioFileId
    }
}






