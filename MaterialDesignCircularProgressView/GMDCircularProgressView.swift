//
//  GMDCircularProgressView.swift
//  MaterialDesignCircularProgressView
//
//  Created by Narbeh Mirzaei on 5/22/16.
//  Copyright © 2016 Narbeh Mirzaei. All rights reserved.
//

import UIKit



class GMDCircularProgressView: UIView, CAAnimationDelegate {
    
    let circularLayer = CAShapeLayer()

    let inAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        return animation
    }()
    
    let outAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.7
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 1.2
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
        let radius = 18.5 as CGFloat
        let arcPath = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI_2 + (2 * M_PI)), clockwise: true)
        
        circularLayer.position = center
        circularLayer.path = arcPath.cgPath
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if(flag) {
            animateProgressView()
        }
    }
    
    func animateProgressView() {
        circularLayer.removeAllAnimations()
        circularLayer.strokeColor = UIColor(red: 1.0, green: 204.0/255.0, blue: 0.0, alpha: 1.0).cgColor
        
        let strokeAnimationGroup = CAAnimationGroup()
        strokeAnimationGroup.duration = max(inAnimation.beginTime + inAnimation.duration, outAnimation.beginTime + outAnimation.duration)
        strokeAnimationGroup.repeatCount = MAXFLOAT
        strokeAnimationGroup.animations = [outAnimation, inAnimation]
        strokeAnimationGroup.delegate = self
      
        circularLayer.add(rotationAnimation, forKey: "rotateAnimation")
        circularLayer.add(strokeAnimationGroup, forKey: "strokeAnimation")
        
        layer.addSublayer(circularLayer)
    }
    
    func stopProgressView() {
        circularLayer.removeAllAnimations();
        circularLayer.removeFromSuperlayer();
    }
}
