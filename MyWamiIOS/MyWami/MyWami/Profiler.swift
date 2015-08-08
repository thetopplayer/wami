//
//  Profiler.swift
//  MyWami
//
//  Created by Robert Lanter on 3/28/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import AVFoundation

class Profiler: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, AVAudioPlayerDelegate  {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileNameText: UITextField!
    @IBOutlet var contactNameText: UITextField!
    @IBOutlet var headerView: UIView!
    
    // Process categories
    var mediaType = ""
    var category = ""
    var fileName = ""
    var fileLocation = ""
    var player = AVPlayer()
    
    var sender = UIButton()
    func categoryBtnPressed(sender: UIButton) {
        self.sender = sender
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.profilerTableView)
        var indexPath: NSIndexPath = self.profilerTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.category = categories[row]
        self.mediaType = mediaTypes[row]
        if mediaType == "Text" {
            self.fileName = fileNames[row]
            self.fileLocation = fileLocations[row]
            var txtFile = UTILITIES.ASSETS_IP +  fileLocation + fileName
            showInWebViewer(txtFile)
        }
        if mediaType == "PDF" {
            self.fileName = fileNames[row]
            self.fileLocation = fileLocations[row]
            var pdfFile = UTILITIES.ASSETS_IP +  fileLocation + fileName
            showInWebViewer(pdfFile)
        }
        if mediaType == "Audio" {
            showAudioViewer()
        }
        if mediaType == "Image" {
            showImageViewer()
        }
    }
    
    var profilerAudioViewer = ProfilerAudioViewer()
    var profilerAudioViewerDialog = UIView()
    func showAudioViewer () {
        var profilerAudioView = UIScrollView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        var audioProfilerModelsSubset = [AudioProfilerModel]()
        var numItems = audioProfilerModels.count
        var categoryFromModel = ""
        for index in 0...numItems - 1 {
            categoryFromModel = audioProfilerModels[index].getAudioCategory()
            if (categoryFromModel == self.category) {
                audioProfilerModelsSubset.append(audioProfilerModels[index])
            }
            
        }
        closeBtn.addTarget(self, action: "closeProfilerAudioViewerDialog", forControlEvents: UIControlEvents.TouchUpInside)
        self.profilerAudioViewerDialog = profilerAudioViewer.profilerAudioViewerDialog(profilerAudioView, audioProfilerModels: audioProfilerModelsSubset, closeBtn: closeBtn)
        profilerTableView.addSubview(self.profilerAudioViewerDialog)

    }
    func closeProfilerAudioViewerDialog() {
        self.profilerAudioViewerDialog.removeFromSuperview()
    }
    
    var profilerImageViewer = ProfilerImageViewer()
    var profilerImageViewerDialog = UIView()
    func showImageViewer() {
        var imageScrollView = UIScrollView()
        var closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        var imageProfilerModelsSubset = [ImageProfilerModel]()
        var numItems = imageProfilerModels.count
        var categoryFromModel = ""
        for index in 0...numItems - 1 {
            categoryFromModel = imageProfilerModels[index].getImageCategory()
            if (categoryFromModel == self.category) {
                imageProfilerModelsSubset.append(imageProfilerModels[index])
            }
            
        }
        closeBtn.addTarget(self, action: "closeProfilerImageViewerDialog", forControlEvents: UIControlEvents.TouchUpInside)
        profilerImageViewerDialog = profilerImageViewer.profilerImageViewerDialog(imageScrollView, imageProfilerModels: imageProfilerModelsSubset, closeBtn: closeBtn)
        profilerTableView.addSubview(self.profilerImageViewerDialog)
    }
    func closeProfilerImageViewerDialog() {
        profilerImageViewerDialog.removeFromSuperview()
    }
    
    var scrollViewer = UIScrollView()
    var webView = UIWebView()
    func showInWebViewer (inFile: String) {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollViewer.frame = CGRectMake(2, 2, 316, 310)
            webView.frame = CGRectMake(5, 0, 306, 255)
            closeBtn.frame = CGRectMake(135, 265, 60, 20)
        }
        else if DeviceType.IS_IPHONE_5 {
            scrollViewer.frame = CGRectMake(2, 2, 316, 385)
            webView.frame = CGRectMake(5, 0, 306, 332)
            closeBtn.frame = CGRectMake(125, 348, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6 {
            scrollViewer.frame = CGRectMake(2, 2, 370, 485)
            webView.frame = CGRectMake(5, 0, 360, 435)
            closeBtn.frame = CGRectMake(160, 450, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6P {
            scrollViewer.frame = CGRectMake(2, 2, 410, 530)
            webView.frame = CGRectMake(5, 0, 400, 480)
            closeBtn.frame = CGRectMake(180, 500, 60, 20)
        }
        else if DeviceType.IS_IPAD {
            scrollViewer.frame = CGRectMake(2, 2, 316, 385)
            webView.frame = CGRectMake(5, 0, 306, 332)
            closeBtn.frame = CGRectMake(125, 348, 60, 20)
        }
        else {
            scrollViewer.frame = CGRectMake(2, 2, 316, 385)
            webView.frame = CGRectMake(5, 0, 306, 332)
            closeBtn.frame = CGRectMake(125, 348, 60, 20)
        }
        
        scrollViewer.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        scrollViewer.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        scrollViewer.layer.borderWidth = 1.5
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: inFile)!))
        webView.delegate = self;
        scrollViewer.addSubview(webView)
   
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.addTarget(self, action: "closeWebViewer", forControlEvents: UIControlEvents.TouchUpInside)
        scrollViewer.addSubview(closeBtn)
        
        profilerTableView.addSubview(scrollViewer)
    }
    func closeWebViewer() {
        self.webView.removeFromSuperview()
        self.scrollViewer.removeFromSuperview()
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
    var numAudio = 0
    var numImage = 0
    var categories = [String]()
    var mediaTypes = [String]()
    var fileLocations = [String]()
    var fileNames = [String]()
    
    var audioFileLocations = [String]()
    var audioFileNames = [String]()
    var audioSongTitles = [String]()
    var audioFileDescriptions = [String]()
    var audioFileIds = [String]()
    var audioCategories = [String]()
    var audioProfilerModels = [AudioProfilerModel]()
    
    var imageFileLocations = [String]()
    var imageFileNames = [String]()
    var imageNames = [String]()
    var imageDescriptions = [String]()
    var imageFileIds = [String]()
    var imageCategories = [String]()
    var imageProfilerModels = [ImageProfilerModel]()
    
    let menuView = UIView()
    var menuLine = UILabel()
    var segue = UIStoryboardSegue()
    var showFlashBtn = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton

    var profilerTableView: UITableView = UITableView()
    var profilerScrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_wami_profile_media_info.png")
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
        }
        else {
            if let numCategories: Int! = jsonData["identity_profiler_data"].array?.count {
                self.numCategories = numCategories
                for index in 0...numCategories - 1 {
                    var categoryName = jsonData["identity_profiler_data"][index]["category"].string!
                    categories.append(categoryName)
                    var mediaType = jsonData["identity_profiler_data"][index]["media_type"].string!
                    mediaTypes.append(mediaType)
                    if mediaType == "Text" || mediaType == "PDF"  {
                        var fileLocation = jsonData["identity_profiler_data"][index]["file"]["file_location"].string!
                        fileLocations.append(fileLocation)
                        var fileName = jsonData["identity_profiler_data"][index]["file"]["file_name"].string!
                        fileNames.append(fileName)
                    }
                    if mediaType == "Audio" {
                        if let numAudio: Int! = jsonData["identity_profiler_data"][index]["file"]["audio"].array?.count {
                            self.numAudio = numAudio
                            for index2 in 0...numAudio - 1 {
                                var audioProfilerModel = AudioProfilerModel()
                                
                                var audioSongTitle = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["audio_file_name"].string!
                                audioSongTitles.append(audioSongTitle)
                                audioProfilerModel.setAudioSongTitle(audioSongTitle)
                                
                                var audioFileName = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["file_name"].string!
                                audioFileNames.append(audioFileName)
                                audioProfilerModel.setAudioFileName(audioFileName)
                                
                                var audioFileLocation = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["file_location"].string!
                                audioFileLocations.append(audioFileLocation)
                                audioProfilerModel.setAudioFileLocation(audioFileLocation)
                                
                                var audioFileDescription = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["audio_file_description"].string!
                                audioFileDescriptions.append(audioFileDescription)
                                audioProfilerModel.setAudioFileDescription(audioFileDescription)
                                
                                var audioCategory = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["category"].string!
                                audioCategories.append(audioCategory)
                                audioProfilerModel.setAudioCategory(audioCategory)
                                
                                var audioFileId = jsonData["identity_profiler_data"][index]["file"]["audio"][index2]["profiler_audio_jukebox_id"].string!
                                audioFileIds.append(audioFileId)
                                audioProfilerModel.setAudioFileId(audioFileId.toInt()!)
                                
                                audioProfilerModels.append(audioProfilerModel)
                            }
                            fileNames.append("audio")
                            fileLocations.append("")
                        }
                        else {
                           self.numAudio = 0
                        }
                    }
                    if mediaType == "Image" {
                        if let numImage: Int! = jsonData["identity_profiler_data"][index]["file"]["image"].array?.count {
                            self.numImage = numImage
                            for index2 in 0...numImage - 1 {
                                var imageProfilerModel = ImageProfilerModel()
                                
                                var imageName = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["image_name"].string!
                                imageNames.append(imageName)
                                imageProfilerModel.setImageName(imageName)
                                
                                var imageFileName = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["file_name"].string!
                                imageFileNames.append(imageFileName)
                                imageProfilerModel.setFileName(imageFileName)
                                
                                var imageFileLocation = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["file_location"].string!
                                imageFileLocations.append(imageFileLocation)
                                imageProfilerModel.setFileLocation(imageFileLocation)
                                
                                var imageDescription = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["image_description"].string!
                                imageDescriptions.append(imageDescription)
                                imageProfilerModel.setImageDescription(imageDescription)
                                
                                var imageCategory = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["category"].string!
                                imageCategories.append(imageCategory)
                                imageProfilerModel.setImageCategory(imageCategory)
                                
                                var imageFileId = jsonData["identity_profiler_data"][index]["file"]["image"][index2]["profiler_image_gallery_id"].string!
                                imageFileIds.append(imageFileId)
                                imageProfilerModel.setImageId(imageFileId.toInt()!)
                                
                                imageProfilerModels.append(imageProfilerModel)
                            }
                            fileNames.append("image")
                            fileLocations.append("")
                        }
                        else {
                            self.numImage = 0
                        }
                    }
                }
            }
            else {
                self.numCategories = 0
            }
        }
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            profilerScrollView.frame = CGRectMake(1, 178, 319, 302)
            profilerTableView.frame = CGRectMake(2, 2, 315, 296)
            profilerTableView.rowHeight = 44
        }
        else if DeviceType.IS_IPHONE_5 {
            profilerScrollView.frame = CGRectMake(1, 178, 319, 389)
            profilerTableView.frame = CGRectMake(2, 2, 315, 384)
            profilerTableView.rowHeight = 44
        }
        else if DeviceType.IS_IPHONE_6 {
            profilerScrollView.frame = CGRectMake(1, 178, 373, 488)
            profilerTableView.frame = CGRectMake(2, 2, 369, 485)
            profilerTableView.rowHeight = 44
        }
        else if DeviceType.IS_IPHONE_6P {
            profilerScrollView.frame = CGRectMake(1, 178, 413, 557)
            profilerTableView.frame = CGRectMake(2, 2, 409, 554)
            profilerTableView.rowHeight = 44
        }
        else if DeviceType.IS_IPAD {
            profilerScrollView.frame = CGRectMake(1, 186, 319, 381)
            profilerTableView.frame = CGRectMake(2, 4, 315, 374)
        }
        else {
            profilerScrollView.frame = CGRectMake(1, 186, 319, 381)
            profilerTableView.frame = CGRectMake(2, 4, 315, 374)
        }
        
        profilerScrollView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        profilerScrollView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        profilerScrollView.layer.borderWidth = 1.5
        
        profilerTableView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        profilerTableView.layer.borderWidth = 1.0
        profilerTableView.delegate = self
        profilerTableView.dataSource = self
        profilerTableView.registerClass(ProfilerTableViewCell.self, forCellReuseIdentifier: "ProfilerTableViewCell")
        profilerScrollView.addSubview(profilerTableView)
        
        view.addSubview(profilerScrollView)

        var nextItem  = UIImage(named: "next_item_right")
        showFlashBtn.setImage(nextItem, forState: .Normal)
        showFlashBtn.showsTouchWhenHighlighted = true
        if DeviceType.IS_IPHONE_4_OR_LESS {
            showFlashBtn.frame = CGRectMake(278, 108, 30, 30)
        }
        else if DeviceType.IS_IPHONE_5 {
            showFlashBtn.frame = CGRectMake(282, 108, 30, 30)
        }
        else if DeviceType.IS_IPHONE_6 {
            showFlashBtn.frame = CGRectMake(340, 108, 30, 30)
        }
        else if DeviceType.IS_IPHONE_6P {
            showFlashBtn.frame = CGRectMake(375, 108, 30, 30)
        }
        else if DeviceType.IS_IPAD {
            showFlashBtn.frame = CGRectMake(340, 108, 30, 30)
        }
        else {
            showFlashBtn.frame = CGRectMake(282, 108, 30, 30)
        }
        showFlashBtn.addTarget(self, action: "showFlash", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(showFlashBtn)
    }
    
    func showFlash() {
        menuView.hidden = true
        performSegueWithIdentifier("showFlash", sender: nil)
        var svc = segue.destinationViewController as! Flash;
        svc.identityProfileId = self.identityProfileId
        svc.userIdentityProfileId = self.userIdentityProfileId
        svc.imageUrl = self.imageUrl
        svc.profileName = self.profileName
        svc.firstName = self.firstName
        svc.lastName = self.lastName
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
        
        var transmitThisWamiBtn = menu.setMenuBtnAttributes("Publish This Profile...")
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.frame = CGRectMake(0, 0, 145, 30)
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
        cell.categoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        cell.categoryBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        cell.categoryBtn.addTarget(self, action: "categoryBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
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





