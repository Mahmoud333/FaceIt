//
//  EyeView.swift
//  FaceIT_3
//
//  Created by Mahmoud Hamad on 10/28/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

//UIView that will represent one of the eyes (separate uiView)
//make it oop the animation of the eye is eye thing which should be in eyeview not in faceview
class EyeView: UIView {

    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    var color: UIColor = UIColor.blueColor() { didSet{ setNeedsDisplay() } }
    
    //can't but it in didSet bec. its already to late it got set
    //use _ so it means this is the storage for another property thats computed
    var _eyesOpen: Bool = true { didSet{ setNeedsDisplay() } }
    
    var eyesOpen: Bool {
        get {
            return _eyesOpen
        }
        set {
            UIView.transitionWithView(
                self, //the eyeview is the one that gets flipedOver
                duration: 0.2,
                options: [UIViewAnimationOptions.TransitionFlipFromTop,.CurveLinear],
                animations: { self._eyesOpen = newValue },
                completion: nil //once it happens we don't want to do anything
            )
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        var path: UIBezierPath!
        
        if eyesOpen {
            path = UIBezierPath(ovalInRect: bounds.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        } else {
            path = UIBezierPath()
            path.moveToPoint(CGPoint(x: bounds.minX, y: bounds.midY))
            path.addLineToPoint(CGPoint(x: bounds.maxX, y: bounds.midY))
        }
   
        path.lineWidth = lineWidth
        color.setStroke()
        path.stroke()
    
    }
    
    
}
