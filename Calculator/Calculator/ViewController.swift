//
//  ViewController.swift
//  Calculator
//
//  Created by Hunter Rees on 7/13/16.
//  Copyright © 2016 Hunter Rees. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var model = CalculatorBrain()
    
    private var currentlyTyping = false
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if currentlyTyping {
            let currentText = display.text!
            display.text = currentText + digit
        }
        else {
            display.text = digit
        }
        currentlyTyping = true
     }

    @IBAction private func performOperation(sender: UIButton) {
        if currentlyTyping {
            model.setOperand(displayValue)
            currentlyTyping = false
        }
        if let mathSymbol = sender.currentTitle {
            model.performOperation(mathSymbol)
        }
        displayValue = model.result
    }
}

