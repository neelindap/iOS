//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Neel on 3/2/17.
//  Copyright © 2017 Neel Indap. All rights reserved.
//

import Foundation

class CalculatorBrain{
    
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    private var operations: Dictionary<String, Operation> = [
        "+" : Operation.Binary({$0 + $1}),
        "-" : Operation.Binary({$0 - $1}),
        "÷" : Operation.Binary({$0 / $1}),
        "x" : Operation.Binary({$0 * $1}),
        "π" : Operation.Constant(M_PI),
        "√" : Operation.Unary(sqrt),
        "e" : Operation.Constant(M_E),
        "cos" : Operation.Unary(cos),
        "=" : Operation.Equals
    ]
    
    private enum Operation{
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double,Double) -> Double)
        case Equals
    }
    
    private var pending : PendingOperations?
    
    private struct PendingOperations{
        var firstOperand : Double
        var binaryOperation : (Double, Double) -> Double
    }
    
    func setOperand(operand: Double){
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    func performOperation(symbol: String){
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value) :
                accumulator = value
            case .Unary(let functionName):
                accumulator = functionName(accumulator)
            case .Binary(let functionName) :
                performPendingOperation()
                pending = PendingOperations(firstOperand: accumulator, binaryOperation: functionName)
            case .Equals :
                performPendingOperation()
            }
        }
    }
    
    typealias PropertyList = AnyObject
    var program : PropertyList{
        get{
            return internalProgram as CalculatorBrain.PropertyList
        }
        set{
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps{
                    if let operand = op as? Double{
                        setOperand(operand: operand)
                    }
                    if let operation = op as? String{
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    private func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    private func performPendingOperation(){
        if pending != nil{
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    var result: Double{
        get{
            return accumulator
        }
    }
    
}
 
