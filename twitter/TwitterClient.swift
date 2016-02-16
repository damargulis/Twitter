//
//  TwitterClient.swift
//  twitter
//
//  Created by Daniel Margulis on 2/15/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager


let twitterConsumerKey = "WuGIQrPRd43pHjVppGHLofCyF"
let twitterConsumerSecret = "meZmrOp678UomQp6RbXsBbFd2Z5Phse1lfXfmkI8jxRhRjIZiw"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    class var sharedInstance: TwitterClient {
        
        struct Static{
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }

}
