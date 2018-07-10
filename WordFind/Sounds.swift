//
//  Sounds.swift
//  WordFind
//
//  Created by Derek Critchfield on 7/16/15.
//  Copyright (c) 2015 Derek Critchfield. All rights reserved.
//

import Foundation
import AVFoundation
var audioPlayer: AVAudioPlayer?

class Sounds{

    func buttonPressedSound(){
        
        if let path = NSBundle.mainBundle().pathForResource("Popped", ofType: "wav") {
            
            audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "wav")
    
    
            if let sound = audioPlayer {
        
                sound.prepareToPlay()

                sound.play()
   
            }

        }

    }
    func bigWordSound(){
        
        if let path = NSBundle.mainBundle().pathForResource("big word selected 1", ofType: "mp3") {
            
            audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
            
            
            if let sound = audioPlayer {
                
                sound.prepareToPlay()
                
                sound.play()
                
            }
            
        }
        
    }
    func bigWord2Sound(){
        
        if let path = NSBundle.mainBundle().pathForResource("big word selected", ofType: "mp3") {
            
            audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
            
            
            if let sound = audioPlayer {
                
                sound.prepareToPlay()
                
                sound.play()
                
            }
            
        }
        
    }
    func fingerSlideSound(){
        
        if let path = NSBundle.mainBundle().pathForResource("finger slide", ofType: "mp3") {
            
            audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
            
            
            if let sound = audioPlayer {
                
                sound.prepareToPlay()
                
                sound.play()
                
            }
            
        }
        
    }
    func smallWordSound(){
        
        if let path = NSBundle.mainBundle().pathForResource("small word selected", ofType: "mp3") {
            
            audioPlayer = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
            
            
            if let sound = audioPlayer {
                
                sound.prepareToPlay()
                
                sound.play()
                
            }
            
        }
        
    }
}