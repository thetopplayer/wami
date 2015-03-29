//
//  WamiInfoExtended.swift
//  MyWami
//
//  Created by Robert Lanter on 3/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import MessageUI

class WamiInfoExtended: UIViewController, MFMailComposeViewControllerDelegate {
   
    @IBAction func emailAction(sender: AnyObject) {
        let GET_PROFILE_NAME = UTILITIES.IP + "get_profile_name.php"
        JSONDATA.jsonGetData(getProfileName, url: GET_PROFILE_NAME, params: ["param1": userIdentityProfileId])
        usleep(100000)
        
        var emailTitle = "Message From Wami Profile: " + userProfileName
        var messageBody = ""
        var toRecipents = [email]
        var mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        self.presentViewController(mc, animated: true, completion: nil)
    }
    
    @IBAction func telephoneAction(sender: AnyObject) {
        var url:NSURL = NSURL(string: telephone)!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameText: UITextField!    
    @IBOutlet var descriptionText: UITextView!
    @IBOutlet var contactNameText: UITextField!
    @IBOutlet var emailText: UITextField!
    @IBOutlet var telephoneText: UITextField!
    @IBOutlet var profileTypeText: UITextField!
    @IBOutlet var tagsText: UITextField!
    @IBOutlet var streetAddressText: UITextField!
    @IBOutlet var cityText: UITextField!
    @IBOutlet var stateText: UITextField!
    @IBOutlet var zipText: UITextField!
    @IBOutlet var countryText: UITextField!
    @IBOutlet var createDateText: UITextField!
    @IBOutlet var searchableText: UITextField!
    @IBOutlet var activeIndText: UITextField!
    @IBOutlet var groupsText: UITextField!
    
  //  @IBOutlet var profileImage: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var fromUserIdentityProfileId: String!
    
    var userProfileName = ""

    let JSONDATA = JsonGetData()
    let UTILITIES = Utilities()
    
    var firstName = ""
    var lastName = ""
    var contactName = ""
    var profileName = ""
    var descript = ""
    var imageUrl = ""
    var email = ""
    var profileType = ""
    var streetAddress = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var country = ""
    var telephone = ""
    var createDate = ""
    var tags = ""
    var searchable = ""
    var activeInd = ""
    
    var groups = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_wami_extended_info.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
        
        var image : UIImage = UIImage(named:"wami1.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton

        fromUserIdentityProfileId = "NA"
        let GET_PROFILE_DATA = UTILITIES.IP + "get_profile_data.php"
        JSONDATA.jsonGetData(getProfileData, url: GET_PROFILE_DATA, params: ["param1": identityProfileId, "param2": fromUserIdentityProfileId, "param3": userIdentityProfileId])
 
        usleep(100000)
        
        self.profileNameText.text = self.profileName
        self.descriptionText.text = self.descript
        self.contactNameText.text = self.contactName
        
        self.emailText.text = self.email
        var fieldWidth = (Float(self.email.utf16Count) * 8)
        var bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, emailText.frame.size.height - 6, CGFloat(fieldWidth), 1.0);
        bottomBorder.backgroundColor = UIColor.blueColor().CGColor
        emailText.layer.addSublayer(bottomBorder)
        
        self.telephoneText.text = self.telephone
        fieldWidth = (Float(self.telephone.utf16Count) * 8)
        bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, telephoneText.frame.size.height - 6, CGFloat(fieldWidth), 1.0);
        bottomBorder.backgroundColor = UIColor.blueColor().CGColor
        telephoneText.layer.addSublayer(bottomBorder)
        
        self.profileTypeText.text = self.profileType
        self.tagsText.text = self.tags
        self.streetAddressText.text = self.streetAddress
        self.cityText.text = self.city
        self.stateText.text = self.state
        self.zipText.text = self.zipcode
        self.countryText.text = self.country
        self.createDateText.text = self.createDate
        if (searchable == "1") {
            self.searchableText.text = "Yes"
        }
        else {
            self.searchableText.text = "No"
        }
        if (self.activeInd == "1") {
            self.activeIndText.text = "Active"
        }
        else {
            self.activeIndText.text = "Inactive"
        }
        
        var profileHeaderImage = UIImage(named: self.imageUrl) as UIImage?
        self.profileImageView.image = profileHeaderImage
        
        self.groupsText.text = self.groups
     }
 
    override func viewDidLayoutSubviews() {
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(300, 1100)
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
        switch result.value {
            case MFMailComposeResultCancelled.value:
                println("Mail cancelled")
            case MFMailComposeResultSaved.value:
                println("Mail saved")
            case MFMailComposeResultSent.value:
                println("Mail sent")
            case MFMailComposeResultFailed.value:
                println("Mail sent failure: %@", [error.localizedDescription])
            default:
                break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //Callback function - getProfileData
    func getProfileData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
            return
        }
        var jsonIndex = 0
        if let jsonGroups = jsonData["identity_profile_data"][0]["group_data"].array? {
            var numGroups = jsonGroups.count
            for index in 0...numGroups - 1 {
                var group = jsonData["identity_profile_data"][0]["group_data"][index]["group"].string!
                groups = groups + ", " + group
            }
            groups = groups.substringFromIndex(advance(groups.startIndex, 2))
            jsonIndex = 1
        }
        else {
            groups = ""
            jsonIndex = 0
        }
        profileName = jsonData["identity_profile_data"][jsonIndex]["profile_name"].string!
        descript = jsonData["identity_profile_data"][jsonIndex]["description"].string!
        firstName = jsonData["identity_profile_data"][jsonIndex]["first_name"].string!
        lastName = jsonData["identity_profile_data"][jsonIndex]["last_name"].string!
        email = jsonData["identity_profile_data"][jsonIndex]["email"].string!
        telephone = jsonData["identity_profile_data"][jsonIndex]["telephone"].string!
        profileType = jsonData["identity_profile_data"][jsonIndex]["profile_type"].string!
        tags = jsonData["identity_profile_data"][jsonIndex]["tags"].string!
        streetAddress = jsonData["identity_profile_data"][jsonIndex]["street_address"].string!
        city = jsonData["identity_profile_data"][jsonIndex]["city"].string!
        state = jsonData["identity_profile_data"][jsonIndex]["state"].string!
        zipcode = jsonData["identity_profile_data"][jsonIndex]["zipcode"].string!
        country = jsonData["identity_profile_data"][jsonIndex]["country"].string!
        createDate = jsonData["identity_profile_data"][jsonIndex]["create_date"].string!
        searchable = jsonData["identity_profile_data"][jsonIndex]["searchable"].string!
        activeInd = jsonData["identity_profile_data"][jsonIndex]["active_ind"].string!
        imageUrl = jsonData["identity_profile_data"][jsonIndex]["image_url"].string!

        self.contactName = firstName + " " + lastName
    }
    
    //Callback function - getProfileName
    func getProfileName (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            userProfileName = jsonData["profile_name"].string!
        }
    }
}


