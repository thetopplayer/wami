//
//  WamiInfoExtended.swift
//  MyWami
//
//  Created by Robert Lanter on 3/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import CoreGraphics

class WamiInfoExtended: UIViewController {
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
    
  //  @IBOutlet var telephoneText: UIButton!
    
    @IBOutlet var profileImage: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var fromUserIdentityProfileId: String!

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
    var groups = ""
    var searchable = ""
    var activeInd = ""

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
        
        let url = NSURL(string: "mailto:\(self.email)")
        UIApplication.sharedApplication().openURL(url!)
        
        
        self.telephoneText.text = self.telephone
        
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
        profileImage   = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        profileImage.frame = CGRectMake(50, 70, 130, 100)
        profileImage.setImage(profileHeaderImage, forState: .Normal)
        self.view.addSubview(profileImage)
        
        //            self.groupsText.text =
    
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.scrollEnabled = true
        // Do any additional setup after loading the view
        scrollView.contentSize = CGSizeMake(300, 1100)
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Callback function - getProfileData
    func getProfileData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            profileName = jsonData["identity_profile_data"][1]["profile_name"].string!
            descript = jsonData["identity_profile_data"][1]["description"].string!
            firstName = jsonData["identity_profile_data"][1]["first_name"].string!
            lastName = jsonData["identity_profile_data"][1]["last_name"].string!
            email = jsonData["identity_profile_data"][1]["email"].string!
            telephone = jsonData["identity_profile_data"][1]["telephone"].string!
            profileType = jsonData["identity_profile_data"][1]["profile_type"].string!
            tags = jsonData["identity_profile_data"][1]["tags"].string!
            streetAddress = jsonData["identity_profile_data"][1]["street_address"].string!
            city = jsonData["identity_profile_data"][1]["city"].string!
            state = jsonData["identity_profile_data"][1]["state"].string!
            zipcode = jsonData["identity_profile_data"][1]["zipcode"].string!
            country = jsonData["identity_profile_data"][1]["country"].string!
            createDate = jsonData["identity_profile_data"][1]["create_date"].string!
            searchable = jsonData["identity_profile_data"][1]["searchable"].string!
            activeInd = jsonData["identity_profile_data"][1]["active_ind"].string!
            imageUrl = jsonData["identity_profile_data"][1]["image_url"].string!

            self.contactName = firstName + " " + lastName
        }
    }
}