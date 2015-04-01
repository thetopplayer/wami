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
    
    let menuView = UIView()
    let transmitThisWamiBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let addToContactListBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let navigateToBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let homeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let logoutBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var menuLine = UILabel()

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showMenu(sender: UIBarButtonItem) {
        toggleMenu(menuView)
        menuView.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuView.backgroundColor = UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 0.95)
        scrollView.addSubview(menuView)
        
        transmitThisWamiBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        transmitThisWamiBtn.setTitle("Transmit This Wami...", forState: UIControlState.Normal)
        transmitThisWamiBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitThisWamiBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        transmitThisWamiBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(transmitThisWamiBtn)
        
        addToContactListBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        addToContactListBtn.setTitle("Add To Contact List...", forState: UIControlState.Normal)
        addToContactListBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        addToContactListBtn.addTarget(self, action: "addToContactListAction", forControlEvents: UIControlEvents.TouchUpInside)
        addToContactListBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addToContactListBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        addToContactListBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(addToContactListBtn)
        
        navigateToBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        navigateToBtn.setTitle("Navigate To...", forState: UIControlState.Normal)
        navigateToBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        navigateToBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        navigateToBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(navigateToBtn)
        
        homeBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        homeBtn.setTitle("Home", forState: UIControlState.Normal)
        homeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        homeBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(homeBtn)
        
        logoutBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        logoutBtn.setTitle("Logout", forState: UIControlState.Normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logoutBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        logoutBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(logoutBtn)
        
        menuLine = createMenuLine(0)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(25)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(50)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(75)
        menuView.addSubview(menuLine)
        
        let viewsDictionary = ["menuView":menuView, "homeBtn":homeBtn, "transmitThisWamiBtn":transmitThisWamiBtn, "navigateToBtn":navigateToBtn,  "addToContactListBtn":addToContactListBtn, "logoutBtn":logoutBtn]
        
        //size of menu
        let menuView_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[menuView(170)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let menuView_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuView(>=128)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(menuView_constraint_H)
        menuView.addConstraints(menuView_constraint_V)
        
        //placement of menu
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-140-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-62-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        scrollView.addConstraints(view_constraint_H)
        scrollView.addConstraints(view_constraint_V)
        
        //placement of transmit button
        let transmit_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[transmitThisWamiBtn(>=80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let transmit_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[transmitThisWamiBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(transmit_constraint_H)
        menuView.addConstraints(transmit_constraint_V)
        
        //placement of add to contact button
        let addToContactList_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[addToContactListBtn(>=80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let addToContactList_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-23-[addToContactListBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(addToContactList_constraint_H)
        menuView.addConstraints(addToContactList_constraint_V)
        
        //placement of navigate to button
        let navigateTo_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[navigateToBtn(>=80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let navigateTo_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-48-[navigateToBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(navigateTo_constraint_H)
        menuView.addConstraints(navigateTo_constraint_V)
        
        //placement of home button
        let home_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[homeBtn(>=38)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let home_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-73-[homeBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(home_constraint_H)
        menuView.addConstraints(home_constraint_V)
        
        //placement of logout button
        let logout_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logoutBtn(>=45)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let logout_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-98-[logoutBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(logout_constraint_H)
        menuView.addConstraints(logout_constraint_V)
    }
    
    func toggleMenu (menuView: UIView) {
        if menuView.hidden {
            menuView.hidden = false
        }
        else {
            menuView.hidden = true
        }
    }
    
    func createMenuLine (offset: Int) -> UILabel {
        var line: UILabel = UILabel()
        line.frame = CGRectMake(0, CGFloat(25 + offset), 170, 1)
        line.backgroundColor = UIColor.grayColor()
        return line
    }
    
    func addToContactListAction () {
        println("addToContact")
    }
    
    func navigateToAction () {
        println("fnavigte to")
    }
    
    func transmitThisWamiAction () {
        println("transmit")
    }
    
    func homeAction () {
        println("home")
    }
    
    func logoutAction () {
        println("logout")
    }

    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfiler") {
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


