//
//  Utilities.swift
//  MyWami
//
//  Created by Robert Lanter on 2/20/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    var IP = "http://localhost/MyWamiIOS/MyWami/MyWami/"
    var ASSETS_IP = "http://192.168.15.3:80/Wami/"
//    var ASSETS_IP = "http://192.168.0.2:80/Wami/"
//    var ASSETS_IP = "http://192.168.254.42:80/Wami/"
    var EMAIL_IP = "http://www.mywami.com/"
    var DB_NAME = "wamilocal.db"
    var DB_PATH = "/Users/robertlanter/projects/"
    let WAIT_TIME: useconds_t = 30000
    

    @IBAction func alertMessage(message: NSString, viewController: UIViewController) {
        var alertController = UIAlertController(title: "ALERT", message: message as String, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.view.backgroundColor = UIColor.blackColor()
        alertController.view.tintColor = UIColor.blackColor()
        viewController.presentViewController(alertController, animated: false, completion: nil)
        return
    }
}