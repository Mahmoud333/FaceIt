//
//  FaceView.swift
//  FaceIT_3
//
//  Created by Mahmoud Hamad on 9/26/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    @IBInspectable
    var scale: CGFloat = 0.90 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var mouthCurvature: Double = 1.0 { didSet{ setNeedsDisplay() } } // 1 full smile, -1 full frown
    
    @IBInspectable //bec. we r not drawing the eyes anymore we have subview that does it for us
    var eyesOpen: Bool = false { didSet{ leftEye.eyesOpen = eyesOpen; rightEye.eyesOpen = eyesOpen } }
    
    @IBInspectable
    var eyeBrowTilt: Double = -0.5 { didSet{ setNeedsDisplay() } } // -1 full furrow, 1 fully relaxed
    
    @IBInspectable
    var color: UIColor = UIColor.blueColor() { didSet{ setNeedsDisplay(); leftEye.color = color; rightEye.color = color } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet{ setNeedsDisplay(); leftEye.lineWidth = lineWidth; rightEye.lineWidth = lineWidth } }
    
    func changeScale(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state { //if state is changed or ended
        case .Changed,.Ended:
            scale *= recognizer.scale
            recognizer.scale = 1.0
        default:
            break
        }
    }
    
    //it had problem with initialization of bounds so we fixed it like this
    private var skullRadius: CGFloat { return min(bounds.size.width/2,bounds.size.height/2)*scale }
    private var skullCenter: CGPoint { return CGPoint(x: bounds.midX, y: bounds.midY) }
    
    private struct Ratios {
        static let SkullRadiusToEyeOffset: CGFloat = 3
        static let SkullRadiusToEyeRadius: CGFloat = 10
        static let SkullRadiusToMouthWidth: CGFloat = 1
        static let SkullRadiusToMouthHeight: CGFloat = 3
        static let SkullRadiusToMouthOffset: CGFloat = 3
        static let SkullRadiusToBrowOffset: CGFloat = 5

    }
    
    private enum Eye {
        case Left
        case Right
    }
    //Every circle thing (Skull, Eye)
    private func pathForCircleCenteredAtPoint(midPoint: CGPoint, withRadius radius: CGFloat) -> UIBezierPath {
        
        let path = UIBezierPath(arcCenter: midPoint, radius: radius, startAngle: 0.0, endAngle: CGFloat(2*M_PI), clockwise: false)
        path.lineWidth = lineWidth
        
        return path
    }
    // We Put The Same Code in EyeView
    // gonna use subviews to draw my eyes
//    private func pathForEye(eye: Eye) -> UIBezierPath {
//        
//        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
//        let eyeCenter = getEyeCenter(eye)
//        if eyesOpen {
//            return pathForCircleCenteredAtPoint(eyeCenter, withRadius: eyeRadius)
//        } else { //make line if its closed
//            let path = UIBezierPath()
//            path.moveToPoint(CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLineToPoint(CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//            path.lineWidth = lineWidth
//            return path
//        }
//    }
    // vars for left eye and right eye & creating them by calling method createEye on my self
    // if i removed lazy it will generate error bec, we r in initialization phase during initialization self isn't set so we cant send it any methods
    // why lazy solves it bec. the initialization won't happen unless some1 asks for this var, & no1 allowed to ask until its fully initialized
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.opaque = false // (opaque = not transparent)
        eye.color = color
        eye.lineWidth = lineWidth
        // after we added color & linewidth we will add it as a subview for ourselves
        // Problem: we haven't specified where this eye
        self.addSubview(eye)
        return eye
    }
    //this func to postion an eye
    private func positionEye(eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.SkullRadiusToEyeRadius * 2 // it knows the size the eye supposed to be
        eye.frame = CGRect(origin: CGPointZero, size: CGSize(width: size, height: size)) // creates rectangle thats initially in upper left iwth proper size
        eye.center = center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //is the method in view that's called whenever the system wants the view to lay its subviews out
        //& those 2 eyes are subviews of ours so we get to lay them out
        
        //layout subviwes is for the views and viewdidlayoutsubviews is for view controllers life cycle
        //layoutSubviews being asked to actually lay its subviews
        
        //it will get called when our bound changes
    
        positionEye(leftEye, center: getEyeCenter(.Left))
        positionEye(rightEye, center: getEyeCenter(.Right))
    
    }
    
    private func getEyeCenter(eye: Eye) -> CGPoint {
        
        let eyeOffset = skullRadius / Ratios.SkullRadiusToEyeOffset
        var eyeCenter = skullCenter
        eyeCenter.y -= eyeOffset
        switch eye {
        case .Left: eyeCenter.x -= eyeOffset
        case .Right: eyeCenter.x += eyeOffset
        }
        return eyeCenter
    }
    
    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth/2, y: skullCenter.y + mouthOffset, width: mouthWidth, height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1,min(mouthCurvature, 1))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX + mouthRect.width / 3, y: mouthRect.minY + smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX - mouthRect.width / 3, y: mouthRect.minY + smileOffset)
    
        let path = UIBezierPath()
        path.moveToPoint(start)
        path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        
        return path
    }
    
    
    private func pathForBrow(eye: Eye) -> UIBezierPath {
        var tilt = eyeBrowTilt
        switch eye {
        case .Left:
            tilt *= -1.0
        case .Right:
            break
        }
        var browCenter = getEyeCenter(eye)
        browCenter.y -= skullRadius / Ratios.SkullRadiusToBrowOffset
        let eyeRadius = skullRadius / Ratios.SkullRadiusToEyeRadius
        let tiltOffset = CGFloat(max(-1, min(tilt, 1))) * eyeRadius / 2
        let browStart = CGPoint(x: browCenter.x - eyeRadius, y: browCenter.y - tiltOffset)
        let browEnd = CGPoint(x: browCenter.x + eyeRadius, y: browCenter.y + tiltOffset)
        let path = UIBezierPath()
        path.moveToPoint(browStart)
        path.addLineToPoint(browEnd)
        path.lineWidth = lineWidth
        return path
    }
    
    override func drawRect(rect: CGRect) {
        
        let skull = pathForCircleCenteredAtPoint(skullCenter, withRadius: skullRadius)
        color.set()
        skull.stroke()
//        pathForEye(.Left).stroke()
//        pathForEye(.Right).stroke()
        pathForMouth().stroke()
        pathForBrow(.Left).stroke()
        pathForBrow(.Right).stroke()
    }
 

}
