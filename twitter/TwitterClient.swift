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
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
//    class var sharedInstance: TwitterClient {
//        
////        struct Static{
////            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
////        }
////        
////        return Static.instance
////    }
    
    static let sharedInstance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError)->())?
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })


        }) {(error: NSError!) -> Void in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()){
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("home timeline: \(response)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            
            success(tweets)
            

            }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }

    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            //print("user: \(response)")
            
            let user = User(dictionary: response as! NSDictionary)
            
            success(user)
            
            print("user: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileImageUrl)")
            print("description: \(user.description)")
            
            
            self.loginCompletion?(user: user, error: nil)
        }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })

    }
    
    
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        loginCompletion = completion
        
        
        //fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            print("Got the request token")
            
            let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            
            
            }) {(error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                
                self.loginCompletion?(user: nil, error: error)
        }
        
        
    }
    
    func login(success: () -> (), failure: (NSError)->()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            UIApplication.sharedApplication().openURL(url)
            
            }) { (error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure?(error)
        }
    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
        
    }
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken:  BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            print("Got the access token")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user: \(response)")
                
                let user = User(dictionary: response as! NSDictionary)
                print("user: \(user.name)")
                
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("home timeline: \(response)")
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                for tweet in tweets{
                    print("text: \(tweet.text), created at: \(tweet.timeStamp)")
                }
                
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError) -> Void in
                    print("error getting home timeline")
            })
            
            
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to recieve access token")
                self.loginCompletion?(user: nil, error: error)
                
        }
        
        

    }
    
    func retweet(tweet: Tweet){
        
        POST("https://api.twitter.com/1.1/statuses/retweet/\(tweet.idstr!).json", parameters: nil, progress: { (NSProgress) -> Void in
                print("hi")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Retweeted")
//                tweet.retweeted = true
//                tweet.retweetCount = tweet.retweetCount+1
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to retweet")
                print(error)
        }
        
    }
    
    func unRetweet(tweet: Tweet){
        POST("https://api.twitter.com/1.1/statuses/unretweet/\(tweet.idstr!).json", parameters: nil, progress: { (NSProgress) -> Void in
                print("Im going!!!")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Unretweeted")
//                tweet.retweeted = false
//                tweet.retweetCount = tweet.retweetCount - 1
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to unretweet")
                print(error)
        }
    }
    
    func fav(tweet: Tweet){
        print("id:")
        print(tweet.id)
        print(tweet.idstr)
        POST("https://api.twitter.com/1.1/favorites/create.json?id=\(tweet.idstr!)", parameters: nil, progress: {
            (NSProgress) -> Void in
            print("hih")
        }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("Favorited")
//                tweet.favorited = true
//                tweet.favoritesCount = tweet.favoritesCount + 1
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("Failed to favorite")
                print(error)
        }
    }
    
    func unfav(tweet: Tweet){
        POST("https://api.twitter.com/1.1/favorites/destroy.json?id=\(tweet.idstr!)", parameters: nil, progress: {
            (NSProgress) -> Void in
            print("progress!")
        }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
            print("Unfavorited")
//            tweet.favorited = false
//            tweet.favoritesCount = tweet.favoritesCount - 1
        }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
            print("Failed to unfavorite")
            print(error)
        }
    }
    
    func postStatus(text: String){
        POST("https://api.twitter.com/1.1/statuses/update.json?status=\(text)", parameters: nil, progress: { (NSProgress) -> Void in
            print("getting there")
            }, success: { (data: NSURLSessionDataTask, object: AnyObject?) -> Void in
                print("success")
            }) { (data: NSURLSessionDataTask?, error: NSError) -> Void in
                print("failed to post tweet")
        }
    }
}
