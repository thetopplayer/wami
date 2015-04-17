//
// Created by Robert Lanter on 3/4/15.
// Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfileCollectionController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func transmitButtonPressed(sender: AnyObject) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        var indexPath: NSIndexPath = self.tableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        selectedIdentityProfileId = identityProfileIds[row]
        transmitThisWamiAction()
    }
    // Transmit profile
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
        transmitProfile.transmit(userIdentityProfileId, identityProfileId: selectedIdentityProfileId)
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

    let JSONDATA = JsonGetData()
    let UTILITIES = Utilities()

    var profileNames = [String]()
    var firstNames = [String]()
    var lastNames = [String]()
    var imageUrls = [String]()
    var emails = [String]()
    var telephones = [String]()
    var identityProfileIds = [String]()
    var assignToIdentityProfileIds = [String]()

    let textCellIdentifier = "ProfileListTableViewCell"
    var row = 0
    var numProfiles = 0
    
    let menuView = UIView()
    var menuLine = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let GET_DEFAULT_PROFILE_COLLECTION = UTILITIES.IP + "get_default_profile_collection.php"
        JSONDATA.jsonGetData(getDefaultProfileCollection, url: GET_DEFAULT_PROFILE_COLLECTION, params: ["param1": userId])

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
        menuView.frame = CGRectMake(130, 2, 180, 150)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.95)
        menuView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        menuView.layer.borderWidth = 1.5
        view.addSubview(menuView)
        
        menu.toggleMenu(menuView)
        
        var selectCollectionBtn = menu.setMenuBtnAttributes("Select a Profile Collection...")
        selectCollectionBtn.addTarget(self, action: "selectCollectionAction", forControlEvents: UIControlEvents.TouchUpInside)
        selectCollectionBtn.frame = CGRectMake(0, 0, 175, 20)
        menuView.addSubview(selectCollectionBtn)
        
        var filterByGroupBtn = menu.setMenuBtnAttributes("Filter Collection by Group...")
        filterByGroupBtn.addTarget(self, action: "filterByGroupAction", forControlEvents: UIControlEvents.TouchUpInside)
        filterByGroupBtn.frame = CGRectMake(0, 25, 175, 20)
        menuView.addSubview(filterByGroupBtn)
        
        var transmitBtn = menu.setMenuBtnAttributes("Transmit Profile(s)...")
        transmitBtn.addTarget(self, action: "transmitProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitBtn.frame = CGRectMake(-24, 50, 175, 20)
        menuView.addSubview(transmitBtn)
        
        var refeshListBtn = menu.setMenuBtnAttributes("Refresh Wami List")
        refeshListBtn.addTarget(self, action: "refeshListAction", forControlEvents: UIControlEvents.TouchUpInside)
        refeshListBtn.frame = CGRectMake(-27, 75, 175, 20)
        menuView.addSubview(refeshListBtn)
        
        var searchProfilesBtn = menu.setMenuBtnAttributes("Search for Profiles...")
        searchProfilesBtn.addTarget(self, action: "searchProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        searchProfilesBtn.frame = CGRectMake(-21, 100, 175, 20)
        menuView.addSubview(searchProfilesBtn)
        
        var logoutBtn = menu.setMenuBtnAttributes("Logout")
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.frame = CGRectMake(-58, 125, 175, 20)
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
    
    func transmitProfilesAction() {
        
    }
    
    func selectCollectionAction () {
        println("selectup")
    }
    
    func filterByGroupAction () {
        println("filter by group")
    }
    
    func refeshListAction () {
        println("Refresh")
    }

    func searchProfilesAction () {
        println("Search")
    }
    
    func logoutAction () {
        self.navigationController!.popToViewController(navigationController!.viewControllers[0] as UIViewController, animated: true)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as ProfileListTableViewCell
        
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
            var svc = segue.destinationViewController as WamiInfoExtended;
            svc.identityProfileId = self.identityProfileIds[self.row]
            svc.userIdentityProfileId = self.userIdentityProfileId
        }
    }

    //Callback function - getDefaultProfileCollection
    func getDefaultProfileCollection (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            let numProfiles: Int! = jsonData["profile_collection"].array?.count
            self.numProfiles = numProfiles
            for index in 0...numProfiles - 1 {
                var profileName = jsonData["profile_collection"][index]["profile_name"].string!
                profileNames.append(profileName)

                var firstName = jsonData["profile_collection"][index]["first_name"].string!
                firstNames.append(firstName)

                var lastName = jsonData["profile_collection"][index]["last_name"].string!
                lastNames.append(lastName)

                var imageUrl = jsonData["profile_collection"][index]["image_url"].string!
                imageUrls.append(imageUrl)

                var email = jsonData["profile_collection"][index]["email"].string!
                emails.append(email)

                var telephone = jsonData["profile_collection"][index]["telephone"].string!
                telephones.append(telephone)

                var identityProfileId = jsonData["profile_collection"][index]["identity_profile_id"].string!
                identityProfileIds.append(identityProfileId)

                var assignToIdentityProfileId = jsonData["profile_collection"][index]["assign_to_identity_profile_id"].string!
                assignToIdentityProfileIds.append(assignToIdentityProfileId)
            }
        }
    }
}
