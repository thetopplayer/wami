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
    
    func getUserInfo() {
        let qryString = "SELECT user_id, username, password FROM user"
        
        let resultSet:FMResultSet! = wamiDB.executeQuery(qryString, withArgumentsInArray: nil)
        
        var userIdCol: String = "user_id"
        var userNameCol: String = "username"
        var userPasswordCol: String = "password"
        if (resultSet != nil) {
            while resultSet.next() {
                println("user id : \(resultSet.intForColumn(userIdCol))")
                println("user name : \(resultSet.stringForColumn(userNameCol))")
                println("password : \(resultSet.stringForColumn(userPasswordCol))")
            }
        }
        wamiDB.close()
    }
    
    init() {
        initDB()
    }
}
