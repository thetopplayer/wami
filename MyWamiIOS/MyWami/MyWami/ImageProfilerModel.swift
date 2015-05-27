//
//  ImageProfilerModel.swift
//  MyWami
//
//  Created by Robert Lanter on 5/27/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class ImageProfilerModel {
    var fileLocation = ""
    var fileName = ""
    var imageName = ""
    var imageDescription = ""
    var imageId = 0
    
    func setFileLocation(fileLocation: String) {
        self.fileLocation = fileLocation
    }
    
    func getFileLocation() -> String {
        return self.fileLocation
    }
    
    func setFileName(fileName: String) {
        self.fileName = fileName
    }
    
    func getFileName() -> String {
        return self.fileName
    }
    
    func setImageName(imageName: String) {
        self.imageName = imageName
    }
    
    func getImageName() -> String {
        return self.imageName
    }
    
    func setImageDescription(imageDescription: String) {
        self.imageDescription = imageDescription
    }
    
    func getImageDescription() -> String {
        return self.imageDescription
    }
    
    func setImageId(imageId: Int) {
        self.imageId = imageId
    }
    
    func getImageId() -> Int {
        return self.imageId
    }
}

