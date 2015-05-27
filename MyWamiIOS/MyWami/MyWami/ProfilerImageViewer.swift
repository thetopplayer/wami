//
//  ProfilerImageViewer.swift
//  MyWami
//
//  Created by Robert Lanter on 5/27/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import AVFoundation

class ProfilerImageViewer: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let textCellIdentifier = "ImageTableViewCell"
    var imageProfilerModels = [ImageProfilerModel]()
    var numImage = 0
    
    var imageTableView: UITableView = UITableView()
    var profilerImageView = UIScrollView()
    func profilerImageViewerDialog(profilerImageView: UIScrollView, imageProfilerModels: [ImageProfilerModel], closeBtn: UIButton) -> UIView {
        self.profilerImageView = profilerImageView
        numImage = imageProfilerModels.count
        self.imageProfilerModels = imageProfilerModels
        
        self.profilerImageView.frame = CGRectMake(2, 2, 316, 385)
        self.profilerImageView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.profilerImageView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.profilerImageView.layer.borderWidth = 1.5
        
        imageTableView.frame = CGRectMake(5, 5, 305, 320)
        imageTableView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        imageTableView.layer.borderWidth = 1.0
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.registerClass(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        self.profilerImageView.addSubview(imageTableView)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(135, 348, 60, 20)
        self.profilerImageView.addSubview(closeBtn)
        
        self.imageTableView.rowHeight = 50.0
        
        return profilerImageView
    }
    
    func tableView(imageTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numImage
    }
    
    func tableView(imageTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = imageTableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as! ImageTableViewCell
        
        if self.imageProfilerModels[indexPath.row].getImageName() == "" {
            cell.imageName.text = self.imageProfilerModels[indexPath.row].getFileName()
        }
        else {
            cell.imageName.text = self.imageProfilerModels[indexPath.row].getImageName()
        }
        cell.imageName.font = UIFont.systemFontOfSize(13)
        cell.imageName.enabled = false
        cell.imageName.frame = CGRectMake(10, 0, 200, 20)
        cell.addSubview(cell.imageName)
        
        cell.processImageBtn.setTitle("Show Image", forState: UIControlState.Normal)
        cell.processImageBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.processImageBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.processImageBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.processImageBtn.showsTouchWhenHighlighted = true
        cell.processImageBtn.frame = CGRectMake(10, 23, 50, 20)
        cell.processImageBtn.addTarget(self, action: "processImage:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.processImageBtn)
        
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
    func processImage(sender: UIButton) {
        self.sender = sender
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.imageTableView)
        var indexPath: NSIndexPath = self.imageTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.selectedRow = row
        
        var btnTitle = sender.currentTitle
        if btnTitle == "Play" {
            var imageFileLocation = self.imageProfilerModels[selectedRow].getFileLocation()
            var imageFileName = self.imageProfilerModels[selectedRow].getFileName()
            var imageFile = UTILITIES.ASSETS_IP + imageFileLocation + imageFileName
            
            let url = imageFile
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
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.imageTableView)
        var indexPath: NSIndexPath = self.imageTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        
        var imageProfilerModel = imageProfilerModels[row]
        var imageFileDecription = imageProfilerModel.getImageDescription()
        var imageSongTitle = imageProfilerModel.getImageName()
        var imageFileName = imageProfilerModel.getFileName()
        
//        var profilerImageMoreInfo = ProfilerImageMoreInfo()
//        
//        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
//        closeBtn.addTarget(self, action: "closeMoreInfoDialog", forControlEvents: UIControlEvents.TouchUpInside)
//        self.moreInfoViewDialog = profilerImageMoreInfo.moreInfoDialog(moreInfoView, imageFileDecription: imageFileDecription,
//            imageSongTitle: imageSongTitle, imageFileName: imageFileName, closeBtn: closeBtn)
//        imageTableView.addSubview(self.moreInfoViewDialog)
    }
    func closeMoreInfoDialog() {
        self.moreInfoViewDialog.removeFromSuperview()
    }
    
    func tableView(imageTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        imageTableView.deselectRowAtIndexPath(indexPath, animated: true)
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