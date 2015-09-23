//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/21/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = User.currentUser
        }
        let profileUrl = user!.profileImageUrl
        let backgroundUrl = user!.backgroundImageUrl
        
        nameLabel.text = user!.name
        tweetCountLabel.text = "\(user!.tweetCount!)"
        followersCountLabel.text = "\(user!.followersCount!)"
        followingCountLabel.text = "\(user!.followingCount!)"
        
        profileImageView.setImageWithURL(NSURL(string: profileUrl!))
        backgroundImageView.setImageWithURL(NSURL(string: backgroundUrl!))

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
