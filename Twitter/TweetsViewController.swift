//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Zhi Huang on 9/14/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var menuViewController: MenuViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 150
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        // Do any additional setup after loading the view.
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSignout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func onRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.refreshControl.endRefreshing()
            self.tweets = tweets
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        cell.menuViewController = menuViewController
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "TweetDetail") {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            
            let tweet = tweets![indexPath.row]
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            tweetDetailViewController.tweet = tweet
        } else if (segue.identifier == "ReplyTweet") {
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as!UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)!
            
            let tweet = tweets![indexPath.row]
            let navigationController = segue.destinationViewController as! UINavigationController
            let tweetViewController = navigationController.topViewController as! TweetViewController
            tweetViewController.replyTo = tweet.id
        }
    }
}
