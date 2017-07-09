//
//  MentionsModel.swift
//  Smashtag
//
//  Created by Samuel Lavania on 5/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation
import Twitter

struct MentionsModel
{
    public var allMentions: [Mentions] = []
    enum Mentions: CustomStringConvertible
    {
        case Media([MediaItem])
        case HashTags([Mention])
        case Urls([Mention])
        case UserMentions([Mention])
        
        public var count: Int {
            switch self {
            case .Media(let mediaItem):
                return mediaItem.count
            case .HashTags(let mentionHashTags):
                return mentionHashTags.count
            case .Urls(let mentionUrls):
                return mentionUrls.count
            case .UserMentions(let mentionedUserMentions):
                return mentionedUserMentions.count
            }
        }
        
        public var description: String {
            switch self {
            case .Media( _):
                return "Media"
            case .HashTags( _):
                return "HashTags"
            case .Urls( _):
                return "Urls"
            case .UserMentions( _):
                return "UserMentions"
            }
        }
    }
}
