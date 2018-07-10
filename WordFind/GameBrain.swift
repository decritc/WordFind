//
//  GameBrain.swift
//  WordFind
//
//  Created by Derek Critchfield on 7/9/15.
//  Copyright (c) 2015 Derek Critchfield. All rights reserved.
//

import Foundation
import UIKit

//defines dice

let die0 = [1,1,3,9,15,20]
let die1 = [1,8,13,15,18,19]
let die2 = [5,7,11,12,21,25]
let die3 = [1,2,9,12,20,25]
let die4 = [1,3,4,5,13,16]
let die5 = [5,7,9,14,20,22]
let die6 = [7,9,12,18,21,23]
let die7 = [5,12,16,19,20,21]
let die8 = [4,5,14,15,19,23]
let die9 = [1,3,5,12,18,19]
let die10 = [1,2,10,13,15,17]
let die11 = [5,5,6,8,9,25]
let die12 = [5,8,9,14,16,19]
let die13 = [4,11,14,15,20,21]
let die14 = [1,4,5,14,22,26]
let die15 = [2,9,6,15,18,24]



class GameBrain{
    
    //defines the alphabet into an array for looking up the corresponding number
    let alphabetArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    //builds an array of the dice
    let dieArray = [die0, die1, die2, die3, die4, die5, die6, die7, die8, die9, die10, die11, die12, die13, die14, die15]
    
    //randomly pulls a number from each die and creates a new array
    func randomGridArrayMake() -> [Int] {
        var arrayOfIndex:[Int] = []
        var arrayOfValue:[Int] = []
        var i = 0
        while i < 16 {
            let randomNumber = Int(arc4random_uniform(6))
            arrayOfIndex.append(randomNumber)
            i++
        }
        for (index,value) in arrayOfIndex.enumerate(){
            let number = dieArray[index][value]
            arrayOfValue.append(number)
        }
        
        return arrayOfValue
    }


    //randomizes the location of the dice in the gridArray
    func randomizeGridArray() -> [Int] {
        var randomArrayOfValue = randomGridArrayMake()
        var newRandomArray: [Int] = []
        let i = 0
        while i < randomArrayOfValue.count {
            let randomNumber = Int(arc4random_uniform(UInt32(randomArrayOfValue.count)))
            
            newRandomArray.append(randomArrayOfValue[randomNumber])
            randomArrayOfValue.removeAtIndex(randomNumber)
            
        }
        
        return newRandomArray
    }
    
    // creates an array from the dictionary file
    func createDictionary() -> [String] {
        
        let path =  NSBundle.mainBundle().pathForResource("dictionary", ofType: "txt")!
        let dico = try? String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        
        let dictionaryArray = dico!.componentsSeparatedByString("\n")
        
        return dictionaryArray
        
    }
    
    func checkDictionaryForWord(dict: [String], word: String) -> Bool {
       
        let lowWord = word.lowercaseString
        if dict.indexOf(lowWord) != nil {
            return true
        }else{
        
            return false
        }
    }
    
    // converts number into letter in the alphabetArray
    func convertToLetter(number number: Int) -> String? {
        if alphabetArray.count > number - 1 && number > 0 {
            return alphabetArray[number - 1]
        }
        return nil
    }
    
    // converts letter into number in the alphabetArray
    func convertToNumber(letter letter: String) -> Int? {
        
        for (index,value) in alphabetArray.enumerate(){
            if letter == value{
                
                return index + 1
            }
            
        }
        return nil
        
        
    }
    
    func changeALetter (letter letter: UILabel) -> String{
        
        var randomNumber = Int(arc4random_uniform(16))
        var die = dieArray[randomNumber]
        let numberOfCurrentLetter = convertToNumber(letter: letter.text!)
        while die.indexOf(numberOfCurrentLetter!) == nil{
            if randomNumber < 16 {
                die = dieArray[randomNumber]
                randomNumber++
            }else {
                randomNumber = 0
                die = dieArray[0]
            }
        }
        randomNumber = Int(arc4random_uniform(6))
        var rolledSide = die[randomNumber]
        var randomLetter = convertToLetter(number: rolledSide)
        
        while randomLetter == letter.text{
            if randomNumber < 6 {
                rolledSide = die[randomNumber]
                randomLetter = convertToLetter(number: rolledSide)
                randomNumber++
            }else {
                randomNumber = 0
                rolledSide = die[randomNumber]
                randomLetter = convertToLetter(number: rolledSide)
            }
        }
        return randomLetter!
        
    }
}
