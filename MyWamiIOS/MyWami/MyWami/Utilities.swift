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

    @IBAction func alertMessage(message: NSString, viewController: UIViewController) {
        var alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        alertController.view.backgroundColor = UIColor.blackColor()
        alertController.view.tintColor = UIColor.blackColor()
        viewController.presentViewController(alertController, animated: true, completion: nil)
        return
    }
}