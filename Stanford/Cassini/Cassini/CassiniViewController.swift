//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Samuel Lavania on 4/6/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageVC = (segue.destination.content as? ImageViewController) {
                imageVC.imageURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
    }
}

extension UIViewController {
    
    var content: UIViewController {
        if let navCon = self as? UINavigationController {
            return navCon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
