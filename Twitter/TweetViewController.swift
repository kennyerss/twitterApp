//
//  TweetViewController.swift
//  Twitter
//
//  Created by Kent Brylle Canonigo on 10/7/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make the textview for tweet first responder so keyboard shows up 
        tweetText.becomeFirstResponder()
    }
    
    // cancel function to dismiss tweet
    @IBAction func cancel(_ sender: Any) {
        // Dismiss the view controller
        dismiss(animated: true, completion: nil)
    }
    
    // tweet function to tweet
    @IBAction func tweet(_ sender: Any) {
        // Check if tweetText has any text or empty
        if (!tweetText.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetText.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in // If there is an error, alert user that there is an error
                print("Error posting tweet \(error)")
                self.dismiss(animated: true, completion: nil)
            })
            // If text is not empty
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
