//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Samuel Navamani on 8/5/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

import UIKit

class CalculatorViewController : UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var secondaryDisplay: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.addUnaryOperation(with: "✅") { [weak weakSelf = self] in //(value: Double) -> Double in
            weakSelf?.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if digit.characters.count > 0 && userIsInTheMiddleOfTyping && digit.contains(".") && display.text?.range(of: ".") != nil  {
                return
        }
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        display.text = "0"
        userIsInTheMiddleOfTyping = false
        brain.undo()
        secondaryDisplay.text = brain.description
    }
    
    @IBAction func touchVariable(_ sender: UIButton) {
        if let title = sender.currentTitle {
            brain.setOperand(title)
        }
    }
    
    var displayValue : Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
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
        secondaryDisplay.text = brain.description
    }
}
