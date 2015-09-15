//
//  TweetViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/14/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var userProfilePicView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTweetView: UITextView!
    
    var replyTo: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userTweetView.becomeFirstResponder()
        userNameLabel.text = User.currentUser?.name
        let url = User.currentUser?.profileImageUrl
        userProfilePicView.setImageWithURL(NSURL(string: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweetButton(sender: AnyObject) {

        let tweetMsg = userTweetView.text
        if count(tweetMsg) != 0 {
            println(replyTo)
            println(replyTo != nil)
            if replyTo != nil {
                TwitterClient.sharedInstance.replyWithCompletion(tweetMsg, id: replyTo, completion: { (res, error) -> Void in
                    if error == nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        // Hohoho broke
                    }
                })
            } else {
                TwitterClient.sharedInstance.tweetWithCompletion(userTweetView.text, completion: { (res, error) -> () in
                    if error == nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        // Hohoho broke
                    }
                })
            }
        }
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
