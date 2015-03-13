//
//  FCFoundsViewController.swift
//  ForeignChat
//
//  Created by Tonny.hao on 3/13/15.
//  Copyright (c) 2015 JohnnyHao. All rights reserved.
//

import UIKit

class FCFoundsViewController: UIViewController {
    
    class func instanceFromStoryBoard() -> (FCFoundsViewController) {
        return UIStoryboard(name: "FCFounds", bundle: nil).instantiateViewControllerWithIdentifier("FCFoundsViewController") as (FCFoundsViewController)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.image = UIImage(named:"tab_groups")
        self.tabBarItem.title = "Founds";
        self.title = "Founds";
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
