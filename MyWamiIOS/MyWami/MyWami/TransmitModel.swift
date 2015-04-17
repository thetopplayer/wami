//
//  TransmitModel.swift
//  MyWami
//
//  Created by Robert Lanter on 4/16/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class Transmit {
    
    var fromIdentityProfileId: Int = 0
    var wamiToTransmitId: Int = 0
    var toProfileName: String = ""
    var toEmailAddress: String = ""
    
    func setFromIdentityProfileId(fromIdentityProfileId: Int) {
        self.fromIdentityProfileId = fromIdentityProfileId
    }
    
    func getFromIdentityProfileId() -> Int {
        return self.fromIdentityProfileId
    }
    
    func setWamiToTransmitId(wamiToTransmitId: Int) {
        self.wamiToTransmitId = wamiToTransmitId
    }
    
    func getWamiToTransmitId() -> Int {
        return self.wamiToTransmitId
    }
    
    func setToProfileName(toProfileName: String) {
        self.toProfileName = toProfileName
    }
    
    func getToProfileName() -> String {
        return self.toProfileName
    }

    func setToEmailAddress(toEmailAddress: String) {
        self.toEmailAddress = toEmailAddress
    }
    
    func getToEmailAddress() -> String {
        return self.toEmailAddress
    }

}