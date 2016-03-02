//
//  ComposeViewController.swift
//  twitter
//
//  Created by Daniel Margulis on 2/27/16.
//  Copyright © 2016 Daniel Margulis. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var characterCountLabel: UILabel!
    
    var sendTo: Tweet? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
        if let sendTo = sendTo {
            textView.text = "@\(sendTo.user?.screenname as! String)"
        } else{
            textView.text = "Enter Tweet"
        }
        let numChar = textView.text.characters.count
        
        characterCountLabel.text = "\(140-numChar)/140 Characters Remaining"
       
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    
    @IBAction func onTapSend(sender: AnyObject) {
        TwitterClient.sharedInstance.postStatus(textView.text)
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        let numCharacters = textView.text.characters.count
        
        let numLeft = 140-numCharacters
        characterCountLabel.text = "\(numLeft)/140 Characters Remaining"
        
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
