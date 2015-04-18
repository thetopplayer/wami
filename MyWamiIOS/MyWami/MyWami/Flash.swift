//
//  Flash.swift
//  MyWami
//
//  Created by Robert Lanter on 4/2/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class Flash: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate  {
    let textCellIdentifier = "FlashTableViewCell"
    
    let JSONDATA = JsonGetData()
    let UTILITIES = Utilities()
    
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var imageUrl: String!
    var profileName: String!
    var firstName: String!
    var lastName: String!
    
    var numFlash = 0
    var flashes = [String]()
    var createDates = [String]()
    
    let menuView = UIView()
    var menuLine = UILabel()
    
    @IBOutlet var profileNameText: UITextField!
    @IBOutlet var contactNameText: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var flashTableView: UITableView!
    
    @IBAction func refreshFlashBtnPressed(sender: AnyObject) {
        getFlashData()
    }
    
    // new flash btn
    let newFlashView = UIView()
    var textView = UITextView()
    @IBAction func newFlashButtonPressed(sender: AnyObject) {
        newFlashView.frame = CGRectMake(45, 200, 240, 230)
        newFlashView.backgroundColor = UIColor(red: 0xfc/255, green: 0xfc/255, blue: 0xfc/255, alpha: 1.0)
        newFlashView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        newFlashView.layer.borderWidth = 1.5
        
        let headingLbl = UILabel()
        headingLbl.backgroundColor = UIColor.blackColor()
        headingLbl.textAlignment = NSTextAlignment.Center
        headingLbl.text = "New Flash Anncouncement"
        headingLbl.textColor = UIColor.whiteColor()
        headingLbl.font = UIFont.boldSystemFontOfSize(13)
        headingLbl.frame = CGRectMake(0, 0, 240, 30)
        newFlashView.addSubview(headingLbl)
        
        textView.font = UIFont.systemFontOfSize(12)
        textView.textAlignment = .Left
        textView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        textView.layer.borderWidth = 0.5
        textView.frame = CGRectMake(20, 40, 200, 120)
        
        textView.text = "New Flash up to 110 characters"
        textView.textColor = UIColor.lightGrayColor()
        textView.delegate = self
        newFlashView.addSubview(textView)
        
        let createBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        createBtn.setTitle("Create", forState: UIControlState.Normal)
        createBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        createBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        createBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        createBtn.showsTouchWhenHighlighted = true
        createBtn.addTarget(self, action: "createFlash", forControlEvents: UIControlEvents.TouchUpInside)
        createBtn.frame = CGRectMake(45, 180, 60, 25)
        newFlashView.addSubview(createBtn)
        
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.addTarget(self, action: "closeNewFlash", forControlEvents: UIControlEvents.TouchUpInside)
        closeBtn.frame = CGRectMake(135, 180, 60, 25)
        newFlashView.addSubview(closeBtn)
        
        view.addSubview(newFlashView)
    }
    // used for text view placeholder
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    // limit number of chars in flash msg
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if countElements(textView.text) > 109 {
//            UTILITIES.alertMessage("Only 110 characters allowed.", viewController: self)
            self.view.makeToast(message: "Only 110 characters allowed.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            textView.text = textView.text.substringToIndex(advance(textView.text.startIndex, countElements(textView.text) - 1))
        }
        return true
    }
    // create button processing
    func createFlash() {
        var flashData = textView.text
        if flashData == "" || flashData == "New Flash up to 110 characters" {
//            UTILITIES.alertMessage("Please enter a Flash message before saving", viewController: self)
            self.view.makeToast(message: "Please enter a Flash message before creating", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        let INSERT_FLASH = UTILITIES.IP + "insert_flash.php"
        JSONDATA.jsonGetData(insertFlashData, url: INSERT_FLASH, params: ["param1": flashData, "param2": identityProfileId])
    }
    // close button processing
    func closeNewFlash() {
        newFlashView.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_flash.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
        
        var image : UIImage = UIImage(named:"wami1.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton
        
        var profileHeaderImage = UIImage(named: self.imageUrl) as UIImage?
        self.profileImageView.image = profileHeaderImage
        
        getFlashData()

        self.profileNameText.text = self.profileName
        self.contactNameText.text = self.firstName + " " + self.lastName
        
        flashTableView.dataSource = self
        flashTableView.delegate = self
        self.flashTableView.rowHeight = 25
     }
    
    // create menu
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(157, 70, 150, 100)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.5
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Transmit This Wami...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(0, 0, 145, 20)
        menuView.addSubview(transmitThisWamiBtn)
        
        var navigateToBtn = menu.setMenuBtnAttributes("Navigate To...")
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.frame = CGRectMake(-20, 25, 145, 20)
        menuView.addSubview(navigateToBtn)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-40, 50, 145, 20)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-38, 75, 145, 20)
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
    var transmitProfileView = UIView()
    let transmitProfile = TransmitProfile()
    func transmitThisWamiAction () {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        closeBtn.addTarget(self, action: "closeTransmitProfile", forControlEvents: UIControlEvents.TouchUpInside)
        let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
        transmitBtn.addTarget(self, action: "transmit", forControlEvents: UIControlEvents.TouchUpInside)
        
        transmitProfileView = transmitProfile.transmitProfile(transmitProfileView, closeBtn: closeBtn, transmitBtn: transmitBtn)
        
        view.addSubview(transmitProfileView)
        menu.toggleMenu(menuView)
    }
    func closeTransmitProfile() {
        transmitProfileView.removeFromSuperview()
    }
    func transmit() {
        transmitProfile.transmit(userIdentityProfileId, identityProfileId: identityProfileId, numToTransmit: "1")
    }
    
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
        
        let navigateTo = NavigateTo()
        navigateToView = navigateTo.navigateTo(navigateToView, closeBtn: closeBtn,
            profileInfoBtn: profileInfoBtn, profilerBtn: profilerBtn, flashBtn: flashBtn, profileCollectionBtn: profileCollectionBtn)
        
        view.addSubview(navigateToView)
        menu.toggleMenu(menuView)
    }
    func closeNavigateTo() {
        navigateToView.removeFromSuperview()
    }
    func gotoProfileCollection () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoFlashAnnouncements () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[4] as UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoProfiler () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[3] as UIViewController, animated: true)
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
    
    
    // table cell processing
    func numberOfSectionsInTableView(flashTableView: UITableView) -> Int {
        return 1
    }
    func tableView(flashTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numFlash
    }
    func tableView(flashTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = flashTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as FlashTableViewCell
        cell.flashText.text = self.flashes[indexPath.row]
        cell.createDateText.text = self.createDates[indexPath.row]
        return cell
    }
    func tableView(flashTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        flashTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // data processing
    func getFlashData() {
        let GET_PROFILE_FLASH_DATA = UTILITIES.IP + "get_profile_flash_data.php"
        JSONDATA.jsonGetData(getFlashJsonData, url: GET_PROFILE_FLASH_DATA, params: ["param1": identityProfileId])
        self.flashTableView.reloadData()
    }
    
    //Callback function - getFlashJsonData
    func getFlashJsonData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
//                self.UTILITIES.alertMessage(message!, viewController: self)
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            flashes.removeAll(keepCapacity: false)
            let numFlash: Int! = jsonData["profile_flash_data"].array?.count
            self.numFlash = numFlash
            for index in 0...numFlash - 1 {
                var flash = jsonData["profile_flash_data"][index]["flash"].string!
                flashes.append(flash)
                var createDate = jsonData["profile_flash_data"][index]["create_date"].string!
                createDates.append(createDate)
            }
        }
    }
    
    //Callback function - insertFlashData
    func insertFlashData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
//                self.UTILITIES.alertMessage(message!, viewController: self)
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            getFlashData()
        }
    }
}


