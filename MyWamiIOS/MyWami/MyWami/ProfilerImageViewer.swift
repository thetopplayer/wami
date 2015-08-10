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
    var imageScrollView = UIScrollView()
    func profilerImageViewerDialog(imageScrollView: UIScrollView, imageProfilerModels: [ImageProfilerModel], closeBtn: UIButton) -> UIView {
        self.imageScrollView = imageScrollView
        numImage = imageProfilerModels.count
        imageTableView = UITableView()
        self.imageProfilerModels = imageProfilerModels
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            self.imageScrollView.frame = CGRectMake(0, 2, 317, 310)
            imageTableView.frame = CGRectMake(0, 0, 311, 255)
            closeBtn.frame = CGRectMake(135, 270, 60, 20)
        }
        else if DeviceType.IS_IPHONE_5 {
            self.imageScrollView.frame = CGRectMake(2, 2, 312, 385)
            imageTableView.frame = CGRectMake(3, 3, 307, 320)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6 {
            self.imageScrollView.frame = CGRectMake(2, 2, 370, 485)
            imageTableView.frame = CGRectMake(5, 5, 365, 420)
            closeBtn.frame = CGRectMake(155, 448, 60, 20)
        }
        else if DeviceType.IS_IPHONE_6P {
            self.imageScrollView.frame = CGRectMake(2, 2, 410, 555)
            imageTableView.frame = CGRectMake(3, 3, 402, 502)
            closeBtn.frame = CGRectMake(180, 520, 60, 20)
        }
        else if DeviceType.IS_IPAD {
            self.imageScrollView.frame = CGRectMake(2, 2, 316, 385)
            imageTableView.frame = CGRectMake(5, 5, 305, 320)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        else {
            self.imageScrollView.frame = CGRectMake(2, 2, 316, 385)
            imageTableView.frame = CGRectMake(5, 5, 305, 320)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
        }
        
        self.imageScrollView.backgroundColor = UIColor(red: 0xE8/255, green: 0xE8/255, blue: 0xE8/255, alpha: 1.0)
        self.imageScrollView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(1.0).CGColor
        self.imageScrollView.layer.borderWidth = 1.5
        
        imageTableView.layer.borderColor = UIColor.grayColor().colorWithAlphaComponent(1.0).CGColor
        imageTableView.layer.borderWidth = 1.0
        imageTableView.delegate = self
        imageTableView.dataSource = self
        imageTableView.registerClass(ImageTableViewCell.self, forCellReuseIdentifier: "ImageTableViewCell")
        self.imageScrollView.addSubview(imageTableView)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        self.imageScrollView.addSubview(closeBtn)
        
        self.imageTableView.rowHeight = 70.0
        
        return self.imageScrollView
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
    
    var webView = UIWebView()
    var scrollWebView = UIScrollView()
    func showInWebViewer (inFile: String) {
        var closeBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        var maxWidth: CGFloat = 0.0
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            scrollWebView.frame = CGRectMake(1, 2, 312, 290)
            webView.frame = CGRectMake(2, 1, 308, 247)
            closeBtn.frame = CGRectMake(134, 258, 60, 20)
            maxWidth = 308.0
        }
        else if DeviceType.IS_IPHONE_5 {
            scrollWebView.frame = CGRectMake(1, 2, 312, 385)
            webView.frame = CGRectMake(2, 1, 308, 322)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
            maxWidth = 308.0
        }
        else if DeviceType.IS_IPHONE_6 {
            scrollWebView.frame = CGRectMake(1, 2, 367, 485)
            webView.frame = CGRectMake(2, 1, 363, 422)
            closeBtn.frame = CGRectMake(154, 446, 60, 20)
            maxWidth = 363.0
        }
        else if DeviceType.IS_IPHONE_6P {
            scrollWebView.frame = CGRectMake(1, 2, 407, 565)
            webView.frame = CGRectMake(2, 1, 403, 502)
            closeBtn.frame = CGRectMake(179, 518, 60, 20)
            maxWidth = 403.0
        }
        else if DeviceType.IS_IPAD {
            scrollWebView.frame = CGRectMake(1, 2, 312, 385)
            webView.frame = CGRectMake(2, 1, 308, 322)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
            maxWidth = 308.0
        }
        else {
            scrollWebView.frame = CGRectMake(1, 2, 312, 385)
            webView.frame = CGRectMake(2, 1, 308, 322)
            closeBtn.frame = CGRectMake(135, 348, 60, 20)
            maxWidth = 308.0
        }
        
        webView.layer.borderColor = UIColor.lightGrayColor().CGColor
        webView.layer.borderWidth = 1.5
        
        let url = NSURL(string: inFile)
        let data = NSData(contentsOfURL: url!)
        var origHeight = UIImage(data: data!)?.size.height
        var origWidth = UIImage(data: data!)?.size.width
        
        var height = ""
        var width = ""
        var ratio: CGFloat = min(maxWidth / origWidth!, maxWidth / origHeight!)
        if (origHeight > maxWidth) {
            height = String(stringInterpolationSegment: origHeight! * ratio)
        }
        else {
            height = String(stringInterpolationSegment: origHeight!)
        }
        if (origWidth > maxWidth) {
            width = String(stringInterpolationSegment: origWidth! * ratio)
        }
        else {
            width = String(stringInterpolationSegment: origWidth!)
        }
        
        var imageHTMLString =  "<img src='" + inFile + "' width='" + width + "' height='" + height + "' >"
        webView.loadHTMLString(imageHTMLString, baseURL: nil)
        
        webView.delegate = self
        scrollWebView.addSubview(webView)
        
        closeBtn.setTitle("Close", forState: UIControlState.Normal)
        closeBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(11)
        closeBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        closeBtn.backgroundColor = UIColor(red: 0x66/255, green: 0xcc/255, blue: 0xcc/255, alpha: 1.0)
        closeBtn.showsTouchWhenHighlighted = true
        closeBtn.addTarget(self, action: "closeWebViewer", forControlEvents: UIControlEvents.TouchUpInside)
        scrollWebView.addSubview(closeBtn)
        
        imageScrollView.addSubview(scrollWebView)
    }
    func closeWebViewer() {
        scrollWebView.removeFromSuperview()
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
        imageScrollView.addSubview(self.moreInfoViewDialog)
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