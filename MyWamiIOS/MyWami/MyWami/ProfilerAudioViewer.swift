//
//  ProfilerAudioViewer.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfilerAudioViewer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let textCellIdentifier = "AudioViewCell"
    
    var audioTableView: UITableView = UITableView()
    var profilerAudioView = UIView()
    func profilerAudioViewerDialog(profilerAudioView: UIView, closeBtn: UIButton) -> UIView{
        self.profilerAudioView = profilerAudioView
        
        self.profilerAudioView.frame = CGRectMake(2, 2, 316, 385)
        self.profilerAudioView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.profilerAudioView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.profilerAudioView.layer.borderWidth = 1.5
        
        audioTableView.frame = CGRectMake(0, 50, 320, 200);
        audioTableView.delegate = self
        audioTableView.dataSource = self
        audioTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AudioViewCell")
        self.profilerAudioView.addSubview(audioTableView)
        

        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(125, 348, 60, 20)
        self.profilerAudioView.addSubview(closeBtn)
        
        return profilerAudioView
    }
    
    func tableView(audioTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(audioTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = audioTableView.dequeueReusableCellWithIdentifier("AudioViewCell") as! UITableViewCell
    
        cell.textLabel?.text = self.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(audioTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
