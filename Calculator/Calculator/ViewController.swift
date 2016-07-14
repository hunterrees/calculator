//
//  ViewController.swift
//  Calculator
//
//  Created by Hunter Rees on 7/13/16.
//  Copyright © 2016 Hunter Rees. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var currentlyTyping = false
    
    @IBAction func touchDigit(sender: UIButton) {
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

    @IBAction func performOperation(sender: UIButton) {
        currentlyTyping = false
        if let mathSymbol = sender.currentTitle {
            if mathSymbol == "π" {
                display.text = String(M_PI)
            }
        }
    }
}

