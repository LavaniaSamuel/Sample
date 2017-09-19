//
//  MentionsImageTableViewCell.swift
//  Smashtag
//
//  Created by Samuel Lavania on 6/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit
import Twitter

class MentionsImageTableViewCell: UITableViewCell {

    @IBOutlet weak var mentionImage: UIImageView!

    public var mediaItem: MediaItem? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let mentionItem = mediaItem {
            DispatchQueue.global(qos: .userInteractive).async {
                if let imageData = try? Data(contentsOf: mentionItem.url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.mentionImage.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
}
