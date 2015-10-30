//
//  ViewController.swift
//  Tap Me
//
//  Created by Joshua Harris on 10/28/15.
//  Copyright © 2015 Joshua Harris. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    var buttonBeep: AVAudioPlayer?
    var secondBeep: AVAudioPlayer?
    var backgroundMusic: AVAudioPlayer?
    var count = 0
    var seconds = 0
    var timer = NSTimer()
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        //1
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        
        //2
        var audioPlayer:AVAudioPlayer?
        
        // 3
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: url)
        } catch {
            print("Player not available")
        }
        
        return audioPlayer
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = UIColor(patternImage: UIImage(named: "TapMe_Resources/bg_tile.png")!)
        scoreLabel.backgroundColor = UIColor(patternImage: UIImage(named: "TapMe_Resources/field_score.png")!)
        timerLabel.backgroundColor = UIColor(patternImage: UIImage(named: "TapMe_Resources/field_time.png")!)
        
        if let buttonBeep = self.setupAudioPlayerWithFile("ButtonTap", type:"wav") {
            self.buttonBeep = buttonBeep
        }
        if let secondBeep = self.setupAudioPlayerWithFile("SecondBeep", type:"wav") {
            self.secondBeep = secondBeep
        }
        if let backgroundMusic = self.setupAudioPlayerWithFile("HallOfTheMountainKing", type:"mp3") {
            self.backgroundMusic = backgroundMusic
        }
        
        setupGame()
    }

    @IBAction func buttonPressed(sender: AnyObject) {
        count++
        scoreLabel.text = "Score: \(count)"
        buttonBeep?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setupGame()  {
        seconds = 30
        count = 0
        
        timerLabel.text = "Time: \(seconds)"
        scoreLabel.text = "Score: \(count)"
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        
        backgroundMusic?.volume = 0.3
        backgroundMusic?.play()
    }
    
    func subtractTime() {
        seconds--
        timerLabel.text = "Time: \(seconds)"
        
        if(seconds == 0){
            timer.invalidate()
            let alert = UIAlertController(title: "Time is up!", message: "You scored \(count) points", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default, handler: {
                action in self.setupGame()
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
        
        secondBeep?.play()
    }

}

