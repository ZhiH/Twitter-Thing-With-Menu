//
//  Tweet.swift
//  Twitter
//
//  Created by Zhi Huang on 9/13/15.
//  Copyright (c) 2015 Zhi Huang. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var formattedCreatedAtString: String?
    var favorited: Int?
    var retweeted: Int?
    var id: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        favorited = dictionary["favorited"] as? Int
        retweeted = dictionary["retweeted"] as? Int
        id = dictionary["id"] as? Int
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        formatter.dateFormat = "M/d/yy"
        formattedCreatedAtString = formatter.stringFromDate(createdAt!)
    }
 
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
