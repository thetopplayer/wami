//
//  ProfilerImageViewer.swift
//  MyWami
//
//  Created by Robert Lanter on 5/27/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit
import AVFoundation

class ProfilerImageViewer: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

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
        
        self.imageTableView.rowHeight = 70.0
        
        return profilerImageView
    }
    
    func tableView(imageTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numImage
    }
    
    func tableView(imageTableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = imageTableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as! ImageTableViewCell
        
        var imageFileName = self.imageProfilerModels[indexPath.row].getFileName()
        var imageFileLocation = self.imageProfilerModels[indexPath.row].getFileLocation()
        var imageGalleryImage = UTILITIES.ASSETS_IP + imageFileLocation + imageFileName
        cell.galleryImageView.layer.borderColor = UIColor.grayColor().CGColor
        cell.galleryImageView.layer.borderWidth = 1.0
        cell.galleryImageView.frame = CGRectMake(10, 10, 50, 50)
        let url = NSURL(string: imageGalleryImage)
        let data = NSData(contentsOfURL: url!)
        cell.galleryImageView.image = UIImage(data: data!)        
        cell.addSubview(cell.galleryImageView)
        
        if self.imageProfilerModels[indexPath.row].getImageName() == "" {
            cell.imageName.text = self.imageProfilerModels[indexPath.row].getFileName()
        }
        else {
            cell.imageName.text = self.imageProfilerModels[indexPath.row].getImageName()
        }
        cell.imageName.font = UIFont.systemFontOfSize(13)
        cell.imageName.enabled = false
        cell.imageName.frame = CGRectMake(80, 10, 200, 20)
        cell.addSubview(cell.imageName)
        
        cell.processImageBtn.setTitle("Show Image", forState: UIControlState.Normal)
        cell.processImageBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.processImageBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.processImageBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.processImageBtn.showsTouchWhenHighlighted = true
        cell.processImageBtn.frame = CGRectMake(80, 40, 75, 20)
        cell.processImageBtn.addTarget(self, action: "processImage:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.processImageBtn)
        
        cell.moreInfoBtn.setTitle("More Info", forState: UIControlState.Normal)
        cell.moreInfoBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        cell.moreInfoBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cell.moreInfoBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        cell.moreInfoBtn.showsTouchWhenHighlighted = true
        cell.moreInfoBtn.frame = CGRectMake(165, 40, 65, 20)
        cell.moreInfoBtn.addTarget(self, action: "moreInfo:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.addSubview(cell.moreInfoBtn)
    
        return cell
    }
    
    func tableView(imageTableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        imageTableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedRow = indexPath.row
        processImageView(self.selectedRow)
    }
    
    let UTILITIES = Utilities()
    var selectedRow = 0
    func processImage(sender: UIButton) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.imageTableView)
        var indexPath: NSIndexPath = self.imageTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        self.selectedRow = row
        
        var imageFileLocation = self.imageProfilerModels[selectedRow].getFileLocation()
        var imageFileLocationNoThumb = imageFileLocation.substringWithRange(Range<String.Index>(start: advance(imageFileLocation.startIndex, 0), end: advance(imageFileLocation.endIndex, -7) ))
        var imageFileName = self.imageProfilerModels[selectedRow].getFileName()
        var imageFile = UTILITIES.ASSETS_IP + imageFileLocationNoThumb + imageFileName
        showInWebViewer(imageFile)
    }
    
    func processImageView(row: Int) {
        var imageFileLocation = self.imageProfilerModels[selectedRow].getFileLocation()
        var imageFileLocationNoThumb = imageFileLocation.substringWithRange(Range<String.Index>(start: advance(imageFileLocation.startIndex, 0), end: advance(imageFileLocation.endIndex, -7) ))
        var imageFileName = self.imageProfilerModels[selectedRow].getFileName()
        var imageFile = UTILITIES.ASSETS_IP + imageFileLocationNoThumb + imageFileName
        showInWebViewer(imageFile)
    }
    
    var scrollViewer = UIScrollView()
    var webView = UIWebView()
    func showInWebViewer (inFile: String) {
        scrollViewer.frame = CGRectMake(2, 2, 316, 385)
        scrollViewer.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        scrollViewer.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        scrollViewer.layer.borderWidth = 1.5
        
        webView.frame = CGRectMake(5, 0, 306, 332)
        webView.loadRequest(NSURLRequest(URL: NSURL(string: inFile)!))
        webView.delegate = self;
        scrollViewer.addSubview(webView)
        
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.frame = CGRectMake(125, 348, 60, 20)
        closeBtn.addTarget(self, action: "closeWebViewer", forControlEvents: UIControlEvents.TouchUpInside)
        scrollViewer.addSubview(closeBtn)
        
        profilerImageView.addSubview(scrollViewer)
    }
    func closeWebViewer() {
        self.webView.removeFromSuperview()
        self.scrollViewer.removeFromSuperview()
    }
    
    var moreInfoView = UIView()
    var moreInfoViewDialog = UIView()
    func moreInfo(sender: UIButton) {
        var btnPos: CGPoint = sender.convertPoint(CGPointZero, toView: self.imageTableView)
        var indexPath: NSIndexPath = self.imageTableView.indexPathForRowAtPoint(btnPos)!
        let row = indexPath.row
        
        var imageProfilerModel = imageProfilerModels[row]
        var imageFileDecription = imageProfilerModel.getImageDescription()
        var imageName = imageProfilerModel.getImageName()
        var imageFileName = imageProfilerModel.getFileName()
        
        var profilerImageMoreInfo = ProfilerImageMoreInfo()
        
        let closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        closeBtn.addTarget(self, action: "closeMoreInfoDialog", forControlEvents: UIControlEvents.TouchUpInside)
        self.moreInfoViewDialog = profilerImageMoreInfo.moreInfoDialog(moreInfoView, imageFileDecription: imageFileDecription,
                                            imageName: imageName, imageFileName: imageFileName, closeBtn: closeBtn)
        profilerImageView.addSubview(self.moreInfoViewDialog)
    }
    func closeMoreInfoDialog() {
        self.moreInfoViewDialog.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}