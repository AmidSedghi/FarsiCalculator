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
    var savedNum: Int = 0 // int value before mode button was pressed
    var lastButtonWasMode:Bool = false
    
    

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
    
    
    @IBAction func didPressEqual(_ sender: AnyObject) {
        // convert string to int
        guard let labelInt:Int = Int(labelString) else {
            return
        }
        // if no mode is selected, nothing to calculate thus return
        if (currntMode == .not_set || lastButtonWasMode){
            return
        }
        
        if (currntMode == .addition){ // performing addition
            savedNum += labelInt
        }
        
        else if (currntMode == .subtraction){
            savedNum -= labelInt
        }
        
        else if (currntMode == .multiplication){
            savedNum *= labelInt
        }
        
        else if (currntMode == .division){
            savedNum /= labelInt
        }
        
        currntMode = .not_set
        labelString = "\(savedNum)"
        updateText()
        lastButtonWasMode = true
        
    }
    
    /*  Clearing the results
     *  reset all variables
     */
    @IBAction func didPressClear(_ sender: Any) {
        labelString = "0"
        currntMode = .not_set
        savedNum = 0
        lastButtonWasMode = false
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
            labelString = "0"
        }
        
        labelString = labelString.appending(stringValue!)
        updateText()
    }
    
    
    
    func updateText(){
        // turn string to int
        guard let labelInt:Int = Int(labelString) else {
            return
        }
        
        if (currntMode == .not_set){
            savedNum = labelInt
        }
        
        // createa number formatter to have decimal style
        let formatter:NumberFormatter = NumberFormatter() // constructor method 
        formatter.numberStyle = .decimal
        let num:NSNumber = NSNumber(value: labelInt)
        
        // take care of leading zeros aka 00001 is 1
        result.text = formatter.string(from: num)
    }
    
    func changeMode(newMode:modes){
        
        if (savedNum == 0){ // if user presses calculation without giving it a value
            return
        }
        
        currntMode = newMode
        lastButtonWasMode = true
    }


}

