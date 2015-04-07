//
//  SQLiteHelper.swift
//  MyWami
//
//  Created by Robert Lanter on 4/6/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class SQLiteHelper {
    let UTILITIES = Utilities()
    var wamiDB: FMDatabase!
    
    func initDB () {
        var wamiDB = FMDatabase(path: UTILITIES.DB_PATH + UTILITIES.DB_NAME)
        
        if wamiDB == nil {
            println("DB not found")
        }
        else {
            wamiDB.open()
            self.wamiDB = wamiDB
        }
    }
    
    func cleanup() {
        wamiDB.close()
    }
    
    func getUserInfo() -> UserModel? {
        let userModel = UserModel()
        var userId: Int
        var username: String
        var userPassword: String
        
        let qryString = "SELECT user_id, username, password FROM user"
        let resultSet:FMResultSet! = wamiDB.executeQuery(qryString, withArgumentsInArray: nil)
        
        var userIdCol: String = "user_id"
        var userNameCol: String = "username"
        var userPasswordCol: String = "password"
        if (resultSet != nil) {
            if resultSet.next() {
                userId = Int(resultSet.intForColumn(userIdCol))
                username = resultSet.stringForColumn(userNameCol)
                userPassword = resultSet.stringForColumn(userPasswordCol)
                userModel.setUserId(userId)
                userModel.setUserName(username)
                userModel.setUserPassword(userPassword)
            }
        }
        else {
            return nil
        }
        return userModel
    }
    
    func saveUserInfo(userModel: UserModel) {
        var userId = userModel.getUserId()
        var username = userModel.getUserName()
        var userPassword = userModel.getUserPassword()
        
        var deleteString = "DELETE from user"
        var result = wamiDB.executeUpdate(deleteString, withArgumentsInArray: nil)
        if !result {
            println("delete failed: \(wamiDB.lastErrorMessage())")
        }
        
        var insertString = "INSERT INTO user (user_id, username, password) VALUES (?,?,?)"
        result = wamiDB.executeUpdate(insertString, withArgumentsInArray: [userId, username, userPassword])
        if !result {
             println("insert failed: \(wamiDB.lastErrorMessage())")
        }
    }
    
    init() {
        initDB()
    }
}
