//
//  TweetTableViewController.swift
//  TweetsNearby
//
//  Created by Douglas on 12/17/15.
//  Copyright © 2015 Dougli. All rights reserved.
//

import UIKit
import TwitterKit
import SwiftyJSON
import Alamofire

class TweetTableViewViewController: UITableViewController, TWTRTweetViewDelegate {
    let tweetTableReuseIdentifier = "TweetCell"
    // Hold all the loaded Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let tweetIDs = ["20", // @jack's first Tweet
        "510908133917487104"] // our favorite bike Tweet
    // MARK: ViewDidLoad()
    override func viewDidLoad() {
        // Setup the table view
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension // Explicitly set on iOS 8 if using automatic row height calculation
        tableView.allowsSelection = false
        tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableReuseIdentifier)
        
        // Load Tweets
        let client = TWTRAPIClient()
        client.loadTweetsWithIDs(tweetIDs) { tweets, error in
            if let ts = tweets as? [TWTRTweet] {
                self.tweets = ts
            } else {
                print("Failed to load tweets: \(error!.localizedDescription)")
            }
        }
    }
    
    // MARK: UITableViewDelegate Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweet = tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableReuseIdentifier, forIndexPath: indexPath) as! TWTRTweetTableViewCell
        cell.configureWithTweet(tweet)
        cell.tweetView.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = tweets[indexPath.row]
        return TWTRTweetTableViewCell.heightForTweet(tweet, width: CGRectGetWidth(self.view.bounds))
    }
}