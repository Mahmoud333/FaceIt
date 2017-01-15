//
//  BlinkingFaceViewController.swift
//  FaceIT_3
//
//  Created by Mahmoud Hamad on 10/23/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {

    var blinking: Bool = false {
        didSet {
            startBlinking() // Everytime it gets set call startBlinking
        }
    }
    
    private struct BlinkRate {
        static let ClosedDuration = 0.4
        static let OpenDuration = 2.5
    }
    
    func startBlinking() {
        if blinking {
            faceView.eyesOpen = false
            // after a moment, open them again
            NSTimer.scheduledTimerWithTimeInterval(
                BlinkRate.ClosedDuration, // the rate that we will keep it closed then open again
                target: self, selector: #selector(BlinkingFaceViewController.endBlink(_:)),
                userInfo: nil, repeats: false //one that goes back and forth rather than one that goes repeatedly
            )
        }
    }
    
    func endBlink(timer: NSTimer) { // can remove NSTimer if u want
        faceView.eyesOpen = true
        NSTimer.scheduledTimerWithTimeInterval(
            BlinkRate.OpenDuration,
            target: self, selector: #selector(BlinkingFaceViewController.startBlinking),
            userInfo: nil, repeats: false
        )
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        blinking = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        blinking = false
    }
}
