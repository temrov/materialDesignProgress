//
//  IFMaterialProgressView.swift
//  MaterialDesignCircularProgressView
//
//  Created by vtemnogrudov on 21.12.16.
//  Copyright © 2016. All rights reserved.
//

import UIKit


import UIKit



class IFMaterialProgressView: UIView, CAAnimationDelegate {
    
    var currentPos : CGFloat! //< Determinate mode only
    
    let circularLayer = CAShapeLayer()
    private var _isDeterminate : Bool!
    var isDeterminate : Bool! {
        get {
            return _isDeterminate
        }
        set(newIsDeterminate) {
            if (newIsDeterminate == _isDeterminate) {
                return
            }
            _isDeterminate = newIsDeterminate
            if newIsDeterminate == true {
                circularLayer.strokeEnd = 0
                currentPos = 0
                circularLayer.removeAllAnimations()
            } else {
                circularLayer.strokeEnd = 1
                if isActive() == true {
                    animateProgressView(timer: nil)
                }
            }
        }
    }
    private var timer : Timer?
    var delay : TimeInterval!
    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.7
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        return animation
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.duration = 1.5
        animation.repeatCount = MAXFLOAT
        
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circularLayer.lineWidth = 3.0
        circularLayer.fillColor = nil
        circularLayer.lineCap = "round"
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = 19 as CGFloat
        circularLayer.strokeColor = UIColor(red: 1.0, green: 204.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(-M_PI_2), endAngle: CGFloat(-M_PI_2 + (2 * M_PI)), clockwise: true)
        circularLayer.path = arcPath.cgPath
        circularLayer.position = center
        
        delay = 0
        currentPos = 0
        _isDeterminate = false
        NotificationCenter.default.addObserver(self, selector: #selector(IFMaterialProgressView.backFromBackground), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateProgressView(timer : Timer?) {
        if isDeterminate == true {
            circularLayer.strokeEnd = currentPos;
            layer.addSublayer(circularLayer)
        } else {
            circularLayer.removeAllAnimations()
            
            
            let strokeAnimationGroup = CAAnimationGroup()
            strokeAnimationGroup.duration = max(inAnimation.beginTime + inAnimation.duration, outAnimation.beginTime + outAnimation.duration)
            strokeAnimationGroup.repeatCount = MAXFLOAT
            strokeAnimationGroup.animations = [outAnimation, inAnimation]
            strokeAnimationGroup.delegate = self
            
            circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
            circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
            
            layer.addSublayer(circularLayer)
        }
    }
    
    func backFromBackground(notification: Notification){
        //Take Action on Notification
        if isActive() {
            animateProgressView(timer: nil);
        }
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
        if isActive() == true {
            NSLog("IFMaterialProgressView is already active")
            return
        }
        currentPos = self.validatePositionValue(position: startValue)
        let aSelector = #selector(IFDeterminateProgress.animateProgressView)
        timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: aSelector, userInfo: nil, repeats: false)
    }
    
    func startProgressView() {
        startProgressView(startValue: 0)        
    }
    
    // determinate view only
    func updateProgress(newValue: CGFloat) {
        if isDeterminate == true {
            currentPos = newValue
            if isActive() {
                circularLayer.strokeEnd = currentPos
            }
        } else {
            NSLog("updating progress for indeterminate view is useless")
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

