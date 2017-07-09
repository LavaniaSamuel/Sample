//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Samuel Lavania on 10/7/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    public var imageURL: URL? {
        didSet {
            fetchImage()
        }
    }
    
    public var image: UIImage?
    
    private func fetchImage() {
        if let url = imageURL {
            DispatchQueue.global().async { [weak self] in
                let imageData = try? Data(contentsOf: url)
                if let imageContent = imageData {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageContent)
                    }
                }
            }
            
        }
    }

}
