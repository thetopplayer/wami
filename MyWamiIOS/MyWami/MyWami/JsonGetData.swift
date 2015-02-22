//
//  JsonGetData.swift
//  MyWami
//
//  Created by Robert Lanter on 2/19/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class JsonGetData {
    var jsonResult: String?
    var urlString: String!
    
  func jsonGetData (url: String, params : Dictionary<String, String>) -> String{
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var err: NSError?
    
    println(params)

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
            
        println("Body: \(strData)")   
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
            
        println(json)
            
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json {
                    var ret_code = parseJSON["ret_code"] as? Int
                    self.jsonResult = parseJSON["user_info"] as? String
                    println(self.jsonResult)
                    println("ret_code: \(ret_code)")
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }
        })
        
        task.resume()
        return ""
    }
    init() { }
    
}