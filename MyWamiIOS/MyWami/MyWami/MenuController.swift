//
//  MenuController.swift
//  MyWami
//
//  Created by Robert Lanter on 3/29/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class MenuController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    let menuCellIdentifier = "MenuTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath: indexPath) as MenuTableViewCell
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let row = indexPath.row
    }

}