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
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double, (String)->String)
        case binaryOperation((Double, Double) -> Double, (String, String)->String)
        case equals
    }
    
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt, {"√(\($0))"}),
        "COS" : Operation.unaryOperation(cos, {"COS(\($0))"}),
        "SIN" : Operation.unaryOperation(sin, {"SIN(\($0))"}),
        "±" : Operation.unaryOperation(changeSign, {"±(\($0))"}),
        "*" : Operation.binaryOperation({$0 * $1 }, {"\($0)*\($1)"}),
        "+" : Operation.binaryOperation({$0 + $1 }, {"\($0)+\($1)"}),
        "-" : Operation.binaryOperation({$0 - $1 }, {"\($0)-\($1)"}),
        "/" : Operation.binaryOperation({$0 / $1 }, {"\($0)/\($1)"}),
        "=" : Operation.equals
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
        
        var descOperand1: String
        var descFunction: ((String,String)->String)
        
        func perform(with operand2 : Double, withString operand2String : String)-> (Double, String) {
            return (function(operand1, operand2), descFunction(descOperand1, operand2String))
        }
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String)
    {
        if let variableValue = variables {
            for (key, value) in variableValue {
                if key == variable {
                    setOperand(value)
                }
            }
        }
        
        if let symbol = self.symbol, let operation = operations[symbol] {
            switch  operation {
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
                if pbo != nil && accumulator != nil {
                    let tp = pbo!.perform(with: accumulator!, withString: descHelper)
                    accumulator = tp.0
                    descHelper = tp.1
                    resultIsPending = false
                    pbo = nil
                }
            }
        }
        
        return (result, resultIsPending, description)
    }
    
     func setOperand(_ operand: Double) {
        accumulator = operand
        descHelper = String(format: "%g", operand)
    }
    
    func addUnaryOperation(with symbol: String, operation: @escaping (Double) -> Double, descOperation: @escaping (String)->String) {
        operations[symbol] = Operation.unaryOperation(operation, descOperation)
    }
    
     func undo() {
        resultIsPending = false
        descHelper = ""
        accumulator = 0.0
    }
    
     func setOperand(_ named: String) {
        variable = named
    }
    
    func setSymbol(_ symbol: String) {
        self.symbol = symbol
    }

}



