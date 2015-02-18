//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Derek Gilwa on 2/11/15.
//  Copyright (c) 2015 gliwaderek.com. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .BinaryOperation(let operation,_):
                    return operation
                case .UnaryOperation(let operation,_):
                    return operation
                }
            
                
            }
        }
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        knownOps["×"] = Op.BinaryOperation("×", *)
        knownOps["+"] = Op.BinaryOperation("+", +)
        knownOps["÷"] = Op.BinaryOperation("÷") { $1 / $0 }
        knownOps["−"] = Op.BinaryOperation("−") { $1 - $0 }
        knownOps["√"] = Op.UnaryOperation("√", sqrt)
    }
    
    func pushOperand(operand : Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return(operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let operandEvaluation1 = evaluate(remainingOps)
                if let operand1 = operandEvaluation1.result {
                    let operationEvaluation2 = evaluate(operandEvaluation1.remainingOps)
                    if let operand2 = operationEvaluation2.result {
                        return(operation(operand1, operand2), operationEvaluation2.remainingOps)
                    }
                }
            }
        }
        return(nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        println("\(opStack): \(result) with remainder \(remainder)")
        return result
    }
    
}