//
// Created by Robert Lanter on 3/4/15.
// Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfileCollectionController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    @IBAction func transmitButtonPressed(sender: AnyObject) {
       
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
    let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let logoutBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var menuLine = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let GET_DEFAULT_PROFILE_COLLECTION = UTILITIES.IP + "get_default_profile_collection.php"
        JSONDATA.jsonGetData(getDefaultProfileCollection, url: GET_DEFAULT_PROFILE_COLLECTION, params: ["param1": userId])

        usleep(100000)

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
    
    func showMenu(sender: UIBarButtonItem) {
        toggleMenu(menuView)
        menuView.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuView.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.9)
        view.addSubview(menuView)
        
        transmitBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        transmitBtn.setTitle("Transmit Profile(s)...", forState: UIControlState.Normal)
        transmitBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        transmitBtn.addTarget(self, action: "transmitProfileAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        menuView.addSubview(transmitBtn)
        
        logoutBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        logoutBtn.setTitle("Logout", forState: UIControlState.Normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logoutBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        menuView.addSubview(logoutBtn)
        
        menuLine = createMenuLine(0)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(28)
        menuView.addSubview(menuLine)
        
        let viewsDictionary = ["menuView":menuView, "transmitBtn":transmitBtn, "logoutBtn":logoutBtn, "menuLine":menuLine]
        
        //size of menu
        let menuView_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[menuView(140)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let menuView_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuView(>=270)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(menuView_constraint_H)
        menuView.addConstraints(menuView_constraint_V)
        
        //placement of menu
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-165-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_V)
        
        //placement of transmit button
        let transmit_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[transmitBtn(>=80)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
        let transmit_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[transmitBtn(40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(transmit_constraint_H)
        menuView.addConstraints(transmit_constraint_V)
        
        //placement of logout button
        let logout_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logoutBtn(>=45)]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
        let logout_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:[logoutBtn(85)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(logout_constraint_H)
        menuView.addConstraints(logout_constraint_V)

    }
    
    func toggleMenu (menuView: UIView) {
        if menuView.hidden {
            menuView.hidden = false
        }
        else {
            menuView.hidden = true
        }
    }
    
    func createMenuLine (offset: Int) -> UILabel {
        var line: UILabel = UILabel()
        line.frame = CGRectMake(0, CGFloat(32 + offset), 140, 1)
        line.backgroundColor = UIColor.grayColor()
        return line
    }
    
    func transmitProfileAction () {
        println("transmit")
    }
    
    func logoutAction () {
        println("logout")
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
