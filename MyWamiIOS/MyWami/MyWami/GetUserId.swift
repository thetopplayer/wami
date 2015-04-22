//
//  GetUserId.swift
//  MyWami
//
//  Created by Robert Lanter on 4/21/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class GetUserId {
    
    func getUserId() -> Int {
        let sqliteHelper = SQLiteHelper()
        var userModel = UserModel()

        userModel = sqliteHelper.getUserInfo()!
        return userModel.getUserId()
    }
}