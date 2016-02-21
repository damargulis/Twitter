//
//  TweetTableViewCell.swift
//  twitter
//
//  Created by Daniel Margulis on 2/21/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
