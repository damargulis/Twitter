//
//  TweetsViewController.swift
//  twitter
//
//  Created by Daniel Margulis on 2/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var tweets: [Tweet]!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tweetTableView.dataSource = self
        tweetTableView.delegate = self
        
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tweetTableView.reloadData()
            }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
        })
        
    
        self.tweetTableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets{
            return tweets.count
        } else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        cell.usernameLabel.text = tweet.user?.name as? String
        cell.tweetTextLabel.text = tweet.text!
        let dateFormatter = NSDateFormatter()
        print(dateFormatter.stringFromDate(tweet.timeStamp!))
        cell.timeStampLabel.text = dateFormatter.stringFromDate(tweet.timeStamp!)
        
        cell.profileImageView.setImageWithURL((tweet.user?.profileImageUrl)!)
        
        cell.favoriteButton.setTitle("Fav's: \(tweet.favoritesCount)", forState: .Normal)
        cell.retweetButton.setTitle("RT's: \(tweet.retweetCount)", forState: .Normal)
        
        cell.favoriteButton.tag = indexPath.row
        cell.retweetButton.tag = indexPath.row
    
        cell.favoriteButton.addTarget(self, action: "onTouchFav:", forControlEvents: .TouchUpInside)
        cell.retweetButton.addTarget(self, action: "onTouchRT:", forControlEvents: .TouchUpInside)
        
        if(tweet.favorited){
            cell.favoriteButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else{
            cell.favoriteButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        if(tweet.retweeted){
            cell.retweetButton.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        } else{
            cell.retweetButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        
        return cell
        
    }
    
    @IBAction func onTouchFav(sender: UIButton){
        let tweet = tweets[sender.tag]
        if(tweet.favorited){
            tweet.favoritesCount = tweet.favoritesCount - 1
            tweet.favorited = false
        } else{
            TwitterClient.sharedInstance.fav(tweet)
        }
        
        tweetTableView.reloadData()
        
    }
    
    @IBAction func onTouchRT(sender: UIButton){
        let tweet = tweets[sender.tag]
        if(tweet.retweeted){
            tweet.retweetCount = tweet.retweetCount - 1
            tweet.retweeted = false
            
            
        } else{
            TwitterClient.sharedInstance.retweet(tweet)
        }
        
        tweetTableView.reloadData()
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
