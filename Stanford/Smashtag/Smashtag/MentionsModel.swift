//
//  MentionsModel.swift
//  Smashtag
//
//  Created by Samuel Lavania on 5/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation
import Twitter

struct MentionsModel: CustomStringConvertible
{
    public var media: [MediaItem]? {
        didSet {
            if media!.count > 0 {
                mentionsName?.append("Media")
            }
        }
    }
    public var hashtags: [Mention]? {
        didSet {
            if hashtags!.count > 0 {
                mentionsName?.append("Hashtags")
            }
        }
    }
    public var urls: [Mention]? {
        didSet {
            if urls!.count > 0 {
                mentionsName?.append("Urls")
            }
        }
    }
    public var userMentions: [Mention]? {
        didSet {
            if userMentions!.count > 0 {
                mentionsName?.append("UserMentions")
            }
        }
    }
    
    public var description: String { return "hashtags: \(hashtags)\nurls: \(urls)\nuser_mentions: \(userMentions)" + "\nmedia count: \(media?.count)" + "\nmentionsName:\(mentionsName)" }
    
    public var mentionsName: [String]? = []
    
}
