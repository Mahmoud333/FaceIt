//
//  ViewController.swift
//  FaceIT_3
//
//  Created by Mahmoud Hamad on 9/26/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

class FaceViewController: UIViewController {
    
    // MARK: Model
    //Pointer to our model
    var expression = FacialExpression(eyes: .Closed, eyeBrows: .Relaxed, mouth: .Smirk) { didSet { updateUI() } } //since its value type "FacialExpression" if any of the vars in the value type change this didset is gonna get called if it was a class it wouldn't
    
    // MARK: View
    @IBOutlet weak var faceView: FaceView! { didSet {
        faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:)))) //since it only changes the scale and don't change model we are gonna connect it to View
        
        let happierSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.increaseHappiness)) //the controller will be the one handling this bec. it modifys the model
        happierSwipeGestureRecognizer.direction = .Up
        faceView.addGestureRecognizer(happierSwipeGestureRecognizer)
        let sadderSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(FaceViewController.decreaseHappiness))
        sadderSwipeGestureRecognizer.direction = .Down
        faceView.addGestureRecognizer(sadderSwipeGestureRecognizer)
        
        updateUI() } } //when it start wiring up the outlet it will be called (only views recognize the gestures)
    //we have recognizers that as tthey're being handled they are being handled by the controller and the controller are modifing the model & everytime the models gets modified it will calls updateUI(the struct) and updateUI is the thing that's going to update, in this case, the mouth curvature
    
    func increaseHappiness() {//& every time we will change it it will updateUI bec. the expression struct
        expression.mouth = expression.mouth.happierMouth()
    }
    func decreaseHappiness() {
        expression.mouth = expression.mouth.sadderMouth()
    }
    @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) { //tapped
        if recognizer.state == .Ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            case .Squinting: break
            }
        }
    }
    private struct Animation {
        static let ShakeAngle = CGFloat(M_PI/6)
        static let ShakeDuration = 0.5 // for everyshake
    }
    @IBAction func headShake(sender: UITapGestureRecognizer)
    {
        UIView.animateWithDuration( //1
            Animation.ShakeDuration,
            animations: {
                self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
            },
            completion: { finished in
                // what do do? when it finish going to the right make it go backward to left
                if finished {
                    
                    UIView.animateWithDuration( //2
                        Animation.ShakeDuration,
                        animations: {
                            self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, -Animation.ShakeAngle*2)
                        },
                        completion: { finished in
                            if finished {
                                
                                UIView.animateWithDuration( //3
                                    Animation.ShakeDuration,
                                    animations: {
                                        self.faceView.transform = CGAffineTransformRotate(self.faceView.transform, Animation.ShakeAngle)
                                    },
                                    completion: { finished in
                                        if finished {
                                            
                                        }
                                    }
                                )
                                
                            }
                        }
                    )
                    
                }
            }
        )
    
    }
    @IBAction func changeBrows(recognizer: UIRotationGestureRecognizer) {
        switch recognizer.state {
        case .Changed,.Ended:
            if recognizer.rotation > CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreRelaxedBrow()
                recognizer.rotation = 0.0
            } else if recognizer.rotation < -CGFloat(M_PI/4) {
                expression.eyeBrows = expression.eyeBrows.moreFurrowedBrow()
                recognizer.rotation = 0.0
            }
        default:
            break
        } 
    }
    
    
    private var mouthCurvatures = [FacialExpression.Mouth.Frown:-1.0,.Grin:0.5,.Smile:1.0,.Smirk:-0.5,.Neutral:0.0]
    private var eyeBrowTilt = [FacialExpression.EyeBrows.Relaxed:0.5,.Furrowed:-0.5,.Normal:0.0]

    
    private func updateUI() {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            case .Squinting: faceView.eyesOpen = false
            }
            
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0 //Defaulting to 0 bec. dic is optinal and we need it be double
            faceView.eyeBrowTilt = eyeBrowTilt[expression.eyeBrows] ?? 0.0 //Default it to 0 if we can't find it'
        }
    }
    
    


}

