//
//  SearchResults.swift
//  MyWami
//
//  Created by Robert Lanter on 5/14/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class SearchResults: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var searchIn: String!
    var searchStringLike: String!
    var searchEntireNetwork: String!
    var userIdentityProfileId: String!
    
    // More info
    @IBAction func moreInfoBtnPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.searchResultsTableView)
        var indexPath: NSIndexPath = self.searchResultsTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        
        self.moreInfoAction(row)
    }
    var searchMoreInfo = SearchMoreInfo()
    var moreInfoViewDialog = UIView()
    func moreInfoAction(row: Int) {
        var moreInfoView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeMoreInfoDialog", forControlEvents: UIControlEvents.TouchUpInside)
        
        var profileName = profileNames[row]
        var tag = tags[row]
        var description = descriptions[row]
        self.moreInfoViewDialog = searchMoreInfo.moreInfoDialog(moreInfoView, profileName: profileName, tag: tag, description: description, closeBtn: closeBtn)
        
        view.addSubview(self.moreInfoViewDialog)
        menu.toggleMenu(menuView)
    }
    func closeMoreInfoDialog() {
        self.moreInfoViewDialog.removeFromSuperview()
    }
   
    
    @IBAction func checkboxPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.searchResultsTableView)
        var indexPath: NSIndexPath = self.searchResultsTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        
        if checkBoxs[row] == false {
            checkBoxs[row] = true
        }
        else {
            checkBoxs[row] = false
        }
    }
    
    // Request profiles
    var emailTo = ""
    @IBAction func requestProfilePressed(sender: AnyObject) {
        var profilesToRequest = false
        var profileIndex = 0
        var numProfilesToRequest = 0
        for index in 0...numProfiles - 1 {
            if checkBoxs[index] == true {
                chosenProfilesIdsToRequest[profileIndex] = identityProfileIds[index]
                emailTo = emails[index] + "," + emailTo
                profileIndex++
                profilesToRequest = true
            }
        }
        if profilesToRequest == true {
            numProfilesToRequest = profileIndex
            emailTo = emailTo.substringToIndex(emailTo.endIndex.predecessor())
            requestProfileAction()
        }
        else {
            self.view.makeToast(message: "No Profiles were requested. Please request profiles by checking checkboxes.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    var requestProfileConfirm = RequestProfileConfirm()
    var confirmDialog = UIView()
    func requestProfileAction() {
        var confirmView = UIView()
        let cancelBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelBtn.addTarget(self, action: "closeConfirmDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let requestBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        requestBtn.addTarget(self, action: "request", forControlEvents: UIControlEvents.TouchUpInside)
        self.confirmDialog = requestProfileConfirm.confirmDialog(confirmView, cancelBtn: cancelBtn, requestBtn: requestBtn)
        view.addSubview(self.confirmDialog)
    }
    func closeConfirmDialog() {
        self.confirmDialog.removeFromSuperview()
    }
    func request() {
        self.confirmDialog.removeFromSuperview()
        var emailFrom = ""
        var profileNameFrom = ""
        let GET_PROFILE_NAME = UTILITIES.IP + "get_profile_name.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_NAME, params: ["param1": self.userIdentityProfileId])
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
            return
        }
        else {
            emailFrom = jsonData["email"].string!
            profileNameFrom = jsonData["profile_name"].string!
        }
        let TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE_IOS = UTILITIES.EMAIL_IP + "transmit_request_to_email_address_mobile_ios.php"
        jsonData = JSON_DATA_SYNCH.jsonGetData(TRANSMIT_REQUEST_TO_EMAIL_ADDRESS_MOBILE_IOS,
            params: ["param1": emailTo, "param2": emailFrom, "param3": profileNameFrom])
        var message = jsonData["message"].string
        self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
    }

    // New search
    @IBAction func newSearchPressed(sender: AnyObject) {
        self.searchProfilesAction ()
    }
    var searchForProfiles = SearchForProfiles()
    var searchForProfilesViewDialog = UIView()
    var verticalPos: CGFloat = 0
    func searchProfilesAction () {
        var searchForProfilesView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeSearchForProfilesDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let searchBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        searchBtn.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        var verticalOffset = CGFloat(50.0)
        self.searchForProfilesViewDialog = searchForProfiles.searchProfilesDialog(searchForProfilesView, closeBtn: closeBtn, searchBtn: searchBtn, vertcalOffset: verticalOffset, verticalPos: verticalPos)
        view.addSubview(self.searchForProfilesViewDialog)
        menu.toggleMenu(menuView)
    }
    func closeSearchForProfilesDialog() {
        self.searchForProfilesViewDialog.removeFromSuperview()
    }
    func search() {
        self.searchIn = searchForProfiles.getSearchIn()
        self.searchStringLike = searchForProfiles.getsSearchStringLikeTxt()
        if searchStringLike == "" {
            self.view.makeToast(message: "Please enter a search string.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        self.searchEntireNetwork = searchForProfiles.getSearchIndicator()
        self.searchForProfilesViewDialog.removeFromSuperview()
        self.viewDidLoad()
    }
    
    // Home
    @IBAction func homePressed(sender: AnyObject) {
        homeAction ()
    }
    
    
    @IBOutlet var searchResultsTableView: UITableView!
    
    let textCellIdentifier = "SearchTableViewCell"
    
    var profileNames = [String]()
    var firstNames = [String]()
    var lastNames = [String]()
    var imageUrls = [String]()
    var emails = [String]()
    var descriptions = [String]()
    var tags = [String]()
    var identityProfileIds = [String]()
    var checkBoxs = [Bool]()
    var chosenProfilesIdsToRequest = [String]()
    
    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()
    
    let menuView = UIView()
    var menuLine = UILabel()
    
    var numProfiles = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        let titleBar = UIImage(named: "actionbar_search_results.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2
        
        var image : UIImage = UIImage(named:"wami1.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton
  
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
        self.searchResultsTableView.rowHeight = 80
        
        let GET_SEARCH_PROFILE_DATA = UTILITIES.IP + "get_search_profile_data.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_SEARCH_PROFILE_DATA, params: ["param1": searchIn, "param2": searchStringLike, "param3": searchEntireNetwork, "param4": userIdentityProfileId])        
        getProfileCollection(jsonData)
    }
    
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(220, 65, 90, 55)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.0
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var homeBtn = menu.setMenuBtnAttributes("Home")
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.frame = CGRectMake(-45, 0, 145, 30)
        menuView.addSubview(homeBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-41, 24, 145, 30)
        menuView.addSubview(logoutBtn)
        
        menuLine = menu.createMenuLine(0, length: 150)
        menuView.addSubview(menuLine)
    }

    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func homeAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[1] as! UIViewController, animated: true)
    }
    
    func logoutAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[0] as! UIViewController, animated: true)
    }
    
    func numberOfSectionsInTableView(searchResultsTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(searchResultsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numProfiles
    }

    func tableView(searchResultsTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = searchResultsTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! SearchTableViewCell
        var contactName = self.firstNames[indexPath.row] + " " + self.lastNames[indexPath.row]
        cell.profileNameTxt.text = self.profileNames[indexPath.row]
        cell.contactNameTxt.text = contactName
        cell.emailTxt.text = self.emails[indexPath.row]
        cell.wamiCheckBox.isChecked = false
        if let image = UIImage(named: self.imageUrls[indexPath.row]) {
            cell.profileImage.image = image
        }
        
        return cell
    }
    
    func tableView(searchResultsTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchResultsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    func initData() {
        self.profileNames.removeAll()
        self.firstNames.removeAll()
        self.lastNames.removeAll()
        self.imageUrls.removeAll()
        self.emails.removeAll()
        self.identityProfileIds.removeAll()
        self.checkBoxs.removeAll()
        self.chosenProfilesIdsToRequest.removeAll()
    }
    
    func getProfileCollection (jsonData: JSON) -> Int {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.view.makeToast(message: message!, duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            }
        }
        else {
            initData()
            let numProfiles: Int! = jsonData["profile_list"].array?.count
            if numProfiles == 0 {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.view.makeToast(message: "No Profiles found.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                }
                return -1
            }
            self.numProfiles = numProfiles
            for index in 0...numProfiles - 1 {
                var profileName = jsonData["profile_list"][index]["profile_name"].string!
                profileNames.append(profileName)
                
                if let firstName = jsonData["profile_list"][index]["first_name"].string {
                    firstNames.append(firstName)
                }
                else {
                    firstNames.append("")
                }
                
                if let lastName = jsonData["profile_list"][index]["last_name"].string {
                    lastNames.append(lastName)
                }
                else {
                    lastNames.append("")
                }
                
                if let description = jsonData["profile_list"][index]["description"].string {
                    descriptions.append(description)
                }
                else {
                    descriptions.append("")
                }
                
                if let tag = jsonData["profile_list"][index]["tags"].string {
                    tags.append(tag)
                }
                else {
                    tags.append("")
                }
                
                if let imageUrl = jsonData["profile_list"][index]["image_url"].string {
                    imageUrls.append(imageUrl)
                }
                else {
                    imageUrls.append("")
                }
                
                if let email = jsonData["profile_list"][index]["email"].string {
                    emails.append(email)
                }
                else {
                    emails.append("")
                }
                
                var identityProfileId = jsonData["profile_list"][index]["identity_profile_id"].string!
                identityProfileIds.append(identityProfileId)
                
                checkBoxs.append(false)
                chosenProfilesIdsToRequest.append("")
            }
            self.searchResultsTableView.reloadData()
        }
        return 0
    }
}