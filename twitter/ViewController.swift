//
//  ViewController.swift
//  twitter
//
//  Created by Daniel Margulis on 2/15/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        let client = TwitterClient.sharedInstance
        
        client.login({ () -> () in
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            }) { (error: NSError) -> () in
                print("Error: \(error.localizedDescription)")
        }
    }

}

