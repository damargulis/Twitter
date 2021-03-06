//
//  Tweet.swift
//  twitter
//
//  Created by Daniel Margulis on 2/16/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var user: User?
    var text: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var timeStamp: NSDate?
    var favorited: Bool = false
    var retweeted: Bool = false

    var id: Int
    var idstr: String?
    
    init(dictionary: NSDictionary){
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        favorited = ((dictionary["favorited"]) as? Bool)!
        retweeted = ((dictionary["retweeted"]) as? Bool)!
        
        
        let createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(createdAtString)
        }
        
        id = (dictionary["id"] as? Int)!
        idstr = dictionary["id_str"] as? String
        
        
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dicionary in array{
            tweets.append(Tweet(dictionary: dicionary))
        }
        
        return tweets
    }

}
