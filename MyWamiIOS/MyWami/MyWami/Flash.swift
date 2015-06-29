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
    
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
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
    @IBOutlet var newFlashButton: UIButton!
    
    @IBAction func refreshFlashBtnPressed(sender: AnyObject) {
        getFlashData()
    }
    
    // new flash btn
    var newFlashView = UIView()
    var textView = UITextView()
    let flashAnnouncement = FlashAnnouncement()
    @IBAction func newFlashButtonPressed(sender: AnyObject) {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeNewFlashDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let createBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        createBtn.addTarget(self, action: "createNewFlash", forControlEvents: UIControlEvents.TouchUpInside)
        newFlashView = flashAnnouncement.flashDialog(newFlashView, textView: textView, closeBtn: closeBtn, createBtn: createBtn)
        view.addSubview(newFlashView)
    }
    // create button processing
    func createNewFlash() {
        var flashData = textView.text
        if flashData == "" || flashData == "New Flash up to 110 characters" {
            self.view.makeToast(message: "Please enter a Flash message before creating", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        let INSERT_FLASH = UTILITIES.IP + "insert_flash.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(INSERT_FLASH, params: ["param1": flashData, "param2": identityProfileId])
        insertFlashData(jsonData)
    }
    // close button processing
    func closeNewFlashDialog() {
        newFlashView.removeFromSuperview()
    }
    
    var flashTableView: UITableView = UITableView()
    var flashScrollView = UIScrollView()
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

        self.profileNameText.text = self.profileName
        self.contactNameText.text = self.firstName + " " + self.lastName
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            flashScrollView.frame = CGRectMake(1, 186, 319, 294)
            flashTableView.frame = CGRectMake(2, 4, 315, 287)
            flashTableView.rowHeight = 25
        }
        else if DeviceType.IS_IPHONE_5 {
            flashScrollView.frame = CGRectMake(1, 186, 319, 381)
            flashTableView.frame = CGRectMake(2, 4, 315, 374)
            flashTableView.rowHeight = 25
        }
        else if DeviceType.IS_IPHONE_6 {
            flashScrollView.frame = CGRectMake(1, 186, 373, 480)
            flashTableView.frame = CGRectMake(2, 4, 369, 477)
            flashTableView.rowHeight = 25
        }
        else if DeviceType.IS_IPHONE_6P {
            flashScrollView.frame = CGRectMake(1, 186, 413, 549)
            flashTableView.frame = CGRectMake(2, 4, 409, 546)
            flashTableView.rowHeight = 25
        }
        else if DeviceType.IS_IPAD {
            flashScrollView.frame = CGRectMake(1, 186, 319, 381)
            flashTableView.frame = CGRectMake(2, 4, 315, 374)
        }
        else {
            flashScrollView.frame = CGRectMake(1, 186, 319, 381)
            flashTableView.frame = CGRectMake(2, 4, 315, 374)
        }
        
        flashScrollView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        flashScrollView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        flashScrollView.layer.borderWidth = 1.5
        
        flashTableView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        flashTableView.layer.borderWidth = 1.0
        flashTableView.delegate = self
        flashTableView.dataSource = self
        flashTableView.registerClass(FlashTableViewCell.self, forCellReuseIdentifier: "FlashTableViewCell")
        flashScrollView.addSubview(flashTableView)
        
        view.addSubview(flashScrollView)
        
        if userIdentityProfileId != identityProfileId {
            newFlashButton.hidden = true
        }
        
        getFlashData()
     }
    
    // create menu
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(157, 70, 150, 105)
        menuView.layer.cornerRadius = 6.0 
        menuView.backgroundColor = UIColor(red: 0x61/255, green: 0x61/255, blue: 0x61/255, alpha: 0.90)
        menuView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.0
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Publish This Wami...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(-2, 0, 145, 30)
        menuView.addSubview(transmitThisWamiBtn)
        
        var navigateToBtn = menu.setMenuBtnAttributes("Navigate To...")
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.frame = CGRectMake(-21, 25, 145, 30)
        menuView.addSubview(navigateToBtn)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-44, 50, 145, 30)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-41, 75, 145, 30)
        menuView.addSubview(logoutBtn)
        
        menuLine = menu.createMenuLine(0, length: 150)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(25, length: 150)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(50, length: 150)
        menuView.addSubview(menuLine)
    }
    
    // menu options
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
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoFlashAnnouncements () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[4] as! UIViewController, animated: true)
        navigateToView.removeFromSuperview()
    }
    func gotoProfiler () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[3] as! UIViewController, animated: true)
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
    
    
    // table cell processing
    func numberOfSectionsInTableView(flashTableView: UITableView) -> Int {
        return 1
    }
    func tableView(flashTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numFlash
    }
    func tableView(flashTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = flashTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! FlashTableViewCell
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
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_FLASH_DATA, params: ["param1": identityProfileId])
        getFlashJsonData(jsonData)
    }
    
    func getFlashJsonData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
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
        self.flashTableView.reloadData()
    }
    
    func insertFlashData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            getFlashData()
        }
    }
}


