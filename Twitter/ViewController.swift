//
//  ViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/13/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var window: UIWindow?
    var storyboard_temp = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error: NSError?) in
            if user != nil {
//                let hamburgerViewController = self.storyboard_temp.instantiateViewControllerWithIdentifier("HamburgerViewController") as! HamburgerViewController
//                let menuViewController = self.storyboard_temp.instantiateViewControllerWithIdentifier("MenuViewController") as! MenuViewController
//                menuViewController.hamburgerViewController = hamburgerViewController
//                hamburgerViewController.menuViewController = menuViewController
//                
//                self.window?.rootViewController = hamburgerViewController
                self.performSegueWithIdentifier("loginSegue", sender: self)
            } else {
                // handle login error
            }
        }

    }

}

