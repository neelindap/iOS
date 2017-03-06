//
//  ViewController.swift
//  Calculator
//
//  Created by Neel on 3/2/17.
//  Copyright © 2017 Neel Indap. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    private var userIsTyping = false;
    
    var savedProgram : CalculatorBrain.PropertyList?
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        
        if userIsTyping{
            let currentDisplay = display.text!
            display.text = currentDisplay + digit
        }
        else{
            display.text = digit
        }
        userIsTyping = true
    }
    
    @IBAction func saveBtn(_ sender: UIButton) {
        savedProgram = brain.program
    }
    
    
    @IBAction func restoreBtn(_ sender: UIButton) {
        if savedProgram != nil{
            brain.program = savedProgram as CalculatorBrain.PropertyList
            displayValue = brain.result
        }
    }
    
    private var displayValue : Double {
        get{
            return Double(display.text!)!
        }
        set{
            display!.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOpertaion(_ sender: UIButton) {
        if userIsTyping{
            brain.setOperand(operand: displayValue)
            userIsTyping = false
        }
        if let symbol = sender.currentTitle{
            brain.performOperation(symbol: symbol)
        }
        displayValue = brain.result
    }
}

