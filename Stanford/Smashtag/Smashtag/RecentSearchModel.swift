//
//  RecentSearchModel.swift
//  Smashtag
//
//  Created by Samuel Lavania on 11/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation

struct RecentSearchModel
{
    var recentSearch: String? {
        didSet {
            saveRecentSearch()
        }
    }
    
    var recentSearches: [String]? {
        get {
            return fetchRecentSearch()
        }
    }
    
    var userDefaults = UserDefaults.standard
    
    private func saveRecentSearch() {
        let fetchSearch = fetchRecentSearch()
        if var recents = fetchSearch {
            if recents.count == 100 {
                let removedSearch = recents.removeLast()
                print("Removed search more than 100 : \(removedSearch)")
            }
            if let recent = recentSearch {
                recents.insert(recent, at: 0)
                print("Inserted recent search")
                userDefaults.set(recents, forKey: "RecentSearch")
                print("Saved recent searches")
            }
        } else {
            if let recent = recentSearch {
                userDefaults.set([recent], forKey: "RecentSearch")
                print("Saved recent searches 1")
            }
        }
    }
    
    private func fetchRecentSearch() -> [String]? {
        let recents = userDefaults.array(forKey: "RecentSearch") as? [String]
        if let recentSearches = recents {
            print("Fetched recent searches :\(recentSearches)")
        }
        return recents
    }
}
