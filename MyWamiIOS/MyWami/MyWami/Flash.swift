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
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func createFlash() {
        var flashData = textView.text
        if flashData == "" || flashData == "New Flash up to 110 characters" {
            UTILITIES.alertMessage("Please enter a Flash message before saving", viewController: self)
            return
        }
        let INSERT_FLASH = UTILITIES.IP + "insert_flash.php"
        JSONDATA.jsonGetData(insertFlashData, url: INSERT_FLASH, params: ["param1": flashData, "param2": identityProfileId])
    }
    
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
    
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(157, 70, 150, 100)
        menuView.backgroundColor = UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 0.95)
        view.addSubview(menuView)
        
        let menu = Menu()
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
        
        menuLine = menu.createMenuLine(0)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(25)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(50)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(75)
        menuView.addSubview(menuLine)
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
    
    func numberOfSectionsInTableView(flashTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(flashTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numFlash
    }
    
    func tableView(flashTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = flashTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as FlashTableViewCell
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
                self.UTILITIES.alertMessage(message!, viewController: self)
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
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            getFlashData()
        }
    }
}


