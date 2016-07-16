//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Hunter Rees on 7/15/16.
//  Copyright © 2016 Hunter Rees. All rights reserved.
//

import Foundation

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
    
    var result: Double {
        get {
            return currentTotal
        }
    }
    
    private var currentTotal = 0.0
    
    private var pending: PendingBinaryOperationInfo?
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "C" : Operation.UnaryOperation({$0 * 0}),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
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
            case .Constant(let value):
                currentTotal = value
            case .UnaryOperation(let function):
                currentTotal = function(currentTotal)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: currentTotal)
            case .Equals:
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