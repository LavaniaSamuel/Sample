//
//  CalculatorBrain.swift
//  LavCalculator
//
//  Created by Samuel Lavania on 6/5/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    var accumulator: Double?
    
    public var description: String {
        get {
            if resultIsPending {
                return ("\(descHelper)...")
            } else {
                return ("\(descHelper)=")
            }
        }
    }
    
    private var resultIsPending: Bool = false
    
    private var descHelper: String = ""
    
    enum Operations {
        case constant(Double)
        case unaryOperation((Double)->Double, (String)->String)
        case binaryOperation((Double,Double)->Double, (String, String)->String)
        case equals
    }
    var operation : Dictionary <String, Operations> = [
        "π" : Operations.constant(Double.pi),
        "√" : Operations.unaryOperation(sqrt, {"√(\($0))"}),
        "+" : Operations.binaryOperation({$0+$1}, {"\($0)+\($1)"}),
        "-" : Operations.binaryOperation({$0-$1}, {"\($0)-\($1)"}),
        "×" : Operations.binaryOperation({$0 * $1}, {"\($0)*\($1)"}),
        "=" : Operations.equals
    ]
    
    mutating func setOperand (_ operand: Double) {
        accumulator = operand
        descHelper = String(format: "%g", operand)
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
    
    mutating func performOperation (_ symbol : String) {
        if let xyz = operation[symbol]{
            switch xyz {
            case .constant(let value):
                    accumulator = value
                    descHelper = "\(accumulator!)"
            case .unaryOperation(let function, let descFunction):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    descHelper = descFunction("\(descHelper)")
                }
            case .binaryOperation(let function, let descFunction):
                if accumulator != nil {
                    resultIsPending = true
                    pbo = PendingBinaryOperation(operand1: accumulator!, function: function, descOperand1: descHelper, descFunction: descFunction)
                    descHelper += ("\(symbol)")
                    accumulator = nil
                }
            case .equals:
                if accumulator != nil && pbo != nil {
                    let tp = pbo!.perform(with: accumulator!, withString: descHelper)
                    accumulator = tp.0
                    descHelper = tp.1
                    resultIsPending = false
                    pbo = nil
                }
                
            }
        }
    }
    
    var pbo: PendingBinaryOperation?
    
    struct PendingBinaryOperation
    {
        var operand1: Double
        var function: ((Double,Double)->Double)
        
        var descOperand1: String
        var descFunction: ((String,String)->String)
        
        func perform(with operand2 : Double, withString operand2String : String)-> (Double, String) {
            return (function(operand1, operand2), descFunction(descOperand1, operand2String))
        }
    }
    
}

