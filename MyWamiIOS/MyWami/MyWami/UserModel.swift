//
//  UserModel.swift
//  MyWami
//
//  Created by Robert Lanter on 4/6/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class UserModel {
    var userId: Int = 0
    var userName: String = ""
    var userPassword: String = ""

    func setUserId(userId: Int) {
        self.userId = userId
    }
    
    func getUserId() -> Int {
        return self.userId
    }
    
    func setUserName(userName: String) {
        self.userName = userName
    }
    
    func getUserName() -> String {
        return self.userName
    }
    
    func setUserPassword(userPassword: String) {
        self.userPassword = userPassword
    }
    
    func getUserPassword() -> String {
        return self.userPassword
    }
    
}
