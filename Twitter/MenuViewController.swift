//
//  MenuViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/21/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private var tweetsNavigationController: UINavigationController!
    private var profileNavigationController: UINavigationController!
    private var mentionsNavigationController: UIViewController!


    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetsNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavController") as! UINavigationController
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavController") as! UINavigationController
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavController") as! UIViewController
        
        viewControllers.append(tweetsNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)

        let tweetVC = tweetsNavigationController.topViewController as! TweetsViewController
        tweetVC.menuViewController = self
        hamburgerViewController.contentViewController = tweetsNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let titles = ["Timeline", "Profile", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if indexPath.row == 1 {
            let profileVC = profileNavigationController.topViewController as! ProfileViewController
            profileVC.user = nil
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
            profileVC.viewDidLoad()
        } else {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        }
    }
    
    func goToProfile(user: User?) {
        let profileVC = profileNavigationController.topViewController as! ProfileViewController
        profileVC.user = user
        hamburgerViewController.contentViewController = profileNavigationController
        profileVC.viewDidLoad()
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
