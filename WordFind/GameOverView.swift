//
//  GameOverView.swift
//  WordFind
//
//  Created by Derek Critchfield on 7/15/15.
//  Copyright (c) 2015 Derek Critchfield. All rights reserved.
//

import Foundation
import UIKit
import iAd


class GameOverView: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet var adBannerView2: ADBannerView?

    @IBOutlet var newHighScoreLabel1: UILabel!
    @IBOutlet var newHighScoreLabel2: UILabel!
    @IBOutlet var score: UILabel!
    
    @IBOutlet var highScore: UILabel!
    
      @IBAction func newGame(sender: AnyObject) {
        if isMuted == false{
            let sound = Sounds()
            sound.buttonPressedSound()
        }
        
        performSegueWithIdentifier("NewGame", sender: self)
        
    }
       
    @IBAction func mainMenu(sender: AnyObject) {
        if isMuted == false{
            let sound = Sounds()
            sound.buttonPressedSound()
        }
         performSegueWithIdentifier("MainMenu", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if wordCount == highscore{
            newHighScoreLabel1.hidden = false
            newHighScoreLabel2.hidden = false
           StartScreen().saveHighscore(highscore)
        }
        score.text = "\(wordCount)"
        highScore.text = "\(highscore)"
        // Do any additional setup after loading the view, typically from a nib.
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        
        let sdk = VungleSDK.sharedSDK()
        do {
            try sdk.playAd(self)
        } catch _ {
        }
        
        self.canDisplayBannerAds = true
        self.adBannerView2?.delegate = self
        self.adBannerView2?.hidden = true
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
        self.adBannerView2?.hidden = false
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
       
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return true
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        
        self.adBannerView2?.hidden = true
    }

}