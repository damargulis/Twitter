//
//  ProfileViewController.swift
//  twitter
//
//  Created by Daniel Margulis on 2/27/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = user.name as? String
        descriptionLabel.text = user.tagline as? String
        numTweetsLabel.text = "\(user.tweetCount!) Tweets"
        numFollowingLabel.text = "\(user.followingCount!) Following"
        numFollowersLabel.text = "\(user.followerCount!) Followers"

        profileImageView.setImageWithURL(user.profileImageUrl!)
        headerImageView.setImageWithURL(user.headerImageUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
