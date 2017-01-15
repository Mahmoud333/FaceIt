//
//  EmotionsViewController.swift
//  FaceIT_3
//
//  Created by Mahmoud Hamad on 9/28/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

class EmotionsViewController: UIViewController {

    private let emotionalFaces: Dictionary <String,FacialExpression> = [
        "angry" : FacialExpression(eyes: .Closed, eyeBrows: .Furrowed, mouth: .Frown),
        "happy" : FacialExpression(eyes: .Open, eyeBrows: .Normal, mouth: .Smile),
        "worried" : FacialExpression(eyes: .Open, eyeBrows: .Relaxed, mouth: .Smirk),
        "mischievious" : FacialExpression(eyes: .Open, eyeBrows: .Furrowed, mouth: .Grin)
    ]
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        var destinationvc = segue.destinationViewController
        if let navcon = destinationvc as? UINavigationController { //if im preparing to segue to something and its navigation controller then instead look inside the navigation controller and segue to that instead
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier { //can use switch but we will use dictionary
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression //setting the model in FaceViewContoller
                    if let sendingButton = sender as? UIButton {
                        facevc.navigationItem.title = sendingButton.currentTitle
                    }
                }
            }
        }
    }
    
}
