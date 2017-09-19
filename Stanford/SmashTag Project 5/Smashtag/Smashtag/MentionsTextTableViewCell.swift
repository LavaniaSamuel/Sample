//
//  MentionsTextTableViewCell.swift
//  Smashtag
//
//  Created by Samuel Lavania on 6/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter

class MentionsTextTableViewCell: UITableViewCell {

    @IBOutlet weak var mentionsText: UILabel!
    
    public var mentions: Mention? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        mentionsText.text = mentions?.keyword
    }

}
