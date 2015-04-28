//
// Created by Robert Lanter on 3/4/15.
// Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfileCollectionController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

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
    
    @IBAction func transmitButtonPressed(sender: AnyObject) {
        menuView.hidden = false
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        selectedIdentityProfileId = identityProfileIds[row]
        numProfilesToTransmit = 1
        transmitProfileAction()
    }

    @IBAction func addToContactsButtonPressed(sender: AnyObject) {
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let GET_DEFAULT_PROFILE_COLLECTION = UTILITIES.IP + "get_default_profile_collection.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_DEFAULT_PROFILE_COLLECTION, params: ["param1": userId])
        getProfileCollection(jsonData)

        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black

        let titleBar = UIImage(named: "actionbar_wami_list.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2

        var backButtonImage : UIImage = UIImage(named:"wami1.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
        
        menuView.hidden = true
        var menuIcon : UIImage = UIImage(named:"menuIcon.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuIcon, style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu:")
        navigationItem.rightBarButtonItem = menuButton
    }
    
    let menu = Menu()
    func showMenu(sender: UIBarButtonItem) {
        menuView.frame = CGRectMake(130, 2, 180, 155)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.whiteColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 2
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var selectCollectionBtn = menu.setMenuBtnAttributes("Select a Profile Collection...")
        selectCollectionBtn.addTarget(self, action: "selectProfileAction", forControlEvents: UIControlEvents.TouchUpInside)
        selectCollectionBtn.frame = CGRectMake(4, 0, 175, 30)
        menuView.addSubview(selectCollectionBtn)
        
        var filterByGroupBtn = menu.setMenuBtnAttributes("Filter Collection by Group...")
        filterByGroupBtn.addTarget(self, action: "filterByGroupAction", forControlEvents: UIControlEvents.TouchUpInside)
        filterByGroupBtn.frame = CGRectMake(4, 25, 175, 30)
        menuView.addSubview(filterByGroupBtn)
        
        var transmitBtn = menu.setMenuBtnAttributes("Transmit Profile(s)...")
        transmitBtn.addTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitBtn.frame = CGRectMake(-20, 50, 175, 30)
        menuView.addSubview(transmitBtn)
        
        var refeshListBtn = menu.setMenuBtnAttributes("Refresh Wami List")
        refeshListBtn.addTarget(self, action: "refeshListAction", forControlEvents: UIControlEvents.TouchUpInside)
        refeshListBtn.frame = CGRectMake(-24, 75, 175, 30)
        menuView.addSubview(refeshListBtn)
        
        var searchProfilesBtn = menu.setMenuBtnAttributes("Search for Profiles...")
        searchProfilesBtn.addTarget(self, action: "searchProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        searchProfilesBtn.frame = CGRectMake(-18, 100, 175, 30)
        menuView.addSubview(searchProfilesBtn)
        
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
            self.view.makeToast(message: "No Profiles were chosen to transmit. Please chose Profiles to transmit by checking checkboxes.", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }
    }
    var transmitProfileView = UIView()
    let transmitProfile = TransmitProfile()
    func transmitProfileAction () {
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
        transmitProfile.transmit(userIdentityProfileId, identityProfileId: selectedIdentityProfileId, numToTransmit: String(numProfilesToTransmit))
    }
    
    // Select profile collection
    var selectProfileView = UIView()
    var selectProfile = SelectProfile()
    func selectProfileAction () {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeSelectProfileDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let selectBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        selectBtn.addTarget(self, action: "selectProfileCollection", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.selectProfileView = selectProfile.selectProfileDialog(selectProfileView, closeBtn: closeBtn, selectBtn: selectBtn)
        
        view.addSubview(self.selectProfileView)
        menu.toggleMenu(menuView)
    }
    func closeSelectProfileDialog() {
        self.selectProfileView.removeFromSuperview()
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
        }
        else {
            self.view.makeToast(message: "Please select a Profile Collection or hit Close", duration: HRToastDefaultDuration, position: HRToastPositionCenter)
        }        
    }
    
    // Filter collection
    var filterCollectionView = UIView()
    let filterCollection = FilterCollection()
    func filterByGroupAction () {
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeFilterCollectionDialog", forControlEvents: UIControlEvents.TouchUpInside)
        let filterCollectionBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        filterCollectionBtn.addTarget(self, action: "doFilter", forControlEvents: UIControlEvents.TouchUpInside)
        
        filterCollectionView = filterCollection.filterCollectionDialog(filterCollectionView, closeBtn: closeBtn, filterCollectionBtn: filterCollectionBtn, userIdentityProfileId: userIdentityProfileId)
        
        view.addSubview(filterCollectionView)
        menu.toggleMenu(menuView)
    }
    func doFilter() {
        self.newGroupId = filterCollection.getGroupId()
        if self.newGroupId == -99 || self.newGroupId == 0 {
            let GET_PROFILE_COLLECTION = UTILITIES.IP + "get_profile_collection.php"
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION, params: ["param1": userIdentityProfileId])
            getProfileCollection(jsonData)
        }
        else {
            let GET_PROFILE_COLLECTION_FILTERED = UTILITIES.IP + "get_profile_collection_filtered.php"
            var newGroupIdStr = String(self.newGroupId)
            var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION_FILTERED, params: ["param1": self.userIdentityProfileId, "param2": newGroupIdStr])
            getProfileCollection(jsonData)
        }
        closeFilterCollectionDialog()
        tableView.reloadData()
    }
    func closeFilterCollectionDialog() {
        filterCollectionView.removeFromSuperview()
    }    
    
    func refeshListAction () {
        let GET_PROFILE_COLLECTION = UTILITIES.IP + "get_profile_collection.php"
        var jsonData = JSON_DATA_SYNCH.jsonGetData(GET_PROFILE_COLLECTION, params: ["param1": userIdentityProfileId])
        getProfileCollection(jsonData)
        menu.toggleMenu(menuView)
        tableView.reloadData()
    }

    func searchProfilesAction () {
        println("Search")
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
    
    func getProfileCollection (jsonData: JSON) {
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
    }
}
