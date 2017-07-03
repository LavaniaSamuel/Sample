//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Samuel Navamani on 8/5/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

class CalculatorBrain {
    
    private var accumulator : Double?
    private var variable: String?
    private var symbol: String?
    
    private var resultIsPending: Bool = false
    
    var description: String {
        get {
            if resultIsPending {
                return ("\(descHelper)...")
            } else {
                if descHelper == "" {
                    return "0"
                } else {
                    return ("\(descHelper)=")
                }
            }
        }
    }
    
    private var descHelper: String = ""
    
    private enum Operation: CustomStringConvertible {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, String)
        case binaryOperation((Double, Double) -> Double, String)
        case equals(String)
        
        var description: String {
            switch self {
            case .constant(_, let stringValue):
                return stringValue
            case .unaryOperation(_, let stringValue):
                return stringValue
            case .binaryOperation(_, let stringValue):
                return stringValue
            case .equals(let stringValue):
                return stringValue
            }
        }
    }
    
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi, "π"),
        "e" : Operation.constant(M_E, "e"),
        "√" : Operation.unaryOperation(sqrt, "√"),
        "COS" : Operation.unaryOperation(cos, "COS"),
        "SIN" : Operation.unaryOperation(sin, "SIN"),
        "±" : Operation.unaryOperation(changeSign, "±"),
        "*" : Operation.binaryOperation({$0 * $1 }, "*"),
        "+" : Operation.binaryOperation({$0 + $1 }, "+"),
        "-" : Operation.binaryOperation({$0 - $1 }, "-"),
        "/" : Operation.binaryOperation({$0 / $1 }, "/"),
        "=" : Operation.equals("=")
    ]
    
    var result : Double? {
        get {
            return accumulator
        }
    }
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation
    {
        var operand1: Double
        var function: ((Double,Double)->Double)
        
        func perform(with operand2 : Double) -> Double {
            return (function(operand1, operand2))
        }
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String)
    {
        if let variableValue = variables {
            for (key, value) in variableValue {
                if let variableKey = variable, key == variableKey {
                    setOperand(value)
                    variable = nil
                }
            }
        }
        
        if let symbol = self.symbol, let operation = operations[symbol] {
            switch operation {
            case .constant(let value, _):
                accumulator = value
                descHelper += operation.description
            case .unaryOperation(let function, _):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                    descHelper = "\(operation.description)(\(descHelper))"
                }
            case .binaryOperation(let function, _):
                if accumulator != nil {
                    resultIsPending = true
                    pbo = PendingBinaryOperation(operand1: accumulator!, function: function)
                    descHelper += ("\(operation.description)")
                    accumulator = nil
                }
            case .equals:
                if pbo != nil && accumulator != nil {
                    accumulator = pbo!.perform(with: accumulator!)
                    resultIsPending = false
                    pbo = nil
                }
            }
        }
        
        return (result, resultIsPending, description)
    }
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        if descHelper == "" {
            descHelper = String(format: "%g", operand)
        } else {
            descHelper += String(format: "%g", operand)
        }
    }
    
    func addUnaryOperation(with symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation, symbol)
    }
    
    func undo() {
        resultIsPending = false
        descHelper = ""
        accumulator = 0.0
        variable = nil
    }
    
    func setOperand(_ named: String) {
        variable = named
    }
    
    func setSymbol(_ symbol: String) {
        self.symbol = symbol
    }
    
}



