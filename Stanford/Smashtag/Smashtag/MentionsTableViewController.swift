//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 5/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class MentionsTableViewController: UITableViewController {
    
    public var mentionsModel = MentionsModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(mentionsModel)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mentionsModel.allMentions.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentionsModel.allMentions[section].description
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mentions = mentionsModel.allMentions[indexPath.section]
        
        switch mentions {
        case .Media(let mediaItem):
            return tableView.bounds.size.width / CGFloat(mediaItem[indexPath.section].aspectRatio)
        default:
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentionsModel.allMentions[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mentions = mentionsModel.allMentions[indexPath.section]
        
        switch mentions {
        case .Media(let mediaItem) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "MediaCell", for: indexPath)
            if let imageCell = cell as? MentionsImageTableViewCell {
                imageCell.mediaItem = mediaItem[indexPath.row]
            }
            return cell
        case .HashTags(let mentions) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "HashtagsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentions[indexPath.row]
            }
            return cell
        case .Urls(let mentions) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UrlsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentions[indexPath.row]
            }
            return cell
        case .UserMentions(let mentions):
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserMentionsCell", for: indexPath)
            if let imageCell = cell as? MentionsTextTableViewCell {
                imageCell.mentions = mentions[indexPath.row]
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mentions = mentionsModel.allMentions[indexPath.section]
        
        switch mentions {
        case .Media(_):
            performSegue(withIdentifier: "ToImageViewSegue", sender: nil)
        case .Urls(let mentions) :
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:mentions[indexPath.row].keyword)!)
            } else {
                UIApplication.shared.openURL(URL(string:mentions[indexPath.row].keyword)!)
            }
        default:
            break
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case "ToMainHashTagSegue", "ToMainUserMentionsSegue":
                if let tweetTableVC = segue.destination as? TweetTableViewController {
                    let mentions = mentionsModel.allMentions[(tableView.indexPathForSelectedRow?.section)!]
                    switch mentions {
                    case .HashTags(let mentionItem), .UserMentions(let mentionItem):
                        tweetTableVC.searchTextFromMention = mentionItem[(tableView.indexPathForSelectedRow?.row)!].keyword
                    default:
                        break
                    }
                }
            case "ToImageViewSegue" :
                if let imageVC = segue.destination as? ImageViewController {
                    let mentions = mentionsModel.allMentions[(tableView.indexPathForSelectedRow?.section)!]
                    switch mentions {
                    case .Media(let mediaItem):
                        imageVC.imageURL = mediaItem[(tableView.indexPathForSelectedRow?.row)!].url
                    default:
                        break
                    }
                }
                
            default:
                break
            }
        }
    }

}
