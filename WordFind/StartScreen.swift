//
//  StartScreen.swift
//  WordFind
//
//  Created by Derek Critchfield on 7/14/15.
//  Copyright (c) 2015 Derek Critchfield. All rights reserved.
//

import UIKit
import Foundation
import GameKit

var sound = Sounds()


class StartScreen: UIViewController, GKGameCenterControllerDelegate {
    
    
    
    @IBOutlet var soundPic: UIImageView!
   
    @IBOutlet var soundSwitch: UISwitch!
    
    @IBAction func leaderBoard(sender: AnyObject) {
        if isMuted == false{
            
            sound.buttonPressedSound()
        }

        showLeader()
    }
    @IBAction func soundSwitchMoved(sender: AnyObject) {
        if soundSwitch.on {
            soundPic.image = UIImage(named:"sound")
            isMuted = false
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMuted")
            
        }else {
            soundPic.image = UIImage(named: "mute")
            isMuted = true
             NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMuted")
        }
        
    }
   
    @IBAction func startGame(sender: AnyObject) {
       
        if isMuted == false{
            
            sound.buttonPressedSound()
        }
        performSegueWithIdentifier("GameView", sender: self)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
       isMuted = NSUserDefaults.standardUserDefaults().boolForKey("isMuted")
        
        if isMuted == true{
            soundSwitch.on = false
            soundPic.image = UIImage(named: "mute")
        }
        authenticateLocalPlayer()
        UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
    }
    
    
    //initiate gamecenter
    func authenticateLocalPlayer(){
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController!, animated: true, completion: nil)
            }
                
            else {
                print((GKLocalPlayer.localPlayer().authenticated))
            }
        }
        
    }
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
    {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func showLeader() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        self.presentViewController(gc, animated: true, completion: nil)
    }
    
    //send high score to leaderboard
    func saveHighscore(highscore:Int) {
        
        //check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            let scoreReporter = GKScore(leaderboardIdentifier: "wordfind") //leaderboard id here
            
            scoreReporter.value = Int64(highscore) //score variable here (same as above)
            
            let scoreArray: [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError?) -> Void in
                if error != nil {
                    print("error")
                }
            })
            
        }
        
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

}