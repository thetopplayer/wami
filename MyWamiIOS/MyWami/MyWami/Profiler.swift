//
//  Profiler.swift
//  MyWami
//
//  Created by Robert Lanter on 3/28/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class Profiler: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var profileNameText: UITextField!
    
    @IBOutlet var contactNameText: UITextField!
    
    @IBOutlet var profilerTableView: UITableView!
    
    let textCellIdentifier = "ProfilerTableViewCell"
    
    let JSONDATA = JsonGetData()
    let UTILITIES = Utilities()
   
    var identityProfileId: String!
    var userIdentityProfileId: String!
    var imageUrl: String!
    var profileName: String!
    var firstName: String!
    var lastName: String!
    
    var numCategories = 0
    var categories = [String]()
    
    let menuView = UIView()
    let transmitThisWamiBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let navigateToBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let homeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let logoutBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var menuLine = UILabel()

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
        JSONDATA.jsonGetData(getProfilerData, url: GET_PROFILER_DATA, params: ["param1": identityProfileId])
        
        usleep(100000)
        
        profilerTableView.dataSource = self
        profilerTableView.delegate = self
    }
    
    func showMenu(sender: UIBarButtonItem) {
        toggleMenu(menuView)
        menuView.setTranslatesAutoresizingMaskIntoConstraints(false)
        menuView.backgroundColor = UIColor(red: 0x66/255, green: 0x66/255, blue: 0x66/255, alpha: 0.95)
        view.addSubview(menuView)
        
        transmitThisWamiBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        transmitThisWamiBtn.setTitle("Transmit This Wami...", forState: UIControlState.Normal)
        transmitThisWamiBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitThisWamiBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        transmitThisWamiBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(transmitThisWamiBtn)
        
        navigateToBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        navigateToBtn.setTitle("Navigate To...", forState: UIControlState.Normal)
        navigateToBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        navigateToBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        navigateToBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(navigateToBtn)
        
        homeBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        homeBtn.setTitle("Home", forState: UIControlState.Normal)
        homeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        homeBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(homeBtn)
        
        logoutBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        logoutBtn.setTitle("Logout", forState: UIControlState.Normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logoutBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        logoutBtn.showsTouchWhenHighlighted = true
        menuView.addSubview(logoutBtn)
        
        menuLine = createMenuLine(0)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(25)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(50)
        menuView.addSubview(menuLine)
        
        menuLine = createMenuLine(75)
        menuView.addSubview(menuLine)
        
        let viewsDictionary = ["menuView":menuView, "homeBtn":homeBtn, "transmitThisWamiBtn":transmitThisWamiBtn, "navigateToBtn":navigateToBtn, "logoutBtn":logoutBtn]
        
        //size of menu
        let menuView_constraint_H:Array = NSLayoutConstraint.constraintsWithVisualFormat("H:[menuView(150)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let menuView_constraint_V:Array = NSLayoutConstraint.constraintsWithVisualFormat("V:[menuView(>=100)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(menuView_constraint_H)
        menuView.addConstraints(menuView_constraint_V)
        
        //placement of menu
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-157-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-67-[menuView]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_V)
        
        //placement of transmit button
        let transmit_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[transmitThisWamiBtn(>=80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let transmit_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[transmitThisWamiBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(transmit_constraint_H)
        menuView.addConstraints(transmit_constraint_V)
        
        //placement of navigate to button
        let navigateTo_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[navigateToBtn(>=80)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let navigateTo_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-23-[navigateToBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(navigateTo_constraint_H)
        menuView.addConstraints(navigateTo_constraint_V)
        
        //placement of home button
        let home_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[homeBtn(>=37)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let home_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-47-[homeBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        menuView.addConstraints(home_constraint_H)
        menuView.addConstraints(home_constraint_V)
        
        //placement of logout button
        let logout_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[logoutBtn(>=40)]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let logout_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-73-[logoutBtn]", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
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
        line.frame = CGRectMake(0, CGFloat(25 + offset), 150, 1)
        line.backgroundColor = UIColor.grayColor()
        return line
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
    
    func numberOfSectionsInTableView(profilerTableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(profilerTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numCategories
    }
    
    func tableView(profilerTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = profilerTableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as ProfilerTableViewCell
        cell.profileCategoryText.text = self.categories[indexPath.row]
        
        return cell
    }
    
    func tableView(profilerTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        profilerTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Callback function - getProfileName
    func getProfilerData (jsonData: JSON) {
        var retCode = jsonData["ret_code"]
        if retCode == 1 {
            var message = jsonData["message"].string
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.UTILITIES.alertMessage(message!, viewController: self)
            }
        }
        else {
            let numCategories: Int! = jsonData["identity_profiler_data"].array?.count
            self.numCategories = numCategories
            for index in 0...numCategories - 1 {
                var categoryName = jsonData["identity_profiler_data"][index]["category"].string!
                categories.append(categoryName)
            }
        }
    }
}





