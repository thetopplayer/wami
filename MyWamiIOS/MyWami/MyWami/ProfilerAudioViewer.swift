//
//  ProfilerAudioViewer.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class ProfilerAudioViewer: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let textCellIdentifier = "AudioTableViewCell"
    var audioProfilerModels = [AudioProfilerModel]()
    var numAudio = 0
    var audioFileNameCell: UITableViewCell = UITableViewCell()
    var audioFileNameText: UITextField = UITextField()
    
    var audioTableView: UITableView = UITableView()
    var profilerAudioView = UIScrollView()
    func profilerAudioViewerDialog(profilerAudioView: UIScrollView, audioProfilerModels: [AudioProfilerModel], closeBtn: UIButton) -> UIView{
        self.profilerAudioView = profilerAudioView
        numAudio = audioProfilerModels.count
        self.audioProfilerModels = audioProfilerModels
        
        self.profilerAudioView.frame = CGRectMake(2, 2, 316, 385)
        self.profilerAudioView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.profilerAudioView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.profilerAudioView.layer.borderWidth = 1.5
        
        audioTableView.frame = CGRectMake(5, 5, 305, 320)
        audioTableView.delegate = self
        audioTableView.dataSource = self
        audioTableView.registerClass(AudioTableViewCell.self, forCellReuseIdentifier: "AudioTableViewCell")
                
        self.profilerAudioView.addSubview(audioTableView)
        
        self.audioFileNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.audioFileNameText.frame = CGRectMake(2, 2, 40, 20)
        self.audioFileNameText.placeholder = "First Name"
        self.audioFileNameCell.addSubview(self.audioFileNameText)

        
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
        return numAudio
    }
    
    func tableView(audioTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = audioTableView.dequeueReusableCellWithIdentifier("AudioTableViewCell", forIndexPath: indexPath) as! AudioTableViewCell
        
        cell.audioSongTitle.text = self.audioProfilerModels[indexPath.row].getAudioSongTitle()
        cell.audioFileDescription.text = self.audioProfilerModels[indexPath.row].audioFileDescription
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
