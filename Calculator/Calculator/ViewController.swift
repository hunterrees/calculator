//
//  ViewController.swift
//  Calculator
//
//  Created by Hunter Rees on 7/13/16.
//  Copyright © 2016 Hunter Rees. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var display: UILabel!
    
    fileprivate var model = CalculatorBrain()
    
    fileprivate var currentlyTyping = false
    
    fileprivate var floatingPoint = false
    
    fileprivate var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction fileprivate func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if currentlyTyping {
            addToCurrentNumber(digit)
        }
        else if model.addSign {
            display.text = "-" + digit
            model.addSign = false
        }
        else {
            display.text = digit
        }
        currentlyTyping = true
     }

    @IBAction fileprivate func performOperation(_ sender: UIButton) {
        if currentlyTyping {
            model.setOperand(displayValue)
            currentlyTyping = false
            floatingPoint = false
        }
        if let mathSymbol = sender.currentTitle {
            model.performOperation(mathSymbol)
        }
        displayValue = model.result
    }
    
    fileprivate func addToCurrentNumber(_ digit: String) {
        if digit == "." {
            if !floatingPoint {
                floatingPoint = true
            }
            else {
                return
            }
        }
        let currentText = display.text!
        display.text = currentText + digit
    }
}

