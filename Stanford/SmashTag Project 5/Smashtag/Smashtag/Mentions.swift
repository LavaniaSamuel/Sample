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
        request.predicate = NSPredicate(format: "keyword = %@ AND searchterm = %@ AND type = %@", mention.keyword, searchTerm, type)
        
        do {
            let mentions = try context.fetch(request)
            if mentions.count > 0 {
                assert(mentions.count == 1, "TweetUser.findOrCreateMentions -- database inconsistency")
                return mentions[0]
            }
        } catch {
            print("Error in findOrCreateMentions: \(error.localizedDescription)")
            throw error
        }
        
        let mentions = Mentions(context: context)
        mentions.count = 0
        mentions.keyword = mention.keyword
        mentions.searchterm = searchTerm
        mentions.type = type
        return mentions
    }
    
    class func updateCount(for mentions: Mentions, withTwitter mention: Twitter.Mention,andSearchTerm searchTerm: String, in context:NSManagedObjectContext) throws -> Mentions {
        
        let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ AND searchterm = %@ AND type = %@", mention.keyword, searchTerm, mentions.type!)
        
        do {
            let mentions = try context.fetch(request)
            if mentions.count > 0 {
                assert(mentions.count == 1, "TweetUser.findOrCreateMentions -- database inconsistency")
                mentions[0].count = mentions[0].count + 1
                return mentions[0]
            }
        } catch {
            print("Error in updateCount: \(error.localizedDescription)")
            throw error
        }
        
        //This is an error which is a fallback
        let newMentions = Mentions(context: context)
        newMentions.count = 0
        newMentions.keyword = mention.keyword
        newMentions.searchterm = searchTerm
        newMentions.type = mentions.type
        return mentions

    }
    
    class func findMentions(matching mention: Twitter.Mention, for searchTerm: String, with type: String, in context: NSManagedObjectContext) throws -> [Mentions] {
        
        let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ AND searchterm = %@", mention.keyword, searchTerm)
        
        do {
            let mentions = try context.fetch(request)
            if mentions.count > 0 {
                //assert(mentions.count == 1, "Mentions findOrCreateMentions-- database inconsistency")
                return mentions
            }
        } catch {
            print("Error in findOrCreateMentions: \(error.localizedDescription)")
            throw error
        }
        return []
    }
}
