//
//  Menu.swift
//  MyWami
//
//  Created by Robert Lanter on 4/1/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation
import UIKit

class Menu {
    
    let selectCollectionBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let filterByGroupBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let transmitBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let refeshListBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let searchProfilesBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    
    let transmitThisWamiBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let addToContactListBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let navigateToBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    let homeBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton

    let logoutBtn = UIButton.buttonWithType(UIButtonType.System) as UIButton
    var menuLine = UILabel()
    
    func menuButtons() {
        selectCollectionBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        selectCollectionBtn.setTitle("Select a Profile Collection...", forState: UIControlState.Normal)
        selectCollectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        selectCollectionBtn.addTarget(self, action: "selectCollectionAction", forControlEvents: UIControlEvents.TouchUpInside)
        selectCollectionBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        selectCollectionBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        selectCollectionBtn.showsTouchWhenHighlighted = true
        
        filterByGroupBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        filterByGroupBtn.setTitle("Filter Collection by Group...", forState: UIControlState.Normal)
        filterByGroupBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        filterByGroupBtn.addTarget(self, action: "filterByGroupAction", forControlEvents: UIControlEvents.TouchUpInside)
        filterByGroupBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterByGroupBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        filterByGroupBtn.showsTouchWhenHighlighted = true
        
        transmitBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        transmitBtn.setTitle("Transmit Profile(s)...", forState: UIControlState.Normal)
        transmitBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        transmitBtn.addTarget(self, action: "transmitProfileAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        transmitBtn.showsTouchWhenHighlighted = true
        
        refeshListBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        refeshListBtn.setTitle("Refresh Wami List", forState: UIControlState.Normal)
        refeshListBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        refeshListBtn.addTarget(self, action: "refeshListAction", forControlEvents: UIControlEvents.TouchUpInside)
        refeshListBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        refeshListBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        refeshListBtn.showsTouchWhenHighlighted = true
        
        searchProfilesBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchProfilesBtn.setTitle("Search for Profiles...", forState: UIControlState.Normal)
        searchProfilesBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        searchProfilesBtn.addTarget(self, action: "searchProfilesAction", forControlEvents: UIControlEvents.TouchUpInside)
        searchProfilesBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchProfilesBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        searchProfilesBtn.showsTouchWhenHighlighted = true
        
        transmitThisWamiBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        transmitThisWamiBtn.setTitle("Transmit This Wami...", forState: UIControlState.Normal)
        transmitThisWamiBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        transmitThisWamiBtn.addTarget(self, action: "transmitThisWamiAction", forControlEvents: UIControlEvents.TouchUpInside)
        transmitThisWamiBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        transmitThisWamiBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        transmitThisWamiBtn.showsTouchWhenHighlighted = true
        
        navigateToBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        navigateToBtn.setTitle("Navigate To...", forState: UIControlState.Normal)
        navigateToBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        navigateToBtn.addTarget(self, action: "navigateToAction", forControlEvents: UIControlEvents.TouchUpInside)
        navigateToBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        navigateToBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        navigateToBtn.showsTouchWhenHighlighted = true
        
        addToContactListBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        addToContactListBtn.setTitle("Add To Contact List...", forState: UIControlState.Normal)
        addToContactListBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        addToContactListBtn.addTarget(self, action: "addToContactListAction", forControlEvents: UIControlEvents.TouchUpInside)
        addToContactListBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addToContactListBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        addToContactListBtn.showsTouchWhenHighlighted = true
        
        homeBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        homeBtn.setTitle("Home", forState: UIControlState.Normal)
        homeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        homeBtn.addTarget(self, action: "homeAction", forControlEvents: UIControlEvents.TouchUpInside)
        homeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        homeBtn.showsTouchWhenHighlighted = true
        
        logoutBtn.setTranslatesAutoresizingMaskIntoConstraints(false)
        logoutBtn.setTitle("Logout", forState: UIControlState.Normal)
        logoutBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        logoutBtn.addTarget(self, action: "logoutAction", forControlEvents: UIControlEvents.TouchUpInside)
        logoutBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logoutBtn.backgroundColor = UIColor(red: 0x33/255, green: 0x33/255, blue: 0x33/255, alpha: 0.0)
        logoutBtn.showsTouchWhenHighlighted = true
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
    
}