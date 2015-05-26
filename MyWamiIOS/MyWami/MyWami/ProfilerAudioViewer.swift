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
        
        if self.audioProfilerModels[indexPath.row].getAudioSongTitle() == "" {
            cell.audioSongTitle.text = self.audioProfilerModels[indexPath.row].getAudioFileName()
        }
        else {
            cell.audioSongTitle.text = self.audioProfilerModels[indexPath.row].getAudioSongTitle()
        }
        cell.audioSongTitle.font = UIFont.systemFontOfSize(13)
        cell.audioSongTitle.enabled = false
        cell.audioSongTitle.frame = CGRectMake(5, 0, 200, 20)
        cell.addSubview(cell.audioSongTitle)
        
        cell.processAudioBtn.setTitle("Play", forState: UIControlState.Normal)
        cell.processAudioBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.processAudioBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.processAudioBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.processAudioBtn.showsTouchWhenHighlighted = true
        cell.processAudioBtn.frame = CGRectMake(5, 20, 50, 20)
        cell.processAudioBtn.addTarget(self, action: "processAudio:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.processAudioBtn)
        
        cell.moreInfoBtn.setTitle("More Info", forState: UIControlState.Normal)
        cell.moreInfoBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.moreInfoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.moreInfoBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.moreInfoBtn.showsTouchWhenHighlighted = true
        cell.moreInfoBtn.frame = CGRectMake(65, 20, 70, 20)
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
