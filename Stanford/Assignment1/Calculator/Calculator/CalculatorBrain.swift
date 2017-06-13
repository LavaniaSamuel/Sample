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

struct CalculatorBrain {
    
    private var accumulator : Double?
    private var variable: String?
    
    private var resultIsPending: Bool = false
    
    var description: String {
        get {
            if resultIsPending {
                return ("\(descHelper!)...")
            } else {
                return descHelper!
            }
        }
    }
    
    private var descHelper: String? = "0"
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    
    private var operations: Dictionary<String, Operation> =
    [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "COS" : Operation.unaryOperation(cos),
        "SIN" : Operation.unaryOperation(sin),
        "±" : Operation.unaryOperation(changeSign),
        "X" : Operation.binaryOperation({$0 * $1 }),
        "+" : Operation.binaryOperation({$0 + $1 }),
        "-" : Operation.binaryOperation({$0 - $1 }),
        "/" : Operation.binaryOperation({$0 / $1 }),
        "=" : Operation.equals
    ]
    
    var result : Double? {
        get {
            return accumulator
        }
    }
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func performOperation(_ secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch  operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let binaryFunction):
                if accumulator != nil {
                    pbo = PendingBinaryOperation(function: binaryFunction, firstOperand: accumulator!)
                    accumulator = nil
                    resultIsPending = true
                }
            case .equals:
                if pbo != nil && accumulator != nil {
                    accumulator = pbo!.performOperation(accumulator!)
                    pbo = nil
                    resultIsPending = false
                }
            }
        }
        
        if descHelper != nil {
            descHelper?.append(symbol)
        } else {
            descHelper = "\(accumulator!)"
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        if descHelper != nil {
            descHelper?.append(String(describing: accumulator!))
        } else {
            descHelper = "\(accumulator!)"
        }
    }
    
    mutating func addUnaryOperation(with symbol: String, operation: @escaping (Double) -> Double) {
        operations[symbol] = Operation.unaryOperation(operation)
    }
    
    mutating func undo() {
        resultIsPending = false
        descHelper = "0"
        accumulator = 0.0
    }
    
    mutating func setOperand(_ named: String) {
        variable = named
    }
    
    private var variableOperations: Dictionary<String, Double>? = [
        "a": 10,
        "b": 20
    ]
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String)
    {
        if let value = variables {
            for (key, value) in value {
                if let variableValue = variable {
                    if key == variableValue {
                        
                    } else {
                        
                    }
                }
                
            }
        }
    }
}



