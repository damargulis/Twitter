//
//  User.swift
//  twitter
//
//  Created by Daniel Margulis on 2/16/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

var _currentUser: User?

class User: NSObject {
    
    var name: NSString?
    var screenname: NSString?
    var profileImageUrl: NSURL?
    var tagline: NSString?
    var dictionary: NSDictionary
    var followerCount: Int?
    var followingCount: Int?
    var tweetCount: Int?
    var headerImageUrl: NSURL?
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        print(dictionary)
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let imageUrl = dictionary["profile_image_url"] as? String
        if let imageUrl = imageUrl{
            profileImageUrl = NSURL(string: imageUrl)
        }
        let headerUrl = dictionary["profile_banner_url"] as? String
        if let headerUrl = headerUrl{
            headerImageUrl = NSURL(string: headerUrl)
        }
        
        
        tagline = dictionary["description"] as? String
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
        tweetCount = dictionary["statuses_count"] as? Int
    }
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get {
            if _currentUser == nil{
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
        
        
                if let userData = userData{
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
        
        
            }
            return _currentUser
        }
    
        set(user){
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user{
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            } else{
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
}
