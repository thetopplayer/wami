//
//  AudioTableViewCell.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell  {
    
    var audioSongTitle : UITextField = UITextField()
    var audioFileName : UITextField = UITextField()
    var audioFileDescription : UITextField = UITextField()
    var processAudioBtn : UIButton = UIButton()
    var moreInfoBtn : UIButton = UIButton()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        self.audioFileName = UITextField(frame: CGRect(x: 5, y: 0, width: 216.00, height: 25.00));
//        self.audioFileDescription = UITextField(frame: CGRect(x: 5, y: 20, width: 216.00, height: 25.00));
//        
//        self.audioFileName.font = UIFont.systemFontOfSize(13)
//        self.audioFileDescription.font = UIFont.systemFontOfSize(13)
//        
//        
//        self.audioFileName.enabled = false
//        self.audioFileDescription.enabled = false
//        
//        self.addSubview(self.audioSongTitle)
//        self.addSubview(self.audioFileName)
//        self.addSubview(self.audioFileDescription)
//        self.addSubview(self.playBtn)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}