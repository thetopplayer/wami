//
//  AudioTableViewCell.swift
//  MyWami
//
//  Created by Robert Lanter on 5/23/15.
//  Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import UIKit

class AudioTableViewCell: UITableViewCell  {
    
    var audioFileNameText : UITextField = UITextField()
    var audioFileDescriptionText : UITextField = UITextField()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!)
    {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Initialize Text Field
        self.audioFileNameText = UITextField(frame: CGRect(x: 5, y: 9, width: 216.00, height: 31.00));
        self.audioFileDescriptionText = UITextField(frame: CGRect(x: 200, y: 9, width: 216.00, height: 31.00));
        
        self.audioFileNameText.font = UIFont.systemFontOfSize(13)
        self.audioFileDescriptionText.font = UIFont.systemFontOfSize(13)
        
        //Add TextField to SubView
        self.addSubview(self.audioFileNameText)
        self.addSubview(self.audioFileDescriptionText)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}