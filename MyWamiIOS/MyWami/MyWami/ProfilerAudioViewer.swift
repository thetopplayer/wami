//
//  ProfilerAudioViewer.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import AVFoundation

class ProfilerAudioViewer: UIViewController, UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate {
    
    let textCellIdentifier = "AudioTableViewCell"
    var audioProfilerModels = [AudioProfilerModel]()
    var numAudio = 0
    
    var audioTableView: UITableView = UITableView()
    var profilerAudioView = UIScrollView()
    func profilerAudioViewerDialog(profilerAudioView: UIScrollView, audioProfilerModels: [AudioProfilerModel], closeBtn: UIButton) -> UIView {
        self.profilerAudioView = profilerAudioView
        numAudio = audioProfilerModels.count
        audioTableView = UITableView()
        self.audioProfilerModels = audioProfilerModels
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.profilerAudioView.frame = CGRectMake(2, 2, 316, 298)
            audioTableView.frame = CGRectMake(2, 2, 308, 246)
            closeBtn.frame = CGRectMake(135, 260, 60, 20)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.profilerAudioView.frame = CGRectMake(2, 2, 316, 385)
            audioTableView.frame = CGRectMake(2, 2, 308, 323)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.profilerAudioView.frame = CGRectMake(2, 2, 370, 485)
            audioTableView.frame = CGRectMake(2, 2, 368, 423)
            closeBtn.frame = CGRectMake(155, 448, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6P {
            self.profilerAudioView.frame = CGRectMake(2, 2, 410, 555)
            audioTableView.frame = CGRectMake(2, 2, 403, 503)
            closeBtn.frame = CGRectMake(180, 520, 60, 20)
        }
        else if DeviceType.IS_IPAD {
            self.profilerAudioView.frame = CGRectMake(2, 2, 316, 385)
            audioTableView.frame = CGRectMake(5, 5, 305, 320)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        else {
            self.profilerAudioView.frame = CGRectMake(2, 2, 316, 385)
            audioTableView.frame = CGRectMake(5, 5, 305, 320)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        
        self.profilerAudioView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.profilerAudioView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.profilerAudioView.layer.borderWidth = 1.5
        
        audioTableView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        audioTableView.layer.borderWidth = 1.0
        audioTableView.delegate = self
        audioTableView.dataSource = self
        audioTableView.registerClass(AudioTableViewCell.self, forCellReuseIdentifier: "AudioTableViewCell")
        self.profilerAudioView.addSubview(audioTableView)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        self.profilerAudioView.addSubview(closeBtn)
        
        self.audioTableView.rowHeight = 50.0
        
        return profilerAudioView
    }
    
    func tableView(audioTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numAudio
    }
    
    func tableView(audioTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = audioTableView.dequeueReusableCellWithIdentifier("AudioTableViewCell", forIndexPath: indexPath) as! AudioTableViewCell
        
        if self.audioProfilerModels[indexPath.row].getAudioSongTitle() == "" {
            cell.audioSongTitle.text = self.audioProfilerModels[indexPath.row].getAudioFileName()
        }
        else {
            cell.audioSongTitle.text = self.audioProfilerModels[indexPath.row].getAudioSongTitle()
        }
        cell.audioSongTitle.font = UIFont.systemFontOfSize(13)
        cell.audioSongTitle.enabled = false
        cell.audioSongTitle.frame = CGRectMake(10, 0, 200, 20)
        cell.addSubview(cell.audioSongTitle)
        
        cell.processAudioBtn.setTitle("Play", forState: UIControlState.Normal)
        cell.processAudioBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.processAudioBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.processAudioBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.processAudioBtn.showsTouchWhenHighlighted = true
        cell.processAudioBtn.frame = CGRectMake(10, 23, 50, 20)
        cell.processAudioBtn.addTarget(self, action: "processAudio:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.processAudioBtn)
        
        cell.moreInfoBtn.setTitle("More Info", forState: UIControlState.Normal)
        cell.moreInfoBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.moreInfoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.moreInfoBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.moreInfoBtn.showsTouchWhenHighlighted = true
        cell.moreInfoBtn.frame = CGRectMake(75, 23, 70, 20)
        cell.moreInfoBtn.addTarget(self, action: "moreInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.moreInfoBtn)
        
        return cell
    }
    
    let UTILITIES = Utilities()
    var player = AVPlayer()
    var selectedRow = 0
    var sender = UIButton()
    func processAudio(sender: UIButton) {
        self.sender = sender
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.audioTableView)
        var indexPath: NSIndexPath = self.audioTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.selectedRow = row
        
        var btnTitle = sender.currentTitle
        if btnTitle == "Play" {
            var audioFileLocation = self.audioProfilerModels[selectedRow].getAudioFileLocation()
            var audioFileName = self.audioProfilerModels[selectedRow].getAudioFileName()
            var audioFile = UTILITIES.ASSETS_IP + audioFileLocation + audioFileName
            
            let url = audioFile
            let playerItem = AVPlayerItem( URL:NSURL( string:url ))
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "playerDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: playerItem)

            player = AVPlayer(playerItem:playerItem)
            player.rate = 1.0
            player.play()
            sender.setTitle("Stop", forState: UIControlState.Normal)
            sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
        else {
            sender.setTitle("Play", forState: UIControlState.Normal)
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            player.rate = 0.0
            player.pause()
        }
    }
    
    func playerDidFinishPlaying(note: NSNotification) {
        sender.setTitle("Play", forState: UIControlState.Normal)
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        player.rate = 0.0
        player.pause()

    }
    
    var moreInfoView = UIView()
    var moreInfoViewDialog = UIView()
    func moreInfo(sender: UIButton) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.audioTableView)
        var indexPath: NSIndexPath = self.audioTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        
        var audioProfilerModel = audioProfilerModels[row]
        var audioFileDecription = audioProfilerModel.getAudioFileDescription()
        var audioSongTitle = audioProfilerModel.getAudioSongTitle()
        var audioFileName = audioProfilerModel.getAudioFileName()

        var profilerAudioMoreInfo = ProfilerAudioMoreInfo()
        
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeMoreInfoDialog", forControlEvents: UIControlEvents.TouchUpInside)
        self.moreInfoViewDialog = profilerAudioMoreInfo.moreInfoDialog(moreInfoView, audioFileDecription: audioFileDecription,
                                                    audioSongTitle: audioSongTitle, audioFileName: audioFileName, closeBtn: closeBtn)
        profilerAudioView.addSubview(self.moreInfoViewDialog)
    }
    func closeMoreInfoDialog() {
        self.moreInfoViewDialog.removeFromSuperview()
    }
    
    func tableView(audioTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        audioTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRow = indexPath.row
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
