//
//  Tweet.swift
//  Smashtag
//
//  Created by Samuel Navamani on 1/9/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject
{
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, for searchTerm: String, in context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.created = twitterInfo.created as NSDate
        tweet.text = twitterInfo.text
        tweet.tweeter = try? TweetUser.findOrCreateTweetUser(matching: twitterInfo.user, in: context)
        
        let twitterMentions = [
            "HashTags":twitterInfo.hashtags,
            "UserMentions":twitterInfo.userMentions
        ]
        
        for (type, mentions) in twitterMentions {
            for mention in mentions {
                if let newMentions = try? Mentions.findOrCreateMentions(matching: mention, for: searchTerm, with: type, in: context) {
                    _ = try? Mentions.updateCount(for: newMentions, withTwitter: mention, andSearchTerm: searchTerm, in: context)
                }
            }
        }
        
        return tweet
    }
}
