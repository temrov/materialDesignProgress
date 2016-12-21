//
//  IFDeterminateProgress.swift
//  MaterialDesignCircularProgressView
//
//  Created by vtemnogrudov on 21.12.16.
//  Copyright © 2016 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class IFDeterminateProgress: UIView, CAAnimationDelegate {
    
    let circularLayer = CAShapeLayer()
    
    private var timer : Timer?
    var delay : TimeInterval!
    var currentPos : CGFloat!
    var radius : CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circularLayer.lineWidth = 3.0
        circularLayer.fillColor = nil
        circularLayer.lineCap = "round"
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        circularLayer.position = center
        
        delay = 0
        currentPos = 0
      
        radius = 19
        circularLayer.strokeColor = UIColor(red: 1.0, green: 204.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(-M_PI_2 + (2 * M_PI)), clockwise: true)
        circularLayer.path = arcPath.cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateProgressView(timer : Timer?) {

        circularLayer.strokeEnd = currentPos;
        layer.addSublayer(circularLayer)
    }
    
    private func validatePositionValue(position : CGFloat) -> (CGFloat){
        var validatedPosition : CGFloat
        if position > 1.0 {
            NSLog("position = %f. Max value considered to be equal to 1.0", position)
            validatedPosition = 1.0
        } else if position < 0.0 {
            NSLog("position = %f. Min value considered to be equal to 0.0", position)
            validatedPosition = 0.0
        } else {
            validatedPosition = position
        }
        return validatedPosition
    }
    
    func startProgressView(startValue : CGFloat) {
        currentPos = self.validatePositionValue(position: startValue)
        let aSelector = #selector(IFDeterminateProgress.animateProgressView)
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: aSelector, userInfo: nil, repeats: false);
    }
    
    func updateProgress(newValue: CGFloat) {
        currentPos = newValue
        if isActive() {
           circularLayer.strokeEnd = currentPos
        }
    }
    
    func stopProgressView() {
        timer?.invalidate();
        circularLayer.removeAllAnimations();
        circularLayer.removeFromSuperlayer();
    }
    
    func isActive() -> Bool {
        return circularLayer.superlayer != nil
    }
}
