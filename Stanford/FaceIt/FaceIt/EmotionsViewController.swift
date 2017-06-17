//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Samuel Lavania on 17/6/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {
    
    let emotionalFaces: Dictionary<String, FacialExpression> = [
        "Happy": FacialExpression(eyes: .open, mouth: .smile),
        "Sad": FacialExpression(eyes: .open, mouth: .frown),
        "Worried": FacialExpression(eyes: .close, mouth: .neutral)]
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier ,
            let expression = emotionalFaces[identifier] {
                faceViewController.expression = expression
            faceViewController.title = (sender as? UIButton)?.currentTitle
        }
    }
    
}
