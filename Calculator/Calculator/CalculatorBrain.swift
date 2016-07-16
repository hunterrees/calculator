//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hunter Rees on 7/15/16.
//  Copyright © 2016 Hunter Rees. All rights reserved.
//

import Foundation

infix operator ** {
    associativity left precedence 170
}

func ** (num: Double, power: Double) -> Double{
    return pow(num, power)
}

class CalculatorBrain {
    
    fileprivate enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    fileprivate struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    fileprivate struct PendingUnaryOperationInfo {
        var unaryFunction: (Double) -> Double
    }
    
    fileprivate var operations = [
        "π" : Operation.constant(M_PI),
        "e" : Operation.constant(M_E),
        "C" : Operation.unaryOperation({(op1: Double) in return 0.0}),
        "√" : Operation.unaryOperation(sqrt),
        "sin" : Operation.unaryOperation(sin),
        "cos" : Operation.unaryOperation(cos),
        "tan" : Operation.unaryOperation(tan),
        "xª" : Operation.binaryOperation(**),
        "±" : Operation.unaryOperation({$0 * -1}),
        "x" : Operation.binaryOperation({$0 * $1}),
        "+" : Operation.binaryOperation({$0 + $1}),
        "-" : Operation.binaryOperation({$0 - $1}),
        "÷" : Operation.binaryOperation({$0 / $1}),
        "=" : Operation.equals
    ]
    
    var result: Double {
        get {
            return currentTotal
        }
    }
    
    var addSign: Bool {
        get {
            return pendingSignChange
        }
        set {
           pendingSignChange = newValue
        }
    }
    
    fileprivate var currentTotal = 0.0
    
    fileprivate var pendingOperation: PendingBinaryOperationInfo?
    
    fileprivate var pendingSignChange = false
    
    func setOperand(_ operand: Double) {
        currentTotal = operand
    }
    
    func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value) :
                currentTotal = value
            case .unaryOperation(let function) :
                switch symbol {
                case "C" :
                    pendingOperation = nil
                case "±" :
                    if pendingOperation != nil {
                        pendingSignChange = true
                    }
                default:
                    break
                }
                if !pendingSignChange {
                    currentTotal = function(currentTotal)
                }
            case .binaryOperation(let function) :
                executePendingBinaryOperation()
                pendingOperation = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: currentTotal)
            case .equals :
                executePendingBinaryOperation()
            }
        }
    }
    
    fileprivate func executePendingBinaryOperation() {
        if pendingOperation != nil {
            currentTotal = pendingOperation!.binaryFunction(pendingOperation!.firstOperand, currentTotal)
            pendingOperation = nil
        }
    }
}
