//
//  TweetCell.swift
//  Twitter
//
//  Created by Zhi Huang on 9/14/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var tweetDateLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var favoriteView: UIImageView!
    @IBOutlet weak var retweetView: UIImageView!
    @IBOutlet weak var profilePicButton: UIButton!
    
    var menuViewController: MenuViewController?
    
    var tweet: Tweet! {
        didSet {
            let url = tweet.user?.profileImageUrl
            profileNameLabel.text = tweet.user?.name
            tweetDateLabel.text = tweet.formattedCreatedAtString
            tweetContentLabel.text = tweet.text
            profilePic.setImageWithURL(NSURL(string: url!))

            if (tweet.favorited > 0) {
                favoriteView.image = UIImage(named: "favorite_on")
            } else {
                favoriteView.image = UIImage(named: "favorite")

            }
            if (tweet.retweeted > 0) {
                retweetView.image = UIImage(named: "retweet_on")
            } else {
                retweetView.image = UIImage(named: "retweet")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profilePic.layer.cornerRadius = 5
        profilePic.clipsToBounds = true
        profileNameLabel.preferredMaxLayoutWidth = profileNameLabel.frame.size.width
        tweetDateLabel.preferredMaxLayoutWidth = tweetDateLabel.frame.size.width
        tweetContentLabel.preferredMaxLayoutWidth = tweetContentLabel.frame.size.width
        
        var tapGestureRecognizerFavorite = UITapGestureRecognizer(target:self, action:Selector("onFavorite:"))
        var tapGestureRecognizerRetweet = UITapGestureRecognizer(target:self, action:Selector("onRetweet:"))
        favoriteView.addGestureRecognizer(tapGestureRecognizerFavorite)
        retweetView.addGestureRecognizer(tapGestureRecognizerRetweet)
    }
    
    func onFavorite(img: AnyObject) {
        TwitterClient.sharedInstance.favoriteWithCompletion(tweet.id, completion: { (res, error) -> Void in
            if error == nil {
                self.favoriteView.image = UIImage(named: "favorite_on")
                self.tweet.favorited = 1
            }
        })
    }
    
    func onRetweet(img: AnyObject) {
        TwitterClient.sharedInstance.retweetWithCompletion(tweet.id, completion: { (res, error) -> Void in
            if error == nil {
                self.retweetView.image = UIImage(named: "retweet_on")
                self.tweet.retweeted = 1
            }
        })
    }

    @IBAction func onProfileTap(sender: AnyObject) {
        menuViewController?.goToProfile(tweet.user!)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
