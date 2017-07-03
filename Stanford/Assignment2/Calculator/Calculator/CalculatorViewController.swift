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
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    private var variableOperations: Dictionary<String, Double> = [
        "a": 10,
        "b": 20
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        brain.addUnaryOperation(with: "✅", operation: {
            [weak self] in
            self?.display.textColor = UIColor.green
            return sqrt($0)
        })
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
        self.display.textColor = UIColor.black
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
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.setSymbol(mathematicalSymbol)
            performEvaluateAndDisplay(using: variableOperations)
            secondaryDisplay.text = brain.description
        }
    }
    
    func performEvaluateAndDisplay(using dictVariable: Dictionary<String, Double>) {
        let value = brain.evaluate(using: dictVariable)
        if let result = value.result {
            displayValue = result
        }
    }
}
