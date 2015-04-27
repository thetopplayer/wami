//
//  GroupModel.swift
//  MyWami
//
//  Created by Robert Lanter on 4/27/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class GroupModel {
    var identityProfileId: Int = 0
    var groupName: String = ""
    var groupId: Int = 0
    var selected: Bool = false

    func setIdentityProfileId(identityProfileId: Int) {
        self.identityProfileId = identityProfileId
    }
    
    func getIdentityProfileId() -> Int {
        return self.identityProfileId
    }
    
    func setGroupName(groupName: String) {
        self.groupName = groupName
    }
    
    func getGroupName() -> String {
        return self.groupName
    }
    
    func setGroupId(groupId: Int) {
        self.groupId = groupId
    }
    
    func getGroupId() -> Int {
        return self.groupId
    }
    
    func setSelected(selected: Bool) {
        self.selected = selected
    }
    
    func getSelected() -> Bool {
        return self.selected
    }

}