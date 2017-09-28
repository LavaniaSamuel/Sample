//
//  ViewController.swift
//  Calculator
//
//  Created by Dulio Denis on 2/17/17.
//  Copyright © 2017 ddApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // implicitly unwrapped optional
    @IBOutlet weak var display: UILabel!
    
    // inferred type
    var userIsInTheMiddleOfTyping = false
    
    public func showSizeClasses() {
        if !userIsInTheMiddleOfTyping {
            display.textAlignment = .center
            display.text = "Width:" + traitCollection.horizontalSizeClass.description + "- Height:" + traitCollection.verticalSizeClass.description
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showSizeClasses()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (coordinator) in
            self.showSizeClasses()
        }, completion: nil)
    }

    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    // computed property
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    // private model property
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        // perform the operation
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        // update the display if I can
        if let result = brain.result {
            displayValue = result
        }
    }
    
}

extension UIUserInterfaceSizeClass: CustomStringConvertible {
    public var description: String {
        switch self {
        case .compact:
            return "Compact"
        case .regular:
            return "Regular"
        case .unspecified:
            return "Unspecified"
        }
    }
}

