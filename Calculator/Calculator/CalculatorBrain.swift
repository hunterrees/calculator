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
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private struct PendingUnaryOperationInfo {
        var unaryFunction: (Double) -> Double
    }
    
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
    
    private var currentTotal = 0.0
    
    private var pending: PendingBinaryOperationInfo?
    
    private var pendingSignChange = false
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "C" : Operation.UnaryOperation({$0 * 0.0}),
        "√" : Operation.UnaryOperation(sqrt),
        "sin" : Operation.UnaryOperation(sin),
        "cos" : Operation.UnaryOperation(cos),
        "tan" : Operation.UnaryOperation(tan),
        "xª" : Operation.BinaryOperation(**),
        "±" : Operation.UnaryOperation({$0 * -1}),
        "x" : Operation.BinaryOperation({$0 * $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "-" : Operation.BinaryOperation({$0 - $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals
    ]
    
    func setOperand(operand: Double) {
        currentTotal = operand
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value) :
                currentTotal = value
            case .UnaryOperation(let function) :
                switch symbol {
                case "C" :
                    pending = nil
                case "±" :
                    if pending != nil {
                        pendingSignChange = true
                    }
                default:
                    break
                }
                if !pendingSignChange {
                    currentTotal = function(currentTotal)
                }
            case .BinaryOperation(let function) :
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: currentTotal)
            case .Equals :
               executePendingBinaryOperation()
            }
        }
    }
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            currentTotal = pending!.binaryFunction(pending!.firstOperand, currentTotal)
            pending = nil
        }
    }
}