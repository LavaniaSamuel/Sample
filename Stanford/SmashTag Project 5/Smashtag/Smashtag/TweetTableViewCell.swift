//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Samuel Lavania on 29/6/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetTweeterLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    
    public var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        tweetTweeterLabel.text = tweet?.user.description
        tweetTextLabel.text = tweet?.text
        
        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInteractive).async {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async { [weak self] in
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let tweetCreated = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(tweetCreated) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.dateStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: tweetCreated)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
