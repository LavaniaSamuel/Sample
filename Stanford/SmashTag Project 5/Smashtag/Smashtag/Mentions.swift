//
//  UserMentions.swift
//  Smashtag
//
//  Created by Samuel Navamani on 18/9/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mentions: NSManagedObject {
    
    class func findOrCreateMentions(matching mention: Twitter.Mention, for searchTerm: String, with type: String, in context: NSManagedObjectContext) throws -> Mentions {
        
        let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ and searchterm = %@", mention.keyword, searchTerm)
        
        do {
            let mentions = try context.fetch(request)
            if mentions.count > 0 {
                assert(mentions.count == 1, "Mentions findOrCreateMentions-- database inconsistency")
                return mentions[0]
            }
        } catch {
            throw error
        }
        
        let mentions = Mentions(context: context)
        mentions.count = 0
        mentions.keyword = mention.keyword
        mentions.searchterm = searchTerm
        mentions.type = type
        return mentions
    }
    
    class func checkMentions(for tweet: Tweet, with mention: Twitter.Mention, withKey keyword: String, andType type: String, andSearchTerm searchTerm: String, in context:NSManagedObjectContext) throws -> Mentions {
        do {
            let mentions = try findOrCreateMentions(matching: mention, for: searchTerm, with: type, in: context)
            if let tweetSet = mentions.tweets as? Set<Tweet>, !tweetSet.contains(tweet) {
                mentions.addToTweets(tweet)
                mentions.count = mentions.count + 1
            }
            return mentions
        } catch {
            throw error
        }
    }
}
