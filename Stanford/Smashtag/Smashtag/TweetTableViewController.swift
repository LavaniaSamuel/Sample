//
//  TweetTableViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 27/6/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    private var tweets = [Array<Tweet>]() {
        didSet {
            //print(tweets)
        }
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            self.title = searchText
        }
    }
    
    var searchTextFromMention: String?
    
    private func twitterRequest() -> Twitter.Request? {
        if let query = searchText, !query.isEmpty {
            return Twitter.Request(search: query, count: 100)
        }
        return nil
    }
    
    private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView.insertSections([0], with: .fade)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        if let searchText = searchTextFromMention {
            self.searchText = searchText
        }
        //searchText = "#stanford"
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
        
        let tweet = tweets[indexPath.section][indexPath.row]
        //   cell.textLabel?.text = tweet.text
        //   cell.detailTextLabel?.text = tweet.user.name
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
        }
        
        return cell
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    
    // MARK: - Text field delegate method
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if searchTextField == textField {
            searchText = searchTextField.text
        }
        return true
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier, segueIdentifier == "MentionsSegue" {
            if let mentionVC = segue.destination as? MentionsTableViewController {
                let tweet = tweets[(tableView.indexPathForSelectedRow?.section)!][(tableView.indexPathForSelectedRow?.row)!]
                var mentionsModel = MentionsModel()
                if tweet.media.count > 0 {
                    mentionsModel.allMentions.append(.Media(tweet.media))
                }
                if tweet.hashtags.count > 0 {
                    mentionsModel.allMentions.append(.HashTags(tweet.hashtags))
                }
                if tweet.urls.count > 0 {
                    mentionsModel.allMentions.append(.Urls(tweet.urls))
                }
                if tweet.userMentions.count > 0 {
                    mentionsModel.allMentions.append(.UserMentions(tweet.userMentions))
                }
                
                mentionVC.mentionsModel = mentionsModel
            }
        }
    }
}
