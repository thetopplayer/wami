//
//  Profiler.swift
//  MyWami
//
//  Created by Robert Lanter on 3/28/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class Profiler: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate  {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameText: UITextField!
    @IBOutlet var contactNameText: UITextField!
    @IBOutlet var profilerTableView: UITableView!
    
    // Process categories
    var mediaType = ""
    var category = ""
    @IBAction func categoryBtnPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.profilerTableView)
        var indexPath: NSIndexPath = self.profilerTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.category = categories[row]
        self.mediaType = mediaTypes[row]
        if mediaType == "Text" {
            var pdfFile = UTILITIES.ASSETS_IP + "assets/text_files/RobbieRedux/bio.txt"
            showWebViewer(pdfFile)
            
//            let webView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: pdfFile)!))
//            webView.delegate = self;
//            profilerTableView.addSubview(webView)
            
        }
        
        if mediaType == "PDF" {
            var pdfFile = UTILITIES.ASSETS_IP + "assets/pdf_files/RobbieRedux/RobLanter_res.pdf"
            showWebViewer(pdfFile)
//            let webView:UIWebView = UIWebView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
//            webView.loadRequest(NSURLRequest(URL: NSURL(string: pdfFile)!))
//            webView.delegate = self;
//            profilerTableView.addSubview(webView)
            
        }

        
        if mediaType == "Audio" {
            
        }
        
        if mediaType == "Image" {
            
        }
    }
    let webViewer = UIView()
    let webView = UIWebView()
    func showWebViewer (inFile: String) {
        webViewer.frame = CGRectMake(2, 2, 315, 385)
        webViewer.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        webViewer.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        webViewer.layer.borderWidth = 1.5
        
        webView.frame = CGRectMake(5, 0, 306, 332)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: inFile)!))
        webView.delegate = self;
        
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(125, 348, 60, 20)
        closeBtn.addTarget(self, action: "closeWebViewer", forControlEvents: UIControlEvents.TouchUpInside)
        webViewer.addSubview(closeBtn)

        
        webViewer.addSubview(webView)
        profilerTableView.addSubview(webViewer)
    }
    func closeWebViewer() {
        webViewer.removeFromSuperview()
    }
    
    let textCellIdentifier = "ProfilerTableViewCell"
    
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
   
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var imageUrl: String!
    var profileName: String!
    var firstName: String!
    var lastName: String!
    
    var numCategories = 0
    var categories = [String]()
    var mediaTypes = [String]()
    
    let menuView = UIView()
    var menuLine = UILabel()
    var segue = UIStoryboardSegue()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_profiler.png")
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
        
        let GET_PROFILER_DATA = UTILITIES.IP + "get_profiler_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILER_DATA, params: ["param1": identityProfileId])
        
        var retCode = jsonData["no_categories_ret_code"]
        if retCode == 1 {
            var message = jsonData["message"][0].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
            return
        }
        else {
            if let numCategories: Int! = jsonData["identity_profiler_data"].array?.count {
                self.numCategories = numCategories
                for index in 0...numCategories - 1 {
                    var categoryName = jsonData["identity_profiler_data"][index]["category"].string!
                    categories.append(categoryName)
                    var mediaType = jsonData["identity_profiler_data"][index]["media_type"].string!
                    mediaTypes.append(mediaType)
                }
            }
            else {
                self.numCategories = 0
            }
        }
        
        profilerTableView.dataSource = self
        profilerTableView.delegate = self
        self.profilerTableView.rowHeight = 44
    }
    
    // create menu
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(157, 70, 150, 105)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.0
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Transmit This Wami...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(2, 0, 145, 30)
        menuView.addSubview(transmitThisWamiBtn)
        
        var navigateToBtn = menu.setMenuBtnAttributes("Navigate To...")
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.frame = CGRectMake(-20, 25, 145, 30)
        menuView.addSubview(navigateToBtn)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-44, 50, 145, 30)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-40, 75, 145, 30)
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
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeTransmitProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
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
    func gotoFlashAnnouncements () {
        performSegueWithIdentifier("showFlash", sender: self)
        var svc = segue.destinationViewController as! Flash;
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
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
    func numberOfSectionsInTableView(profilerTableView: UITableView) -> Int {
        return 1
    }
    func tableView(profilerTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numCategories
    }
    func tableView(profilerTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = profilerTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ProfilerTableViewCell
        var category = self.categories[indexPath.row]
        cell.categoryBtn.setTitle(category, forState: UIControlState.Normal)
        
        return cell
    }
    func tableView(profilerTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        profilerTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.segue = segue
        if (segue.identifier == "showFlash") {
            menuView.hidden = true
            var svc = segue.destinationViewController as! Flash;
            svc.identityProfileId = self.identityProfileId
            svc.userIdentityProfileId = self.userIdentityProfileId
            svc.imageUrl = self.imageUrl
            svc.profileName = self.profileName
            svc.firstName = self.firstName
            svc.lastName = self.lastName
        }
    }
    
}





