//
//  ViewController.swift
//  Farsi Calculator
//
//  Created by Amid Sedghi on 2017-06-08.
//  Copyright © 2017 Amid Sedghi. All rights reserved.
//

import UIKit

enum modes {
    case not_set
    case addition
    case subtraction
    case multiplication
    case division
}

class ViewController: UIViewController {
    
    @IBOutlet var result: UILabel!
    
    var labelString: String = "0"
    var currntMode:modes = .not_set
    var savedNum: Double = 0 // int value before mode button was pressed
    var lastButtonWasMode:Bool = false
    var decimalInserted:Bool = false
    //var valueNegative:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*  Calculator operator behaviors defined in function below
     *  Will need to add division to the calculator later
     */
    @IBAction func didPressPlus(_ sender: Any) {
        changeMode(newMode: .addition)
    }
    @IBAction func didPressSubtract(_ sender: Any) {
        changeMode(newMode: .subtraction)
    }
    @IBAction func didPressMultiply(_ sender: UIButton) {
        changeMode(newMode: .multiplication)
    }
    @IBAction func didPressDivide(_ sender: Any) {
        changeMode(newMode: .division)
    }
    
    /*  Performs the operation based on the mode
     *  Keep track of negative values
     */
    @IBAction func didPressEqual(_ sender: AnyObject) {
        // convert string to int
        guard let labelInt:Double = Double(labelString) else {
            return
        }
        // if no mode is selected, nothing to calculate thus return
        if (currntMode == .not_set || lastButtonWasMode){
            return
        }
        
        if (currntMode == .addition){
            savedNum += labelInt
        }
        
        else if (currntMode == .subtraction){
            savedNum -= labelInt
        }
        
        else if (currntMode == .multiplication){
            savedNum *= labelInt
        }
        
        else if (currntMode == .division){
            savedNum = savedNum/labelInt
        }
        
        currntMode = .not_set
        labelString = "\(savedNum)"
        updateText()
        lastButtonWasMode = true
        //valueNegative = false
    }
    
    /*  Clearing the results
     *  reset all variables
     */
    @IBAction func didPressClear(_ sender: Any) {
        labelString = "0"
        currntMode = .not_set
        savedNum = 0
        lastButtonWasMode = false
        decimalInserted = false
        //valueNegative = false
        result.text = "0"
    }
    
    /*  Pressing numerical values
     *  careful with pressing zeros - would need to be adjusted to accomodate larger
     *  numbers
     */
    @IBAction func didPressButton(_ sender: UIButton) {
        let stringValue:String? = (sender as AnyObject).titleLabel??.text
        
        if (lastButtonWasMode){
            lastButtonWasMode = false
            if (labelString == "-0"){
                // do nothing
            } else {
                labelString = "0"
            }
        }
        
        labelString = labelString.appending(stringValue!)
        updateText()
    }
    
    /*  Entering a decimal value:
     *  ensure +/- button works with . button
     */
    @IBAction func didPressDecimal(_ sender: Any) {
        if (decimalInserted){
            return
        }
        if (lastButtonWasMode){
            lastButtonWasMode = false
            if (labelString == "-0"){
                //
            } else {
                labelString = "0"
            }
        }
        labelString = labelString + "."
        decimalInserted = true
        updateText()
    }
    
    /*  Providing sign of the numerical value
     *  - or + would indicate a different result on operation
     */
    @IBAction func didPressSign(_ sender: UIButton) {
        
        // if last button was not a mode indicator
        if (!lastButtonWasMode){
            
            print("Hello")
            // user indicates value will be negative initially
            if (labelString == "0"){
                labelString = "-0"
                //valueNegative = true
            } else if (labelString == "-0"){
                labelString = "0"
                //valueNegative = false
            }
            
            // user indicates value will include decimals
            if (labelString == "0."){
                labelString = "-0."
                //valueNegative = true
            } else if (labelString == "-0."){
                labelString = "0."
                //valueNegative = false
            }

            // if value is greater than 0, add - sign
            if (Double(labelString)! > 0.0){
                labelString = "-" + labelString
            }
            // if value is less than zero, get rid of - sign
            else if (Double(labelString)! < 0.0){
                var pos:Double = Double(labelString)!
                pos = -1*pos
                labelString = String(pos)
            }
            
            updateText()
        }
        // if last button is a mode indicator
        else {
            labelString = "-0"
            //valueNegative = true
            updateText()
        }
        
    }
    
    /*  Percent sign, divides by 100
     *
     */
    @IBAction func didPressPercent(_ sender: Any) {
        
        var percent:Double = Double(labelString)!
        percent = percent/100.0
        labelString = String(percent)
        
        updateText()
    }
    
    /*  Update value on display
     *  append a '.' if decimal is clicked
     */
    func updateText(){
        // turn string to int
        guard let labelInt:Double = Double(labelString) else {
            return
        }
        print("Updating Text")
        print("labelString",labelString)
        print("labelInt", labelInt)
        
        if (currntMode == .not_set){
            savedNum = Double(labelInt)
        }
        
        // createa number formatter to have decimal style
        let formatter:NumberFormatter = NumberFormatter() // constructor method
        
        formatter.maximumFractionDigits = 5
        
        if (labelInt != 0.0 && (labelInt > 100000.0)){
            formatter.numberStyle = .scientific
        }
        else {
            formatter.numberStyle = .decimal
        }
        
        let num:NSDecimalNumber = NSDecimalNumber(value: labelInt)
        print("num", num)
        // take care of leading zeros aka 00001 is 1
        result.text = formatter.string(from: num)
 
        if (labelString.characters.last == "."){
            print(".")
            result.text? = (result.text?.appending("."))!
            result.text? = (result.text?.appending("0"))!
        } else if (labelString == ""){
            result.text? = (result.text?.appending("0"))!
        }
    }
    
    func changeMode(newMode:modes){
        
        if (savedNum == 0){ // if user presses calculation without giving it a value
            return
        }
        
        currntMode = newMode
        lastButtonWasMode = true
        decimalInserted = false
    }
}

