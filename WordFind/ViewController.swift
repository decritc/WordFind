//
//  ViewController.swift
//  WordFind
//
//  Created by Derek Critchfield on 7/9/15.
//  Copyright (c) 2015 Derek Critchfield. All rights reserved.
//

import UIKit
import Foundation
import iAd

var wordCount = 0
var highscore = 0
var isMuted = false

class ViewController: UIViewController, ADBannerViewDelegate {


    @IBOutlet var adBannerView: ADBannerView?

 
    @IBOutlet var timeLeft: UILabel!

    @IBOutlet var word: UILabel!
    
    @IBOutlet var pieces: [UILabel]!
   
    var playersWord = ""
    var wordsPlayed:[String] = []
    var dict:[String] = []
    var timerCount = 60
    var timer = NSTimer()
    var timerRunning:Bool = false
    
    var modu = 10
  
   
    
    @IBOutlet var leftBorder: UILabel!
    @IBOutlet var rightBorder: UILabel!
    @IBOutlet var bottomBorder: UILabel!
    
    @IBOutlet var playersHighScore: UILabel!
    
    
    
    @IBOutlet var scoreLabel: UILabel!
    
    var gameBrain = GameBrain()
   
    func resetBoard() {
        wordCount = 0
        scoreLabel.text = ("\(wordCount)")
        wordsPlayed = []
        timer.invalidate()
        timerCount = 60
        timerRunning = false
        modu = 10
        setupBoard()
        
    }
    
    func setupBoard() {
        dict = gameBrain.createDictionary()
        var grid = gameBrain.randomizeGridArray()
        highscore = NSUserDefaults.standardUserDefaults().integerForKey("highscore")
        playersHighScore.text = "\(highscore)"
        var i = 0
        while i < 16 {
            let piece = gameBrain.convertToLetter(number:  grid[i])
            
            pieces[i].text = piece
            
            i++
        }
       countingUp()
    }
    
    func pickAUnusedSpot() -> UILabel{
        var randomNumber = Int(arc4random_uniform(16))
        var piece = pieces[randomNumber]
        var available = 0
        
        for (_, label) in pieces.enumerate() {
            
            if label.textColor == UIColor.blackColor(){
                available++
            }
        }
        
        if available != 0 {
            while piece.textColor == UIColor.blueColor() {
                if randomNumber < 15 {
                    randomNumber++
                    piece = pieces[randomNumber]
                }else {
                    piece = pieces[0]
                }
            }
        }
        
        return piece
    }
    
    func endGame() {
        
        performSegueWithIdentifier("GameOver", sender: self)
        
    }
    
    func updateTime(){
        timerCount -= 1
        timeLeft.text = "\(timerCount)"
        if timerCount == 0 {
            endGame()
        }else if timerCount % modu == 0 {
            let unusedSpot = pickAUnusedSpot()
            unusedSpot.text = gameBrain.changeALetter(letter: unusedSpot)
        }
       
    }
    
    func countingUp(){
        if timerRunning == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(1,target: self, selector : "updateTime", userInfo:nil, repeats: true)
            timerRunning = true
            
    
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
       let location = testTouches(touches)
        respondToTouches(touchLocation: location)
    
        if isMuted == false{
            for piece in pieces{
                if piece.textColor == UIColor.blueColor() {
            
                    sound.fingerSlideSound()
                }
            }
        }

       
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = testTouches(touches)
            respondToTouches(touchLocation: location)
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        var location = testTouches(touches)
        for piece in pieces {
            piece.textColor = UIColor.blackColor()
        }
        if gameBrain.checkDictionaryForWord(dict, word: playersWord) == true && wordsPlayed.indexOf(playersWord) == nil {
            wordsPlayed.append(playersWord)
            let charactersInPlayersWord = playersWord.characters.count
            switch charactersInPlayersWord {
            
            case 2,3:
                
                if isMuted == false{
                 sound.smallWordSound()
                }
                
                wordCount += 10
                scoreLabel.text = ("\(wordCount)")
                timerCount += 5
            
            case 4:
                
                if isMuted == false{
                    sound.smallWordSound()
                }
                wordCount += 25
                scoreLabel.text = ("\(wordCount)")
                timerCount += 10
                
            case 5:
                
                if isMuted == false{
                    sound.bigWordSound()
                }
                
                wordCount += 40
                scoreLabel.text = ("\(wordCount)")
                timerCount += 15
                
            case 6:
                
                if isMuted == false{
                    sound.bigWordSound()
                }
                wordCount += 60
                scoreLabel.text = ("\(wordCount)")
                timerCount += 20
                
            case 7:
                if isMuted == false{
                    sound.bigWordSound()
                }
                wordCount += 100
                scoreLabel.text = ("\(wordCount)")
                timerCount += 25
                
            case 8:
                if isMuted == false{
                    sound.bigWord2Sound()
                }
                wordCount += 150
                scoreLabel.text = ("\(wordCount)")
                timerCount += 30
                
            default:
                if isMuted == false{
                    sound.bigWord2Sound()
                }
                wordCount += 250
                scoreLabel.text = ("\(wordCount)")
                timerCount += 45
            }
            if wordCount > highscore {
                highscore = wordCount
                NSUserDefaults.standardUserDefaults().setInteger(highscore, forKey: "highscore")
                playersHighScore.text = "\(highscore)"
            }
            
            if modu != 1{
                switch wordCount {
                case 0...100:
                        modu = 10
                case 100...200:
                        modu = 9
                case 200...300:
                        modu = 8
                case 300...400:
                        modu = 7
                case 400...500:
                        modu = 6
                case 500...600:
                        modu = 5
                case 600...700:
                        modu = 4
                case 700...800:
                        modu = 3
                case 800...900:
                        modu = 2
                case 900...1000:
                        modu = 1
                default:
                    modu = 1
                }
            }
        }
        playersWord = ""
        word.text = playersWord
       
    }
    
    func buildWord(letter letter: String!){
        playersWord += letter!
        word.textColor = UIColor.redColor()
        word.text = playersWord
    }
    
    func respondToTouches(touchLocation touchLocation: CGPoint){
        
        let prox:CGFloat = 33.0
        
        let piece0 = pieces[0].center
        let pieceRangeX0 = (piece0.x - prox)...(piece0.x + prox)
        let pieceRangeY0 = (piece0.y - prox)...(piece0.y + prox)
        
        let piece1 = pieces[1].center
        let pieceRangeX1 = (piece1.x - prox)...(piece1.x + prox)
        let pieceRangeY1 = (piece1.y - prox)...(piece1.y + prox)
        
        let piece2 = pieces[2].center
        let pieceRangeX2 = (piece2.x - prox)...(piece2.x + prox)
        let pieceRangeY2 = (piece2.y - prox)...(piece2.y + prox)
        
        let piece3 = pieces[3].center
        let pieceRangeX3 = (piece3.x - prox)...(piece3.x + prox)
        let pieceRangeY3 = (piece3.y - prox)...(piece3.y + prox)
        
        let piece4 = pieces[4].center
        let pieceRangeX4 = (piece4.x - prox)...(piece4.x + prox)
        let pieceRangeY4 = (piece4.y - prox)...(piece4.y + prox)
        
        let piece5 = pieces[5].center
        let pieceRangeX5 = (piece5.x - prox)...(piece5.x + prox)
        let pieceRangeY5 = (piece5.y - prox)...(piece5.y + prox)
        
        let piece6 = pieces[6].center
        let pieceRangeX6 = (piece6.x - prox)...(piece6.x + prox)
        let pieceRangeY6 = (piece6.y - prox)...(piece6.y + prox)
        
        let piece7 = pieces[7].center
        let pieceRangeX7 = (piece7.x - prox)...(piece7.x + prox)
        let pieceRangeY7 = (piece7.y - prox)...(piece7.y + prox)
        
        let piece8 = pieces[8].center
        let pieceRangeX8 = (piece8.x - prox)...(piece8.x + prox)
        let pieceRangeY8 = (piece8.y - prox)...(piece8.y + prox)
        
        let piece9 = pieces[9].center
        let pieceRangeX9 = (piece9.x - prox)...(piece9.x + prox)
        let pieceRangeY9 = (piece9.y - prox)...(piece9.y + prox)
        
        let piece10 = pieces[10].center
        let pieceRangeX10 = (piece10.x - prox)...(piece10.x + prox)
        let pieceRangeY10 = (piece10.y - prox)...(piece10.y + prox)
        
        let piece11 = pieces[11].center
        let pieceRangeX11 = (piece11.x - prox)...(piece11.x + prox)
        let pieceRangeY11 = (piece11.y - prox)...(piece11.y + prox)
        
        let piece12 = pieces[12].center
        let pieceRangeX12 = (piece12.x - prox)...(piece12.x + prox)
        let pieceRangeY12 = (piece12.y - prox)...(piece12.y + prox)
        
        let piece13 = pieces[13].center
        let pieceRangeX13 = (piece13.x - prox)...(piece13.x + prox)
        let pieceRangeY13 = (piece13.y - prox)...(piece13.y + prox)
        
        let piece14 = pieces[14].center
        let pieceRangeX14 = (piece14.x - prox)...(piece14.x + prox)
        let pieceRangeY14 = (piece14.y - prox)...(piece14.y + prox)
        
        let piece15 = pieces[15].center
        let pieceRangeX15 = (piece15.x - prox)...(piece15.x + prox)
        let pieceRangeY15 = (piece15.y - prox)...(piece15.y + prox)
    
        let lbCenter = leftBorder.center
        let lbRangeX = (lbCenter.x - 21)...(lbCenter.x + 21)
        let lbRangeY = (lbCenter.y - 144)...(lbCenter.y + 144)
        
        let rbCenter = rightBorder.center
        let rbRangeX = (rbCenter.x - 21)...(rbCenter.x + 21)
        let rbRangeY = (rbCenter.y - 144)...(rbCenter.y + 144)
        
        let bbCenter = bottomBorder.center
        let bbRangeX = (bbCenter.x - 199)...(bbCenter.x + 199)
        let bbRangeY = (bbCenter.y - 15)...(bbCenter.y + 15)
        
        let wordCenter = word.center
        let wordRangeX = (wordCenter.x - 199)...(wordCenter.x + 199)
        let wordRangeY = (wordCenter.y - 15)...(wordCenter.y + 15)
        
        
        switch (touchLocation.x, touchLocation.y) {
            
        case (wordRangeX, wordRangeY):
            for piece in pieces {
                piece.textColor = UIColor.blackColor()
            }
            playersWord = ""
            word.text = playersWord
            
        case (lbRangeX, lbRangeY):
            for piece in pieces {
                piece.textColor = UIColor.blackColor()
            }
            playersWord = ""
            word.text = playersWord
        
        case (rbRangeX, rbRangeY):
            for piece in pieces {
                piece.textColor = UIColor.blackColor()
            }
            playersWord = ""
            word.text = playersWord

        case (bbRangeX, bbRangeY):
            for piece in pieces {
                piece.textColor = UIColor.blackColor()
            }
            playersWord = ""
            word.text = playersWord

            
        case (pieceRangeX0, pieceRangeY0):
            if pieces[0].textColor != UIColor.blueColor(){
                pieces[0].textColor = UIColor.blueColor()
                buildWord(letter: pieces[0].text!)
            }
            break
            
        case (pieceRangeX1, pieceRangeY1):
            if pieces[1].textColor != UIColor.blueColor(){
                pieces[1].textColor = UIColor.blueColor()
                buildWord(letter: pieces[1].text!)
            }
            break
            
        case (pieceRangeX2, pieceRangeY2):
            if pieces[2].textColor != UIColor.blueColor(){
                pieces[2].textColor = UIColor.blueColor()
                buildWord(letter: pieces[2].text!)
            }
            break

        case (pieceRangeX3, pieceRangeY3):
            if pieces[3].textColor != UIColor.blueColor(){
                pieces[3].textColor = UIColor.blueColor()
                buildWord(letter: pieces[3].text!)
            }
            break
            
        case (pieceRangeX4, pieceRangeY4):
             if pieces[4].textColor != UIColor.blueColor(){
                pieces[4].textColor = UIColor.blueColor()
                buildWord(letter: pieces[4].text!)
            }
            break
            
        case (pieceRangeX5, pieceRangeY5):
            if pieces[5].textColor != UIColor.blueColor(){
                pieces[5].textColor = UIColor.blueColor()
                buildWord(letter: pieces[5].text!)
            }
            break
            
        case (pieceRangeX6, pieceRangeY6):
            if pieces[6].textColor != UIColor.blueColor(){
                pieces[6].textColor = UIColor.blueColor()
                buildWord(letter: pieces[6].text!)
            }
            break
            
        case (pieceRangeX7, pieceRangeY7):
            if pieces[7].textColor != UIColor.blueColor(){
                pieces[7].textColor = UIColor.blueColor()
                buildWord(letter: pieces[7].text!)
            }
            break
            
        case (pieceRangeX8, pieceRangeY8):
            if pieces[8].textColor != UIColor.blueColor(){
                pieces[8].textColor = UIColor.blueColor()
                buildWord(letter: pieces[8].text!)
            }
            break
            
        case (pieceRangeX9, pieceRangeY9):
            if pieces[9].textColor != UIColor.blueColor(){
                pieces[9].textColor = UIColor.blueColor()
                buildWord(letter: pieces[9].text!)
            }
            break
            
        case (pieceRangeX10, pieceRangeY10):
            if pieces[10].textColor != UIColor.blueColor(){
                pieces[10].textColor = UIColor.blueColor()
                buildWord(letter: pieces[10].text!)
            }
            break
            
        case (pieceRangeX11, pieceRangeY11):
            if pieces[11].textColor != UIColor.blueColor(){
                pieces[11].textColor = UIColor.blueColor()
                buildWord(letter: pieces[11].text!)
            }
            break
            
        case (pieceRangeX12, pieceRangeY12):
            if pieces[12].textColor != UIColor.blueColor(){
                pieces[12].textColor = UIColor.blueColor()
                buildWord(letter: pieces[12].text!)
            }
            break
            
        case (pieceRangeX13, pieceRangeY13):
            if pieces[13].textColor != UIColor.blueColor(){
                pieces[13].textColor = UIColor.blueColor()
                buildWord(letter: pieces[13].text!)
            }
            break
            
        case (pieceRangeX14, pieceRangeY14):
            if pieces[14].textColor != UIColor.blueColor(){
                pieces[14].textColor = UIColor.blueColor()
                buildWord(letter: pieces[14].text!)
            }
            break
            
        case (pieceRangeX15, pieceRangeY15):
            if pieces[15].textColor != UIColor.blueColor(){
                pieces[15].textColor = UIColor.blueColor()
                buildWord(letter: pieces[15].text!)
            }
            break
            
            
        default:
            break
        }

    }
    
    func testTouches(touches: NSSet!) -> CGPoint {
        // Get the first touch and its location in this view controller's view coordinate system
        let touch = touches.allObjects[0] as! UITouch
        let touchLocation = touch.locationInView(self.view)
        
        
        return touchLocation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        self.canDisplayBannerAds = true
        self.adBannerView?.delegate = self
        self.adBannerView?.hidden = true
        
        resetBoard()
        
        }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        // Lock autorotate
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        // Only allow Portrait
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        
        // Only allow Portrait
        return UIInterfaceOrientation.Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bannerViewWillLoadAd(banner: ADBannerView!) {
        
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.adBannerView?.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        self.adBannerView?.hidden = true
    }
}

