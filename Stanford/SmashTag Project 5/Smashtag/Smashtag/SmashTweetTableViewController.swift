//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Samuel Navamani on 4/9/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController
{
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertFetched(_ tweets: [Twitter.Tweet]){
        super.insertFetched(tweets)
        updateDatabase(with: tweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                if let searchTerm = self!.searchText {
                    _ = try? Tweet.findOrCreateTweet(matching: twitterInfo, for: searchTerm, in: context)
                }
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.fetch(request))?.count {
                    print("\(tweetCount) tweets")
                }
                let userRequest: NSFetchRequest<TweetUser> = TweetUser.fetchRequest()
                if let tweeterCount = try? context.count(for: userRequest) {
                    print("\(tweeterCount) Twitter users")
                }
                
                let mentionsRequest: NSFetchRequest<Mentions> = Mentions.fetchRequest()
                if let mentionsCount = try? context.fetch(mentionsRequest).count {
                    print("\(mentionsCount) mentions count")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term" {
            if let tweetersTVC = segue.destination as? SmashTweeterTableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
    }
}
