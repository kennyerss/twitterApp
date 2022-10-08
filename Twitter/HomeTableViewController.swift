//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kent Brylle Canonigo on 10/2/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    // Create container for tweets
    var tweetArray = [NSDictionary]()
    var numberOfTweets: Int!
    
    // Add refresher to load tweets
    let myRefreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        self.tableView.refreshControl = myRefreshControl
    }
    
    // Make tweet show up in home feed
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    // Pull our tweets
    @objc func loadTweets() {
        
        // When first loading tweets, instead of calling a number, use numberOfTweets
        numberOfTweets = 20
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParam = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParam, success: { (tweets: [NSDictionary]) in
            // Clean up data from Twitter
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
            print(Error.localizedDescription)
        })
        
    }
    
    
    func loadMoreTweets() {
        let tweetUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        // Increment the total number of tweets in home feed
        numberOfTweets = numberOfTweets + 20
        
        let myParam = ["count": numberOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: tweetUrl, parameters: myParam, success: { (tweets: [NSDictionary]) in
            // Clean up data from Twitter
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    // When user reaches end of the screen which loads more tweets
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
        
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as?  String
         
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count
    }

    

}
