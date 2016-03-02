//
//  TweetDetailViewController.swift
//  twitter
//
//  Created by Daniel Margulis on 2/27/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetsLabel: UILabel!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textLabel.text = tweet.text
        usernameLabel.text = tweet.user?.name as? String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        let date = dateFormatter.stringFromDate(tweet.timeStamp!)
        timestampLabel.text = date
        
        profileImageView.setImageWithURL((tweet.user?.profileImageUrl)!)
        favoritesLabel.text = "Favorites: \(tweet.favoritesCount)"
        retweetsLabel.text = "Retweets: \(tweet.retweetCount)"
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapFav(sender: AnyObject) {
        if(tweet.favorited){
            tweet.favorited = false
            tweet.favoritesCount = tweet.favoritesCount - 1
            
            TwitterClient.sharedInstance.unfav(tweet)
        } else{
            tweet.favorited = true
            tweet.favoritesCount = tweet.favoritesCount + 1
            
            TwitterClient.sharedInstance.fav(tweet)
        }
        favoritesLabel.text = "Favorites: \(tweet.favoritesCount)"
    }
    
    @IBAction func onTapRT(sender: AnyObject) {
        if(tweet.retweeted){
            tweet.retweeted = false
            tweet.retweetCount = tweet.retweetCount - 1
            
            TwitterClient.sharedInstance.unRetweet(tweet)
        } else{
            tweet.retweeted = true
            tweet.retweetCount = tweet.retweetCount + 1
            
            TwitterClient.sharedInstance.retweet(tweet)
        }
        retweetsLabel.text = "Retweets: \(tweet.retweetCount)"
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let replyViewController = segue.destinationViewController as! ComposeViewController
        replyViewController.sendTo = tweet
    }


}
