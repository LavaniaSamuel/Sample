//
//  TweetUser.swift
//  Smashtag
//
//  Created by Samuel Navamani on 1/9/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class TweetUser: NSManagedObject
{
    class func findOrCreateTweetUser(matching twitterInfo: Twitter.User, in context: NSManagedObjectContext) throws -> TweetUser
    {
        let request: NSFetchRequest<TweetUser> = TweetUser.fetchRequest()
        request.predicate = NSPredicate(format: "handle = %@", twitterInfo.screenName)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "TweetUser.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let twitterUser = TweetUser(context: context)
        twitterUser.handle = twitterInfo.screenName
        twitterUser.name = twitterInfo.name
        return twitterUser
    }

}
