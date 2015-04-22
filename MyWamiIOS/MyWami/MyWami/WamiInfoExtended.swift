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
   
    @IBOutlet var profileNameHdrTxt: UITextField!
    @IBOutlet var contactNameHdrTxt: UITextField!
    
    @IBAction func emailAction(sender: AnyObject) {
        let GET_PROFILE_NAME = UTILITIES.IP + "get_profile_name.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_NAME, params: ["param1": userIdentityProfileId])
        getProfileName(jsonData)
//        JSON_DATA.jsonGetData(getProfileName, url: GET_PROFILE_NAME, params: ["param1": userIdentityProfileId])
        
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
    
    @IBOutlet var profileNameText: UITextField!
    @IBOutlet var profileImageView: UIImageView!
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
    
    @IBOutlet var uiView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var fromUserIdentityProfileId: String!
    
    var userProfileName = ""

    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
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
    
    let menuView = UIView()
    var menuLine = UILabel()
    var segue = UIStoryboardSegue()

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
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton

        fromUserIdentityProfileId = "NA"
        let GET_PROFILE_DATA = UTILITIES.IP + "get_profile_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_DATA, params: ["param1": identityProfileId, "param2": fromUserIdentityProfileId, "param3": userIdentityProfileId])
        getProfileData(jsonData)
//        JSON_DATA.jsonGetData(getProfileData, url: GET_PROFILE_DATA, params: ["param1": identityProfileId, "param2": fromUserIdentityProfileId, "param3": userIdentityProfileId])
        
        self.profileNameHdrTxt.text = self.profileName
        self.contactNameHdrTxt.text = self.contactName
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // menu processing
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.5
        menuView.frame = CGRectMake(153, 70, 150, 128)
        uiView.addSubview(menuView)
 
        menu.toggleMenu(menuView)
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Transmit This Wami...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(0, 0, 145, 20)
        menuView.addSubview(transmitThisWamiBtn)
        
        var addToContactListBtn = menu.setMenuBtnAttributes("Add To Contact List...")
        addToContactListBtn.addTarget(self, action: "addToContactListAction", forControlEvents: UIControlEvents.TouchUpInside)
        addToContactListBtn.frame = CGRectMake(2, 25, 145, 20)
        menuView.addSubview(addToContactListBtn)
        
        var navigateToBtn = menu.setMenuBtnAttributes("Navigate To...")
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.frame = CGRectMake(-20, 50, 145, 20)
        menuView.addSubview(navigateToBtn)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-40, 75, 145, 20)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.frame = CGRectMake(-38, 100, 145, 20)
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        menuView.addSubview(logoutBtn)
 
        menuLine = menu.createMenuLine(0, length: 150)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(25, length: 150)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(50, length: 150)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(75, length: 150)
        menuView.addSubview(menuLine)
    }
    
    // menu options
    func addToContactListAction () {
        println("addToContact")
    }
    // Transmit profile
    var transmitProfileView = UIView()
    let transmitProfile = TransmitProfile()
    func transmitThisWamiAction () {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.addTarget(self, action: "closeTransmitProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        transmitBtn.addTarget(self, action: "transmit", forControlEvents: UIControlEvents.TouchUpInside)
        
        transmitProfileView = transmitProfile.transmitProfileDialog(transmitProfileView, closeBtn: closeBtn, transmitBtn: transmitBtn)
        
        view.addSubview(transmitProfileView)
        menu.toggleMenu(menuView)
    }
    func closeTransmitProfileDialog() {
        transmitProfileView.removeFromSuperview()
    }
    func transmit() {
        transmitProfile.transmit(userIdentityProfileId, identityProfileId: identityProfileId, numToTransmit: "1")
    }
    // Navigate to 
    var navigateToView = UIView()
    func navigateToAction () {
        let profileInfoBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        profileInfoBtn.addTarget(self, action: "gotoProfileInfo", forControlEvents: UIControlEvents.TouchUpInside)
        let profilerBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        profilerBtn.addTarget(self, action: "gotoProfiler", forControlEvents: UIControlEvents.TouchUpInside)
        let flashBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        flashBtn.addTarget(self, action: "gotoFlashAnnouncements", forControlEvents: UIControlEvents.TouchUpInside)
        let profileCollectionBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        profileCollectionBtn.addTarget(self, action: "gotoProfileCollection", forControlEvents: UIControlEvents.TouchUpInside)
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.addTarget(self, action: "closeNavigateTo", forControlEvents: UIControlEvents.TouchUpInside)
        
        menu.toggleMenu(menuView)
        
        let navigateTo = NavigateTo()
        navigateToView = navigateTo.navigateTo(navigateToView, closeBtn: closeBtn,
            profileInfoBtn: profileInfoBtn, profilerBtn: profilerBtn, flashBtn: flashBtn, profileCollectionBtn: profileCollectionBtn)
        
        view.addSubview(navigateToView)
    }
    func closeNavigateTo() {
        navigateToView.removeFromSuperview()
    }
    func gotoProfileCollection () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoProfiler () {
        performSegueWithIdentifier("showProfiler", sender: self)
        var svc = segue.destinationViewController as Profiler;
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
        navigateToView.removeFromSuperview()
    }
    func gotoFlashAnnouncements () {
        performSegueWithIdentifier("showProfiler", sender: self)
        performSegueWithIdentifier("show_flash", sender: self)
        var svc = segue.destinationViewController as Flash;
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
        navigateToView.removeFromSuperview()
    }
    func gotoProfileInfo () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[2] as UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    
    func homeAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as UIViewController, animated: true)
    }
    
    func logoutAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[0] as UIViewController, animated: true)
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.segue = segue
        if (segue.identifier == "showProfiler") {
            menuView.hidden = true
            var svc = segue.destinationViewController as Profiler;
            svc.identityProfileId = self.identityProfileId
            svc.userIdentityProfileId = self.userIdentityProfileId
            svc.imageUrl = self.imageUrl
            svc.profileName = self.profileName
            svc.firstName = self.firstName
            svc.lastName = self.lastName
        }
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
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
            return
        }
        var jsonIndex = 0
        retCode = jsonData["group_ret_code"]
        if retCode == 2 {
            var message = jsonData["group_message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionDefault)
            }
        }
        else {
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
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            userProfileName = jsonData["profile_name"].string!
        }
    }
}


