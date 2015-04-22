//
//  JsonGetDataSynchronous.swift
//  MyWami
//
//  Created by Robert Lanter on 4/19/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//
import Foundation

public class JsonGetDataSynchronous {
    func jsonGetData (url: String, params : Dictionary<String, String>) -> JSON {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        
        var err: NSError?
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var response: NSURLResponse?
        var error: NSError?
        let dataVal = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
        if let httpResponse = response as? NSHTTPURLResponse {
            
        }
        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary

        
//        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse? >= nil
//        var error: NSErrorPointer = nil
//        var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: nil)!
//        var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        return JSON(jsonResult)
    }
}
