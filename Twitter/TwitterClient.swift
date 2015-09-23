//
//  TwitterClient.swift
//  Twitter
//
//  Created by Zhi Huang on 9/13/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

let twitterConsumerKey = "kMnMpxzjjlCKjRLYDOKxzKljs"
let twitterConsumerSecret = "IIuB6F9vXAaD4cUWQPGFS0KicbUGEttvz5QKmHIhxS2g1Mxkjv"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
//            println("home timeline: \(response)")
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error getting home timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func mentionTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/mentions_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            completion(tweets: tweets, error: nil)
        }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            println("error getting mention timeline")
            completion(tweets: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("Got request token")
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL!)
            
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func tweetWithCompletion(status: String!, completion: (res: AnyObject?, error: NSError?) ->Void) {
        POST("1.1/statuses/update.json", parameters: ["status": status], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(res: response, error: nil)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(res: nil, error: error)
        }
    }
    
    func replyWithCompletion(status: String!, id: Int!, completion: (res: AnyObject?, error: NSError?) ->Void) {
        POST("1.1/statuses/update.json", parameters: ["status": status, "in_reply_to_status_id": id], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(res: response, error: nil)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            completion(res: nil, error: error)
        }
    }
    
    func retweetWithCompletion(id: Int!, completion: (res: AnyObject?, error: NSError?) ->Void) {
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(res: response, error: nil)
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(res: nil, error: error)
        }
    }
    
    func favoriteWithCompletion(id: Int!, completion: (res: AnyObject?, error: NSError?) ->Void) {
        POST("1.1/favorites/create.json", parameters: ["id": id], success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
            completion(res: response, error: nil)
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(res: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken:BDBOAuth1Credential!) -> Void in
            
            println("Got access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response:AnyObject!) -> Void in
                //                println("user: \(response)")
                
                var user = User(dictionary: response as! NSDictionary)
                User.currentUser = user
                println("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                println("error getting user")
                self.loginCompletion?(user: nil, error: error)
            })
            
        }) { (error:NSError!) -> Void in
            println("failed to get access token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
}
