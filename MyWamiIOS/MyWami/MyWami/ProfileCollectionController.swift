//
// Created by Robert Lanter on 3/4/15.
// Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import MessageUI
import AddressBook

class ProfileCollectionController: UITableViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    @IBAction func checkBoxPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row

        if checkBoxs[row] == false {
            checkBoxs[row] = true
        }
        else {
            checkBoxs[row] = false
        }
    }
    
    @IBOutlet var tableViewCell: ProfileListTableViewCell!
    
    var verticalPos: CGFloat = 0
    var transmitCellBtnPressed = false
    @IBAction func transmitButtonPressed(sender: AnyObject) {
        if transmitCellBtnPressed == true {
            return
        }
        menuView.hidden = false
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        selectedIdentityProfileId = identityProfileIds[row]
        numProfilesToTransmit = 1
        
        let currYpos = tableView.contentOffset.y
        verticalPos = currYpos + CGFloat(66)
        
        transmitProfileAction()
    }

    // Address book processing
    var adbk : ABAddressBook?
    var authDone: Bool = false
    var replaceContact = false
    var processAddressBook: ProcessAddressBook!
    func cancelContactAction(alertController: UIAlertAction!) {
        return
    }
    func replaceContactAction(alertController: UIAlertAction!) {
        self.replaceContact = true
        self.processAddressBook.addToContactListAction(firstNames[self.row], lastName: lastNames[self.row], telephone: telephones[self.row], email: emails[self.row],
            streetAddress: "", city: "", state: "", zipcode: "", country: "", replaceContact: replaceContact)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.view.makeToast(message: "Contact replaced in Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    func addContactAction(alertController: UIAlertAction!) {
        self.replaceContact = false
        self.processAddressBook.addToContactListAction(firstNames[self.row], lastName: lastNames[self.row], telephone: telephones[self.row], email: emails[self.row],
            streetAddress: "", city: "", state: "", zipcode: "", country: "", replaceContact: replaceContact)
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.view.makeToast(message: "Contact added to Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    @IBAction func addToContactsButtonPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.row = row
        
        self.processAddressBook = ProcessAddressBook()
        processAddressBook.initialize()
        var auth = processAddressBook.getAuthorization()
        if auth {
            var exist = processAddressBook.checkForExist(firstNames[self.row], lastName: lastNames[self.row])
            if exist {
                var alertController = UIAlertController(title: "Alert!", message: "Contact Already Exists In Address Book", preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: addContactAction))
                alertController.addAction(UIAlertAction(title: "Replace", style: UIAlertActionStyle.Default, handler: replaceContactAction))
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: cancelContactAction))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            else {
                processAddressBook.addToContactListAction(firstNames[self.row], lastName: lastNames[self.row], telephone: telephones[self.row], email: emails[self.row],
                    streetAddress: "", city: "", state: "", zipcode: "", country: "", replaceContact: replaceContact)
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.view.makeToast(message: "Contact added to Address Book", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                }
            }
        }
    }
    func createMultiStringRef() -> ABMutableMultiValueRef {
        let propertyType: NSNumber = kABMultiStringPropertyType
        return Unmanaged.fromOpaque(ABMultiValueCreateMutable(propertyType.unsignedIntValue).toOpaque()).takeUnretainedValue() as NSObject as ABMultiValueRef
    }

    
    @IBAction func extendedInfoButtonPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.row = row
    }

    var userName: String!
    var userId: String!
    var userIdentityProfileId: String!
    var selectedIdentityProfileId: String!

    let JSON_DATA = JsonGetData()
    let JSON_DATA_SYNCH = JsonGetDataSynchronous()
    let UTILITIES = Utilities()

    var profileNames = [String]()
    var firstNames = [String]()
    var lastNames = [String]()
    var imageUrls = [String]()
    var emails = [String]()
    var telephones = [String]()
    var identityProfileIds = [String]()
    var assignToIdentityProfileIds = [String]()
    var checkBoxs = [Bool]()
    var chosenProfilesIdsToTransmit = [String]()

    let textCellIdentifier = "ProfileListTableViewCell"
    var row = 0
    var numProfiles = 0
    var numProfilesToTransmit = 0
    
    let menuView = UIView()
    var menuLine = UILabel()
    
    var newIdentityProfileId: String!
    var newGroupId: Int!
    
    var segue = UIStoryboardSegue()
    var customHeadingView = UIView(frame: CGRectMake(0, 10, 170, 60))
    override func viewDidLoad() {
        super.viewDidLoad()

        let GET_DEFAULT_PROFILE_COLLECTION = UTILITIES.IP + "get_default_profile_collection.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_DEFAULT_PROFILE_COLLECTION, params: ["param1": userId])
        getProfileCollection(jsonData)

        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton
        
        setHeading(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        searchProfilesPressed = false
        super.viewDidAppear(animated)
    }
    
    func getProfileName(defaultInd: Bool) -> String {
        var profileId = ""
        if defaultInd {
            let GET_DEFAULT_IDENTITY_PROFILE_ID = UTILITIES.IP + "get_default_identity_profile_id.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_DEFAULT_IDENTITY_PROFILE_ID, params: ["param1": userId])
            profileId = jsonData["default_identity_profile_id"][0]["identity_profile_id"].string!
        }
        else {
            profileId = self.newIdentityProfileId
        }
        
        let GET_PROFILE_NAME = UTILITIES.IP + "get_profile_name.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_NAME, params: ["param1": profileId])
        var profileName = jsonData["profile_name"].string!
        
        return profileName
    }
    
    func setHeading(defaultInd: Bool) {
        customHeadingView = UIView(frame: CGRectMake(0, 10, 200, 60))
        
        var backButtonImage = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButtonImage.frame = CGRectMake(-10, 15, 45, 25)
        backButtonImage.setBackgroundImage(UIImage(named: "wami1.png"), forState: UIControlState.Normal)
        backButtonImage.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        customHeadingView.addSubview(backButtonImage)

        var profileName = getProfileName(defaultInd)
        var profileNameLbl = UILabel()
        profileNameLbl.text = profileName
        profileNameLbl.font = UIFont.boldSystemFontOfSize(14)
        profileNameLbl.textColor = UIColor(red: 0xda/255, green: 0xa5/255, blue: 0x20/255, alpha: 1.0)
        profileNameLbl.textAlignment = NSTextAlignment.Center
        profileNameLbl.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
        customHeadingView.addSubview(profileNameLbl)
        
        let titleBar = UIImage(named: "actionbar_wami_connections.png")
        let imageView2 = UIImageView(image:titleBar)
        customHeadingView.addSubview(imageView2)
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            profileNameLbl.frame = CGRectMake(70, 7, 160, 25)
            imageView2.frame = CGRectMake(80, 25, 140, 20)
        }
        else if DeviceType.IS_IPHONE_5 {
            profileNameLbl.frame = CGRectMake(70, 7, 160, 25)
            imageView2.frame = CGRectMake(80, 25, 140, 20)
        }
        else if DeviceType.IS_IPHONE_6 {
            profileNameLbl.frame = CGRectMake(95, 7, 170, 25)
            imageView2.frame = CGRectMake(110, 25, 140, 20)
        }
        else if DeviceType.IS_IPHONE_6P {
            profileNameLbl.frame = CGRectMake(70, 7, 160, 25)
            imageView2.frame = CGRectMake(80, 25, 140, 20)
        }
        else if DeviceType.IS_IPAD {
            profileNameLbl.frame = CGRectMake(70, 7, 160, 25)
            imageView2.frame = CGRectMake(80, 25, 140, 20)
        }
        else {
            profileNameLbl.frame = CGRectMake(70, 7, 160, 25)
            imageView2.frame = CGRectMake(80, 25, 140, 20)
        }
        
        var mainHeading = UIBarButtonItem(customView: customHeadingView)
        self.navigationItem.leftBarButtonItem = mainHeading
    }
    
    let menu = Menu()
    var selectCollectionBtn = UIButton()
    var filterByGroupBtn = UIButton()
    var searchProfilesBtn = UIButton()
    var transmitBtn = UIButton()
    
    var selectCollectionPressed = false
    var filterByGroupPressed = false
    var searchProfilesPressed = false
    var transmitPressed = false
    func showMenu(sender: UIBarButtonItem) {
        
        let currYpos = tableView.contentOffset.y
        verticalPos = currYpos + CGFloat(66)
        
        menuView.frame = CGRectMake(130, verticalPos, 180, 155)
        menuView.layer.cornerRadius = 6.0        
        menuView.backgroundColor = UIColor(red: 0x61/255, green: 0x61/255, blue: 0x61/255, alpha: 0.90)
        menuView.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.0
        
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        if selectCollectionPressed == false {
            selectCollectionBtn = menu.setMenuBtnAttributes("Select a Profile Collection...")
            selectCollectionBtn.addTarget(self, action: "selectProfileAction", forControlEvents: UIControlEvents.TouchUpInside)
            selectCollectionBtn.frame = CGRectMake(4, 0, 175, 30)
            menuView.addSubview(selectCollectionBtn)
        }
        
        if filterByGroupPressed == false {
            filterByGroupBtn = menu.setMenuBtnAttributes("Filter Collection by Group...")
            filterByGroupBtn.addTarget(self, action: "filterByGroupAction", forControlEvents: UIControlEvents.TouchUpInside)
            filterByGroupBtn.frame = CGRectMake(4, 25, 175, 30)
            menuView.addSubview(filterByGroupBtn)
        }
        
        if transmitPressed == false {
            transmitBtn = menu.setMenuBtnAttributes("Publish Profile(s)...")
            transmitBtn.addTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
            transmitBtn.frame = CGRectMake(-23, 50, 175, 30)
            menuView.addSubview(transmitBtn)
        }
        
        if transmitCellBtnPressed == true {
            transmitBtn = menu.setMenuBtnAttributes("Publish Profile(s)...")
            transmitBtn.showsTouchWhenHighlighted = false
            transmitBtn.removeTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
            transmitBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            transmitBtn.frame = CGRectMake(-23, 50, 175, 30)
            menuView.addSubview(transmitBtn)
        }
        
        var refeshListBtn = menu.setMenuBtnAttributes("Refresh Wami List")
        refeshListBtn.addTarget(self, action: "refeshListAction", forControlEvents: UIControlEvents.TouchUpInside)
        refeshListBtn.frame = CGRectMake(-24, 75, 175, 30)
        menuView.addSubview(refeshListBtn)
        
        if searchProfilesPressed == false {
            searchProfilesBtn = menu.setMenuBtnAttributes("Search for Profiles...")
            searchProfilesBtn.addTarget(self, action: "searchProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
            searchProfilesBtn.frame = CGRectMake(-18, 100, 175, 30)
            menuView.addSubview(searchProfilesBtn)
        }
            
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-57, 125, 175, 30)
        menuView.addSubview(logoutBtn)
        
        menuLine = menu.createMenuLine(0, length: 180)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(25, length: 180)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(50, length: 180)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(75, length: 180)
        menuView.addSubview(menuLine)
        menuLine = menu.createMenuLine(100, length: 180)
        menuView.addSubview(menuLine)
    }
    
    // Transmit profile(s)
    func transmitProfilesAction() {
        var profilesToTransmit = false
        var profileIndex = 0
        selectedIdentityProfileId = ""
        for index in 0...numProfiles - 1 {
            if checkBoxs[index] == true {
                chosenProfilesIdsToTransmit[profileIndex] = identityProfileIds[index]
                selectedIdentityProfileId = identityProfileIds[index] + "," + selectedIdentityProfileId
                profileIndex++
                profilesToTransmit = true
            }
        }
        if profilesToTransmit == true {            
            numProfilesToTransmit = profileIndex
            selectedIdentityProfileId = selectedIdentityProfileId.substringToIndex(selectedIdentityProfileId.endIndex.predecessor())
            transmitProfileAction()
        }
        else {
            self.view.makeToast(message: "No Profiles were chosen to publish. Please choose Profiles to publish by checking profile checkboxes.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    var transmitProfileViewDialog = UIView()
    let transmitProfile = TransmitProfile()
    func transmitProfileAction () {
    
        self.transmitBtn.showsTouchWhenHighlighted = false
        self.transmitBtn.removeTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.transmitBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        transmitPressed = true
        transmitCellBtnPressed = true
        
        var transmitProfileView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeTransmitProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        transmitBtn.addTarget(self, action: "transmit", forControlEvents: UIControlEvents.TouchUpInside)
        self.transmitProfileViewDialog = transmitProfile.transmitProfileDialog(transmitProfileView, closeBtn: closeBtn, transmitBtn: transmitBtn, verticalPos: verticalPos)
        view.addSubview(self.transmitProfileViewDialog)
        menu.toggleMenu(menuView)
    }
    func closeTransmitProfileDialog() {
        self.transmitProfileViewDialog.removeFromSuperview()
        transmitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.transmitBtn.addTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitPressed = false
        transmitCellBtnPressed = false
    }
    func transmit() {
        transmitProfile.transmit(userIdentityProfileId, identityProfileId: selectedIdentityProfileId, numToTransmit: String(numProfilesToTransmit))
    }
    
    // Select profile collection
    var selectProfile = SelectProfile()
    var selectProfileViewDialog = UIView()
    func selectProfileAction () {

        selectCollectionBtn.showsTouchWhenHighlighted = false
        selectCollectionBtn.removeTarget(self, action: "selectProfileAction", forControlEvents: UIControlEvents.TouchUpInside)
        selectCollectionBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        selectCollectionPressed = true
      
        var selectProfileView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeSelectProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let selectBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        selectBtn.addTarget(self, action: "selectProfileCollection", forControlEvents: UIControlEvents.TouchUpInside)
        self.selectProfileViewDialog = selectProfile.selectProfileDialog(selectProfileView, closeBtn: closeBtn, selectBtn: selectBtn, verticalPos: verticalPos)
        view.addSubview(self.selectProfileViewDialog)
        menu.toggleMenu(menuView)
    }
    func closeSelectProfileDialog() {
        self.selectProfileViewDialog.removeFromSuperview()
        selectCollectionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        selectCollectionPressed = false
    }
    func selectProfileCollection() {
        self.newIdentityProfileId = selectProfile.getNewIdentityProfileId()
        if self.newIdentityProfileId != "0" {
            self.userIdentityProfileId = newIdentityProfileId
            let GET_PROFILE_COLLECTION = UTILITIES.IP + "get_profile_collection.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION, params: ["param1": newIdentityProfileId])
            getProfileCollection(jsonData)
            closeSelectProfileDialog()
            tableView.reloadData()
            
            setHeading(false)
        }
        else {
            self.view.makeToast(message: "Please select a Profile Collection or hit Close", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }        
    }
    
    // Filter collection
    var filterCollection = FilterCollection()
    var filterCollectionViewDialog = UIView()
    func filterByGroupAction () {
        var filterCollectionView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeFilterCollectionDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let filterCollectionBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        filterCollectionBtn.addTarget(self, action: "doFilter", forControlEvents: UIControlEvents.TouchUpInside)
        
        if let filterCollectionViewDialog = filterCollection.filterCollectionDialog(filterCollectionView, closeBtn: closeBtn, filterCollectionBtn: filterCollectionBtn, userIdentityProfileId: userIdentityProfileId, verticalPos: verticalPos) {
            filterByGroupBtn.showsTouchWhenHighlighted = false
            filterByGroupBtn.removeTarget(self, action: "filterByGroupAction", forControlEvents: UIControlEvents.TouchUpInside)
            filterByGroupBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            filterByGroupPressed = true
            
            self.filterCollectionViewDialog = filterCollectionViewDialog
            view.addSubview(filterCollectionViewDialog)
            menu.toggleMenu(menuView)
        }
        else {
            self.view.makeToast(message: "No groups found for Profile!", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            menu.toggleMenu(menuView)
        }
    }
    func doFilter() {
        self.newGroupId = filterCollection.getGroupId()
        if self.newGroupId == -99 || self.newGroupId == 0 {
            let GET_PROFILE_COLLECTION = UTILITIES.IP + "get_profile_collection.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION, params: ["param1": userIdentityProfileId])
            var retCode = getProfileCollection(jsonData)
            if retCode == -1 {
                return
            }
        }
        else {
            let GET_PROFILE_COLLECTION_FILTERED = UTILITIES.IP + "get_profile_collection_filtered.php"
            var newGroupIdStr = String(self.newGroupId)
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION_FILTERED, params: ["param1": self.userIdentityProfileId, "param2": newGroupIdStr])
            var retCode = getProfileCollection(jsonData)
            if retCode == -1 {
                return
            }
        }
        closeFilterCollectionDialog()
        tableView.reloadData()
    }
    func closeFilterCollectionDialog() {
        self.filterCollectionViewDialog.removeFromSuperview()
        filterByGroupBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterByGroupPressed = false
    }    
    
    func refeshListAction () {
        let GET_PROFILE_COLLECTION = UTILITIES.IP + "get_profile_collection.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION, params: ["param1": userIdentityProfileId])
        getProfileCollection(jsonData)
        menu.toggleMenu(menuView)
        tableView.reloadData()
    }

    var searchForProfiles = SearchForProfiles()
    var searchForProfilesViewDialog = UIView()
    func searchProfilesAction () {
        
        searchProfilesBtn.showsTouchWhenHighlighted = false
        searchProfilesBtn.removeTarget(self, action: "searchProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        searchProfilesBtn.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
        searchProfilesPressed = true
        
        var searchForProfilesView = UIView()
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeSearchForProfilesDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let searchBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        searchBtn.addTarget(self, action: "search", forControlEvents: UIControlEvents.TouchUpInside)
        var verticalOffset = CGFloat(0.0)
        self.searchForProfilesViewDialog = searchForProfiles.searchProfilesDialog(searchForProfilesView, closeBtn: closeBtn, searchBtn: searchBtn, vertcalOffset: verticalOffset, verticalPos: verticalPos)
        view.addSubview(self.searchForProfilesViewDialog)
        menu.toggleMenu(menuView)
    }
    func closeSearchForProfilesDialog() {
        self.searchForProfilesViewDialog.removeFromSuperview()
        searchProfilesBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchProfilesPressed = false
    }
    func search() {
        var searchIn = searchForProfiles.getSearchIn()
        var searchStringLike = searchForProfiles.getsSearchStringLikeTxt()
        if searchStringLike == "" {
            self.view.makeToast(message: "Please enter a search string.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
            return
        }
        var searchEntireNetwork = searchForProfiles.getSearchIndicator()
        
        self.searchForProfilesViewDialog.removeFromSuperview()
        performSegueWithIdentifier("showSearchResults", sender: self)
        var svc = segue.destinationViewController as! SearchResults
        svc.searchIn = searchIn
        svc.searchStringLike = searchStringLike
        svc.searchEntireNetwork = searchEntireNetwork
        svc.userIdentityProfileId = self.userIdentityProfileId
    }
    
    func logoutAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[0] as! UIViewController, animated: true)
    }

    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numProfiles
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! ProfileListTableViewCell        
        var contactName = self.firstNames[indexPath.row] + " " + self.lastNames[indexPath.row]
        cell.profileNameTxt.text = self.profileNames[indexPath.row]
        cell.contactNameTxt.text = contactName
        var image : UIImage = UIImage(named: self.imageUrls[indexPath.row])!
        cell.profileImage.image = image
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        self.segue = segue
        if (segue.identifier == "showInfoExtended") {
            menuView.hidden = true
            var svc = segue.destinationViewController as! WamiInfoExtended;
            svc.identityProfileId = self.identityProfileIds[self.row]
            svc.userIdentityProfileId = self.userIdentityProfileId
        }
    }

    func initData() {
        self.profileNames.removeAll()
        self.firstNames.removeAll()
        self.lastNames.removeAll()
        self.imageUrls.removeAll()
        self.emails.removeAll()
        self.telephones.removeAll()
        self.identityProfileIds.removeAll()
        self.assignToIdentityProfileIds.removeAll()
        self.checkBoxs.removeAll()
        self.chosenProfilesIdsToTransmit.removeAll()
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
            let numProfiles: Int! = jsonData["profile_collection"].array?.count
            if numProfiles == 0 {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.view.makeToast(message: "No Profiles found matching selected Group. Select another Group or All.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
                }
                return -1
            }
            self.numProfiles = numProfiles
            for index in 0...numProfiles - 1 {
                var profileName = jsonData["profile_collection"][index]["profile_name"].string!
                profileNames.append(profileName)

                if let firstName = jsonData["profile_collection"][index]["first_name"].string {
                    firstNames.append(firstName)
                }
                else {
                    firstNames.append("")
                }
                
                if let lastName = jsonData["profile_collection"][index]["last_name"].string {
                    lastNames.append(lastName)
                }
                else {
                    lastNames.append("")
                }
                
                if let imageUrl = jsonData["profile_collection"][index]["image_url"].string {
                    imageUrls.append(imageUrl)
                }
                else {
                    imageUrls.append("")
                }
            
                if let email = jsonData["profile_collection"][index]["email"].string {
                    emails.append(email)
                }
                else {
                    emails.append("")
                }
                
                if let telephone = jsonData["profile_collection"][index]["telephone"].string {
                    telephones.append(telephone)
                }
                else {
                    telephones.append("")
                }

                var identityProfileId = jsonData["profile_collection"][index]["identity_profile_id"].string!
                identityProfileIds.append(identityProfileId)

                var assignToIdentityProfileId = jsonData["profile_collection"][index]["assign_to_identity_profile_id"].string!
                assignToIdentityProfileIds.append(assignToIdentityProfileId)
                
                checkBoxs.append(false)
                chosenProfilesIdsToTransmit.append("")
            }
        }
        return 0
    }
}
