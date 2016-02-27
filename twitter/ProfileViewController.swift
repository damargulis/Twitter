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
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = user.name as? String
        
        

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
