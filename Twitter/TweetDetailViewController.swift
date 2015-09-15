//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/14/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    @IBOutlet weak var userProfilePicView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userTweetLabel: UILabel!
    @IBOutlet weak var userTweetDateLabel: UILabel!
    @IBOutlet weak var favoriteView: UIImageView!
    @IBOutlet weak var retweetView: UIImageView!

    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let url = tweet.user?.profileImageUrl
        userNameLabel.text = tweet.user?.name
        userTweetLabel.text = tweet.text
        userTweetDateLabel.text = tweet.formattedCreatedAtString
        userProfilePicView.setImageWithURL(NSURL(string: url!))
        
        if (tweet.favorited > 0) {
            favoriteView.image = UIImage(named: "favorite_on")
        }
        if (tweet.retweeted > 0) {
            retweetView.image = UIImage(named: "retweet_on")
        }
        
        var tapGestureRecognizerFavorite = UITapGestureRecognizer(target:self, action:Selector("onFavorite:"))
        var tapGestureRecognizerRetweet = UITapGestureRecognizer(target:self, action:Selector("onRetweet:"))
        favoriteView.addGestureRecognizer(tapGestureRecognizerFavorite)
        retweetView.addGestureRecognizer(tapGestureRecognizerRetweet)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onFavorite(img: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id, completion: { (res, error) -> Void in
            if error == nil {
                self.favoriteView.image = UIImage(named: "favorite_on")
            }
        })
    }

    func onRetweet(img: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion(tweet.id, completion: { (res, error) -> Void in
            if error == nil {
                self.retweetView.image = UIImage(named: "retweet_on")
            }
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let navigationController = segue.destinationViewController as! UINavigationController
        let tweetViewController = navigationController.topViewController as! TweetViewController
        tweetViewController.replyTo = tweet.id
    }
}
