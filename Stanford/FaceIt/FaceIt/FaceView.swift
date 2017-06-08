//
//  FaceView.swift
//  FaceIt
//
//  Created by Samuel Lavania on 13/5/17.
//  Copyright © 2017 Samuel Lavania. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale : CGFloat = 0.5 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var depthOfSmile : Double = 1.0 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var eyesOpen : Bool = true { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet{ setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet{ setNeedsDisplay() } }
    
    enum Eye {
        case left
        case right
    }
    
    var skullRadius: CGFloat {
        return bounds.width/2 * scale
    }
    
    
    var skullCentre: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func pathForSkull() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: skullCentre, radius: skullRadius, startAngle: 0, endAngle: CGFloat.pi * 2 , clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    func pathForMouth() -> UIBezierPath
    {
        let startY = skullCentre.y + skullRadius/3
        let startX = skullCentre.x - skullRadius/3
        let endX = skullCentre.x + skullRadius/3
        let endY = startY + skullRadius/3
        let rectWidth = endX - startX
        let rectHeight = endY - startY
        let rectMouth = CGRect(x: startX, y: startY, width: endX - startX, height: endY - startY)
        
        let smileStart = rectHeight/2
        let curveY = startY+smileStart
        let smileHeight = CGFloat(max(-1, min(depthOfSmile,1))) * rectMouth.height
        
        let curveStartPoint = CGPoint(x:startX, y: curveY)
        let curveEndPoint = CGPoint(x: endX, y: curveY)
        let cp1 = CGPoint(x: startX + rectWidth/3, y: curveY+smileHeight)
        let cp2 = CGPoint(x: endX - rectWidth/3, y: curveY+smileHeight)
        
        let path = UIBezierPath()
        path.move(to: curveStartPoint)
        path.addCurve(to: curveEndPoint, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    func pathForEyes(_ eye: Eye) -> UIBezierPath
    {
        let eyeCentreY = skullCentre.y - skullRadius/3
        let eyeCentreX = skullCentre.x + ((eye == Eye.left ? -1 : 1) * skullRadius/3)
        let eyeCentre = CGPoint(x: eyeCentreX, y: eyeCentreY)
        let eyeRadius = skullRadius/5
        
        if eyesOpen {
            let path = UIBezierPath(arcCenter: eyeCentre, radius: eyeRadius, startAngle: 0, endAngle: CGFloat.pi * 2 , clockwise: true)
            path.lineWidth = lineWidth
            return path
        }
        else {
            let path = UIBezierPath()
            let newEyeStart = eyeCentreX + ((eye == Eye.left ? -1 : 1) * eyeRadius)
            path.move(to:CGPoint(x: newEyeStart, y: eyeCentreY))
            path.addLine(to: CGPoint(x: newEyeStart + ((eye == Eye.left ? 2 : -2) * eyeRadius), y: eyeCentreY))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForSkull().stroke()
        pathForMouth().stroke()
        pathForEyes(.left).stroke()
        pathForEyes(.right).stroke()
        
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed: fallthrough
        case .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
}
