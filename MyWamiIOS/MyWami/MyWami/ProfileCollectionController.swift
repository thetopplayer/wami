//
// Created by Robert Lanter on 3/4/15.
// Copyright (c) 2015 Robert Lanter. All rights reserved.
//

import Foundation
import UIKit

class ProfileCollectionController: UITableViewController {
    var identityProfileId: String!
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black

        let titleBar = UIImage(named: "actionbar_wami_list.png")
        let imageView2 = UIImageView(image:titleBar)
        self.navigationItem.titleView = imageView2

        var image : UIImage = UIImage(named:"wami1.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let backButton = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: "back:")
        navigationItem.leftBarButtonItem = backButton
//        self.navigationItem.leftBarButtonItem!.tintColor = UIColor.grayColor()
//        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 24)!], forState: UIControlState.Normal)
    }

    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
