//
//  WamiInfoExtended.swift
//  MyWami
//
//  Created by Robert Lanter on 3/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import MessageUI
import AddressBook

class WamiInfoExtended: UIViewController, MFMailComposeViewControllerDelegate {
   
    @IBOutlet var profileNameHdrTxt: UITextField!
    @IBOutlet var contactNameHdrTxt: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    @IBAction func addToContactsAction(sender: AnyObject) {
        addToContactListAction()
    }
    
    var profileNameText: UITextField!
    var descriptionText: UITextView!
    var contactNameText: UITextField!
    var emailText: UITextField!
    var telephoneText: UITextField!
    var profileTypeText: UITextField!
    var tagsText: UITextField!
    var streetAddressText: UITextField!
    var cityText: UITextField!
    var stateText: UITextField!
    var zipText: UITextField!
    var countryText: UITextField!
    var createDateText: UITextField!
    var searchableText: UITextField!
    var activeIndText: UITextField!
    var groupsText: UITextField!
    
    @IBOutlet var uiView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewTop: UIView!
    
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
    var showProfilerBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    
    var adbk : ABAddressBook?
    var authDone: Bool = false
    var replaceContact = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_wami_extended_info.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
        
        var backButtonView = UIView(frame: CGRectMake(0, 10, 55, 60))
        var backButtonImage = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButtonImage.setBackgroundImage(UIImage(named: "wami1.png"), forState: UIControlState.Normal)
        backButtonImage.frame = CGRectMake(-5, 15, 45, 25)
        backButtonImage.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        backButtonView.addSubview(backButtonImage)
        var backButtonHeading = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = backButtonHeading
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton

        fromUserIdentityProfileId = "NA"
        let GET_PROFILE_DATA = UTILITIES.IP + "get_profile_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_DATA, params: ["param1": identityProfileId, "param2": fromUserIdentityProfileId, "param3": userIdentityProfileId])
        getProfileData(jsonData)
        
        self.profileNameHdrTxt.text = self.profileName
        self.contactNameHdrTxt.text = self.contactName
        var profileHeaderImage = UIImage(named: self.imageUrl) as UIImage?
        self.profileImageView.image = profileHeaderImage
        
        var nextItem  = UIImage(named: "next_item_right")
        showProfilerBtn.setImage(nextItem, forState: .Normal)
        showProfilerBtn.showsTouchWhenHighlighted = true
        if DeviceType.IS_IPHONE_4_OR_LESS {
            showProfilerBtn.frame = CGRectMake(280, 110, 30, 30)
        }
        else if DeviceType.IS_IPHONE_5 {
            showProfilerBtn.frame = CGRectMake(280, 110, 30, 30)
        }
        else if DeviceType.IS_IPHONE_6 {
            showProfilerBtn.frame = CGRectMake(335, 110, 30, 30)
        }
        else if DeviceType.IS_IPHONE_6P {
            showProfilerBtn.frame = CGRectMake(375, 110, 30, 30)
        }
        else if DeviceType.IS_IPAD {
            showProfilerBtn.frame = CGRectMake(350, 110, 30, 30)
        }
        else {
            showProfilerBtn.frame = CGRectMake(350, 110, 30, 30)
        }
        showProfilerBtn.addTarget(self, action: "showProfiler", forControlEvents: UIControlEvents.TouchUpInside)
        viewTop.addSubview(showProfilerBtn)
     
        // Set extneded info values
        self.profileNameText = getTextField(self.profileName)
        self.contactNameText = getTextField(self.contactName)
        self.emailText = getTextField(self.email)
        self.emailText.addTarget(self, action: "emailAction", forControlEvents: UIControlEvents.EditingDidBegin)
        self.emailText.enabled = true
        self.emailText.textColor = UIColor.blueColor()
        
        self.telephoneText = getTextField(self.telephone)
        self.telephoneText.addTarget(self, action: "telephoneAction", forControlEvents: UIControlEvents.EditingDidBegin)
        self.telephoneText.enabled = true
        self.telephoneText.textColor = UIColor.blueColor()
        
        self.profileTypeText = getTextField(self.profileType)
        
        self.descriptionText = UITextView()
        self.descriptionText.backgroundColor = UIColor(red: 0xe0/255, green: 0xe0/255, blue: 0xe0/255, alpha: 1.0)
        self.descriptionText.textColor = UIColor.blackColor()
        self.descriptionText.font = UIFont.systemFontOfSize(13)
        self.descriptionText.editable = false
        self.descriptionText.text = self.descript
        
        self.tagsText = getTextField(self.tags)
        self.groupsText = getTextField(self.groups)
        self.createDateText = getTextField(self.createDate)
        if (self.searchable == "1") {
            self.searchableText = getTextField("Yes")
        }
        else {
            self.searchableText = getTextField("No")
        }
        if (self.activeInd == "1") {
            self.activeIndText = getTextField("Active")
        }
        else {
            self.activeIndText = getTextField("Inactive")
        }
        self.streetAddressText = getTextField(self.streetAddress)
        self.cityText = getTextField(self.city)
        self.stateText = getTextField(self.state)
        self.zipText = getTextField(self.zipcode)
        self.countryText = getTextField(self.country)
    
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.profileNameText.frame = CGRectMake(12, 30, 295, 23)
            self.contactNameText.frame = CGRectMake(12, 75, 295, 23)
            self.emailText.frame = CGRectMake(12, 120, 295, 23)
            self.telephoneText.frame = CGRectMake(12, 161, 295, 23)
            self.profileTypeText.frame = CGRectMake(12, 204, 295, 23)
            self.descriptionText.frame = CGRectMake(12, 250, 295, 47)
            self.tagsText.frame = CGRectMake(12, 318, 295, 23)
            self.groupsText.frame = CGRectMake(12, 357, 295, 23)
            self.createDateText.frame = CGRectMake(12, 401, 295, 23)
            self.searchableText.frame = CGRectMake(12, 445, 295, 23)
            self.activeIndText.frame = CGRectMake(12, 488, 295, 23)
            self.streetAddressText.frame = CGRectMake(12, 530, 295, 23)
            self.cityText.frame = CGRectMake(12, 576, 295, 23)
            self.stateText.frame = CGRectMake(12, 621, 295, 23)
            self.zipText.frame = CGRectMake(12, 665, 295, 23)
            self.countryText.frame = CGRectMake(12, 708, 295, 23)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.profileNameText.frame = CGRectMake(12, 30, 300, 23)
            self.contactNameText.frame = CGRectMake(12, 75, 300, 23)
            self.emailText.frame = CGRectMake(12, 120, 300, 23)
            self.telephoneText.frame = CGRectMake(12, 161, 300, 23)
            self.profileTypeText.frame = CGRectMake(12, 204, 300, 23)
            self.descriptionText.frame = CGRectMake(12, 250, 300, 47)
            self.tagsText.frame = CGRectMake(12, 318, 300, 23)
            self.groupsText.frame = CGRectMake(12, 357, 300, 23)
            self.createDateText.frame = CGRectMake(12, 401, 300, 23)
            self.searchableText.frame = CGRectMake(12, 445, 300, 23)
            self.activeIndText.frame = CGRectMake(12, 488, 300, 23)
            self.streetAddressText.frame = CGRectMake(12, 530, 300, 23)
            self.cityText.frame = CGRectMake(12, 576, 300, 23)
            self.stateText.frame = CGRectMake(12, 621, 300, 23)
            self.zipText.frame = CGRectMake(12, 665, 300, 23)
            self.countryText.frame = CGRectMake(12, 708, 300, 23)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.profileNameText.frame = CGRectMake(12, 30, 355, 23)
            self.contactNameText.frame = CGRectMake(12, 75, 355, 23)
            self.emailText.frame = CGRectMake(12, 120, 355, 23)
            self.telephoneText.frame = CGRectMake(12, 161, 355, 23)
            self.profileTypeText.frame = CGRectMake(12, 204, 355, 23)
            self.descriptionText.frame = CGRectMake(12, 250, 355, 47)
            self.tagsText.frame = CGRectMake(12, 318, 355, 23)
            self.groupsText.frame = CGRectMake(12, 357, 355, 23)
            self.createDateText.frame = CGRectMake(12, 401, 355, 23)
            self.searchableText.frame = CGRectMake(12, 445, 355, 23)
            self.activeIndText.frame = CGRectMake(12, 488, 355, 23)
            self.streetAddressText.frame = CGRectMake(12, 530, 355, 23)
            self.cityText.frame = CGRectMake(12, 576, 355, 23)
            self.stateText.frame = CGRectMake(12, 621, 355, 23)
            self.zipText.frame = CGRectMake(12, 665, 355, 23)
            self.countryText.frame = CGRectMake(12, 708, 355, 23)

        }
        else if DeviceType.IS_IPHONE_6P {
            self.profileNameText.frame = CGRectMake(12, 30, 390, 23)
            self.contactNameText.frame = CGRectMake(12, 75, 390, 23)
            self.emailText.frame = CGRectMake(12, 120, 390, 23)
            self.telephoneText.frame = CGRectMake(12, 161, 390, 23)
            self.profileTypeText.frame = CGRectMake(12, 204, 390, 23)
            self.descriptionText.frame = CGRectMake(12, 250, 390, 47)
            self.tagsText.frame = CGRectMake(12, 318, 390, 23)
            self.groupsText.frame = CGRectMake(12, 357, 390, 23)
            self.createDateText.frame = CGRectMake(12, 401, 390, 23)
            self.searchableText.frame = CGRectMake(12, 445, 390, 23)
            self.activeIndText.frame = CGRectMake(12, 488, 390, 23)
            self.streetAddressText.frame = CGRectMake(12, 530, 390, 23)
            self.cityText.frame = CGRectMake(12, 576, 390, 23)
            self.stateText.frame = CGRectMake(12, 621, 390, 23)
            self.zipText.frame = CGRectMake(12, 665, 390, 23)
            self.countryText.frame = CGRectMake(12, 708, 390, 23)
        }
        else if DeviceType.IS_IPAD {
            self.profileNameText.frame = CGRectMake(340, 108, 30, 30)
        }
        else {
            self.profileNameText.frame = CGRectMake(282, 108, 30, 30)
        }
        scrollView.addSubview(profileNameText)
        scrollView.addSubview(contactNameText)
        scrollView.addSubview(emailText)
        scrollView.addSubview(telephoneText)
        scrollView.addSubview(profileTypeText)
        scrollView.addSubview(descriptionText)
        scrollView.addSubview(tagsText)
        scrollView.addSubview(groupsText)
        scrollView.addSubview(createDateText)
        scrollView.addSubview(searchableText)
        scrollView.addSubview(activeIndText)
        scrollView.addSubview(streetAddressText)
        scrollView.addSubview(cityText)
        scrollView.addSubview(stateText)
        scrollView.addSubview(zipText)
        scrollView.addSubview(countryText)

        viewTop.frame = CGRectMake(0, 0, 310, 140);
        uiView.addSubview(viewTop)
     }
    
    func getTextField(txtVal: String) -> UITextField{
        var txtFld = UITextField()
        txtFld.backgroundColor = UIColor(red: 0xe0/255, green: 0xe0/255, blue: 0xe0/255, alpha: 1.0)
        txtFld.textColor = UIColor.blackColor()
        txtFld.font = UIFont.systemFontOfSize(13)
        txtFld.enabled = false
        txtFld.text = txtVal
        
        return txtFld
    }
    
    func telephoneAction() {
        var url:NSURL = NSURL(string: telephone)!
        UIApplication.sharedApplication().openURL(url)
    }

    func emailAction() {
        let GET_PROFILE_NAME = UTILITIES.IP + "get_profile_name.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_NAME, params: ["param1": userIdentityProfileId])
        getProfileName(jsonData)
        
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
    
    func showProfiler() {
        menuView.hidden = true
        performSegueWithIdentifier("showProfiler", sender: nil)
        var svc = segue.destinationViewController as! Profiler;
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.scrollEnabled = true
        scrollView.contentSize = CGSizeMake(300, 1500)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // menu processing
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.backgroundColor = UIColor(red: 0x61/255, green: 0x61/255, blue: 0x61/255, alpha: 0.90)
        menuView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.cornerRadius = 6.0 
        menuView.layer.borderWidth = 1.0
        menuView.frame = CGRectMake(153, 70, 150, 133)
        uiView.addSubview(menuView)
 
        menu.toggleMenu(menuView)
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Publish This Profile...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(-2, 0, 145, 30)
        menuView.addSubview(transmitThisWamiBtn)
        
        var addToContactListBtn = menu.setMenuBtnAttributes("Add To Contact List...")
        addToContactListBtn.addTarget(self, action: "addToContactListAction", forControlEvents: UIControlEvents.TouchUpInside)
        addToContactListBtn.frame = CGRectMake(2, 25, 145, 30)
        menuView.addSubview(addToContactListBtn)
        
        var navigateToBtn = menu.setMenuBtnAttributes("Navigate To...")
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.frame = CGRectMake(-22, 50, 145, 30)
        menuView.addSubview(navigateToBtn)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-45, 75, 145, 30)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.frame = CGRectMake(-42, 100, 145, 30)
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
    
    var processAddressBook: ProcessAddressBook!
    func cancelContactAction(alertController: UIAlertAction!) {
        return
    }
    func replaceContactAction(alertController: UIAlertAction!) {
        self.replaceContact = true
        self.processAddressBook.addToContactListAction(firstName, lastName: lastName, telephone: telephone, email: email,
            streetAddress: streetAddress, city: city, state: state, zipcode: zipcode, country: country, replaceContact: replaceContact)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.view.makeToast(message: "Contact replaced in Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    func addContactAction(alertController: UIAlertAction!) {
        self.replaceContact = false
        self.processAddressBook.addToContactListAction(firstName, lastName: lastName, telephone: telephone, email: email,
            streetAddress: streetAddress, city: city, state: state, zipcode: zipcode, country: country, replaceContact: replaceContact)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.view.makeToast(message: "Contact added to Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    func addToContactListAction () {
        self.processAddressBook = ProcessAddressBook()
        var auth = processAddressBook.getAuthorization()
        menu.toggleMenu(menuView)
        if auth {
            processAddressBook.initialize()
            var exist = processAddressBook.checkForExist(firstName, lastName: lastName)
            if exist == 2 {
                return
            }
            if exist == 0 {
                var alertController = UIAlertController(title: "Alert!", message: "Contact Already Exists In Address Book", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: addContactAction))
                alertController.addAction(UIAlertAction(title: "Replace", style: UIAlertActionStyle.Default, handler: replaceContactAction))
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelContactAction))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                processAddressBook.addToContactListAction(firstName, lastName: lastName, telephone: telephone, email: email,
                    streetAddress: streetAddress, city: city, state: state, zipcode: zipcode, country: country, replaceContact: replaceContact)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.view.makeToast(message: "Contact added to Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                }
            }
        }
        else {
            self.view.makeToast(message: "Access to Contact List not authorized!", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }
    
    // Transmit profile
    var transmitProfileView = UIView()
    let transmitProfile = TransmitProfile()
    func transmitThisWamiAction () {
        var verticalPos: CGFloat = 0
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeTransmitProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        transmitBtn.addTarget(self, action: "transmit", forControlEvents: UIControlEvents.TouchUpInside)
        transmitProfileView = transmitProfile.transmitProfileDialog(transmitProfileView, closeBtn: closeBtn, transmitBtn: transmitBtn, verticalPos: verticalPos)
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
        let profileInfoBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        profileInfoBtn.addTarget(self, action: "gotoProfileInfo", forControlEvents: UIControlEvents.TouchUpInside)
        let profilerBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        profilerBtn.addTarget(self, action: "gotoProfiler", forControlEvents: UIControlEvents.TouchUpInside)
        let flashBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        flashBtn.addTarget(self, action: "gotoFlashAnnouncements", forControlEvents: UIControlEvents.TouchUpInside)
        let profileCollectionBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        profileCollectionBtn.addTarget(self, action: "gotoProfileCollection", forControlEvents: UIControlEvents.TouchUpInside)
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
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
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoProfiler () {
        performSegueWithIdentifier("showProfiler", sender: self)
        var svc = segue.destinationViewController as! Profiler
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
        var svc = segue.destinationViewController as! Flash
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
        navigateToView.removeFromSuperview()
    }
    func gotoProfileInfo () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[2] as! UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    
    func homeAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
    }
    
    func logoutAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[0] as! UIViewController, animated: true)
    }
    
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.segue = segue
        if (segue.identifier == "showProfiler") {
            menuView.hidden = true
            var svc = segue.destinationViewController as! Profiler
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
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            if let jsonGroups = jsonData["identity_profile_data"][0]["group_data"].array {
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
        if let descript = jsonData["identity_profile_data"][jsonIndex]["description"].string {
            self.descript = jsonData["identity_profile_data"][jsonIndex]["description"].string!
        }
        else {
            descript = ""
        }
        if let telephone = jsonData["identity_profile_data"][jsonIndex]["telephone"].string {
            self.telephone = jsonData["identity_profile_data"][jsonIndex]["telephone"].string!
        }
        else {
            telephone = ""
        }
        if let lastName = jsonData["identity_profile_data"][jsonIndex]["last_name"].string {
            self.lastName = jsonData["identity_profile_data"][jsonIndex]["last_name"].string!
        }
        else {
            lastName = ""
        }
        if let firstName = jsonData["identity_profile_data"][jsonIndex]["first_name"].string {
            self.firstName = jsonData["identity_profile_data"][jsonIndex]["first_name"].string!
        }
        else {
            firstName = ""
        }
        email = jsonData["identity_profile_data"][jsonIndex]["email"].string!
        
        if let telephone = jsonData["identity_profile_data"][jsonIndex]["telephone"].string {
            self.telephone = jsonData["identity_profile_data"][jsonIndex]["telephone"].string!
        }
        else {
            telephone = ""
        }
        if let profileType = jsonData["identity_profile_data"][jsonIndex]["profile_type"].string {
            self.profileType = jsonData["identity_profile_data"][jsonIndex]["profile_type"].string!
        }
        else {
            profileType = ""
        }
        if let tags = jsonData["identity_profile_data"][jsonIndex]["tags"].string {
            self.tags = jsonData["identity_profile_data"][jsonIndex]["tags"].string!
        }
        else {
            tags = ""
        }
        if let streetAddress = jsonData["identity_profile_data"][jsonIndex]["street_address"].string {
            self.streetAddress = jsonData["identity_profile_data"][jsonIndex]["street_address"].string!
        }
        else {
            streetAddress = ""
        }
        if let city = jsonData["identity_profile_data"][jsonIndex]["city"].string {
            self.city = jsonData["identity_profile_data"][jsonIndex]["city"].string!
        }
        else {
            city = ""
        }
        if let state = jsonData["identity_profile_data"][jsonIndex]["state"].string {
            self.state = jsonData["identity_profile_data"][jsonIndex]["state"].string!
        }
        else {
            state = ""
        }
        if let zipcode = jsonData["identity_profile_data"][jsonIndex]["zipcode"].string {
            self.zipcode = jsonData["identity_profile_data"][jsonIndex]["zipcode"].string!
        }
        else {
            zipcode = ""
        }
        if let country = jsonData["identity_profile_data"][jsonIndex]["country"].string {
            self.country = jsonData["identity_profile_data"][jsonIndex]["country"].string!
        }
        else {
            country = ""
        }
        createDate = jsonData["identity_profile_data"][jsonIndex]["create_date"].string!
        searchable = jsonData["identity_profile_data"][jsonIndex]["searchable"].string!
        activeInd = jsonData["identity_profile_data"][jsonIndex]["active_ind"].string!
        if let imageUrl = jsonData["identity_profile_data"][jsonIndex]["image_url"].string {
            self.imageUrl = jsonData["identity_profile_data"][jsonIndex]["image_url"].string!
        }
        else {
            imageUrl = ""
        }

        self.contactName = firstName + " " + lastName
    }
    
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


