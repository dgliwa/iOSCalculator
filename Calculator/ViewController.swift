//
//  ViewController.swift
//  Calculator
//
//  Created by Derek Gilwa on 2/3/15.
//  Copyright (c) 2015 gliwaderek.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userIsInMiddleOfTyping: Bool = false
    var operandStack = Array<Double>()
    var brain = CalculatorBrain()
    var displayValue: Double {
        get{
          return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text! = "\(newValue)"
            userIsInMiddleOfTyping = false
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if(userIsInMiddleOfTyping){
            enter()
        }
        let operation = sender.currentTitle!
        if let result = brain.performOperation(operation) {
            displayValue = result
        }
    }
    
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInMiddleOfTyping){
            if(inputResultsInValidDecimal(digit)){
                display.text = display.text! + digit
            }
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    }
    
    func inputResultsInValidDecimal(input: String) -> Bool {
           return input != "." || display.text!.rangeOfString(".") == nil
    }
    
    @IBAction func enter() {
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        }
        else {
            displayValue = 0
        }
        userIsInMiddleOfTyping = false
    }

}

