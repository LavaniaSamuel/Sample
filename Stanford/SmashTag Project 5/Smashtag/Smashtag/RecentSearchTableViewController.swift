//
//  RecentSearchTableViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 11/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class RecentSearchTableViewController: UITableViewController {
    
    var recentSearch = RecentSearchModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Recent Searches"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (recentSearch.recentSearches?.count)!
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell", for: indexPath)

        cell.textLabel?.text = recentSearch.recentSearches![indexPath.row]

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier, segueIdentifier == "ToTweetViewSegue" {
            let tweetVC = segue.destination as? TweetTableViewController
            tweetVC?.searchTextFromMention = recentSearch.recentSearches![(tableView.indexPathForSelectedRow?.row)!]
        }
    }

}
