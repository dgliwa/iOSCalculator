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
        let operation = sender.currentTitle!
        println(operandStack)
        if(userIsInMiddleOfTyping){
            enter()
        }
        switch operation {
        case "×": performOperation {$0 * $1}
        case "÷": performOperation {$1 / $0}
        case "+": performOperation {$0 + $1}
        case "−": performOperation {$1 - $0}
        case "√": performOperation { sqrt($0) }
            default: break
        }
    }
    
    
    func performOperation(operation: (Double, Double) -> Double){
        if(operandStack.count >= 2){
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    
    func performOperation(operation: (Double) -> Double){
        if(operandStack.count >= 1){
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if(userIsInMiddleOfTyping){
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInMiddleOfTyping = true
        }
    }
    @IBAction func enter() {
        operandStack.append(displayValue)
        userIsInMiddleOfTyping = false
    }

}

