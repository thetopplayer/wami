//
//  ProfileModel.swift
//  MyWami
//
//  Created by Robert Lanter on 4/21/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class ProfileModel {
    var identityProfileId: Int = 0
    var profileName: String = ""
    var defaultProfileInd: Int = 0
    var selected: Bool = false
    
    func setIdentityProfileId(identityProfileId: Int) {
        self.identityProfileId = identityProfileId
    }
    
    func getIdentityProfileId() -> Int {
        return self.identityProfileId
    }
    
    func setProfileName(profileName: String) {
        self.profileName = profileName
    }
    
    func getProfileName() -> String {
        return self.profileName
    }
    
    func setDefaultProfileInd(defaultProfileInd: Int) {
        self.defaultProfileInd = defaultProfileInd
    }
    
    func getDefaultProfileInd() -> Int {
        return self.defaultProfileInd
    }
    
    func setSelected(selected: Bool) {
        self.selected = selected
    }
    
    func getSelected() -> Bool {
        return self.selected
    }
    
    
    
    
}

