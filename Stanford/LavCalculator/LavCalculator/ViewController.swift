//
//  ViewController.swift
//  LavCalculator
//
//  Created by Samuel Lavania on 6/5/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var userIsInTheMiddleOfTyping = false
    
    
    @IBOutlet weak var display: UILabel!
    
    
    @IBAction func touchDigit(_ sender: UIButton) {
        if let displayValue = sender.currentTitle {
            //print("\(displayValue)")
            if userIsInTheMiddleOfTyping {
                display.text = display.text! + displayValue
            }
            else {
                display.text = displayValue
                userIsInTheMiddleOfTyping = true
            }
        }
    }
    
    var brain = CalculatorBrain()
    
    var displayValue : Double {
        get{ return Double(display.text!)!}
        set{ display.text = String(newValue)}
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
        print("performOperation: \(brain.description)")
    }
    
    
    
}

