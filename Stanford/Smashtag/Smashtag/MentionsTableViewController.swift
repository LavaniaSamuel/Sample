//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 5/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    public var mentionModel: MentionsModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(mentionModel!)
        

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (mentionModel?.mentionsName?.count)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (mentionModel?.mentionsName?[section])!
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mentions = mentionModel?.mentionsName?[section]
        
        switch mentions! {
        case "Media" :
            return (mentionModel?.media?.count)!
        case "Hashtags" :
            return (mentionModel?.hashtags?.count)!
        case "Urls" :
            return (mentionModel?.urls?.count)!
        case "UserMentions" :
            return (mentionModel?.userMentions?.count)!
        default :
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mentions = mentionModel?.mentionsName?[indexPath.section]
        
        switch mentions! {
        case "Media" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
            if let imageCell = cell as? MentionsImageTableViewCell {
                imageCell.mediaItem = mentionModel?.media![indexPath.row]
            }
            return cell
        case "Hashtags" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "HashtagsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentionModel?.hashtags![indexPath.row]
            }
            return cell
        case "Urls" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UrlsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentionModel?.urls![indexPath.row]
            }
            return cell
        case "UserMentions" :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMentionsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentionModel?.userMentions![indexPath.row]
            }
            return cell
        default:
            return UITableViewCell()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
