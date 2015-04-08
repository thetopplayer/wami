//
//  JsonGetData.swift
//  MyWami
//
//  Created by Robert Lanter on 2/19/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation

public class JsonGetData {

    func jsonGetData (processJsonData: (JSON) -> Void, url: String, params : Dictionary<String, String>) {
        var request = NSMutableURLRequest(URL: NSURL(string: url)!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"

        var err: NSError?

        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)

            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as NSDictionary
            if (err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: \(jsonStr)")
            }
            else {
                let json = JSON(data: data)
                processJsonData(json)
            }
        })

        task.resume()
        usleep(50000)
        return
    }
    init() { }

}