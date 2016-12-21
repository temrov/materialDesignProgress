//
//  ViewController.swift
//  MaterialDesignCircularProgressView
//
//  Created by Narbeh Mirzaei on 5/22/16.
//  Copyright © 2016 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var progressView : IFMaterialProgressView?
    var determinateProgressView : IFMaterialProgressView?
    var isAnimating : Bool!
    @IBOutlet weak var delayText: UITextField!
    
    var determinatePos : CGFloat = 0.1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressView = IFMaterialProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:50, height:50)))
        progressView?.center = self.view.center
        self.view.addSubview(progressView!)
        
        
        determinateProgressView = IFMaterialProgressView(frame: CGRect(origin: CGPoint(x:100, y:300), size: CGSize(width:50, height:50)))
        determinateProgressView?.isDeterminate = true
        self.view.addSubview(determinateProgressView!)
        determinateProgressView!.delay = 3
        determinateProgressView!.startProgressView(startValue: determinatePos)
        isAnimating = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapStartStopButton(_ sender: UIButton) {
        let numberFormatter = NumberFormatter()
        let delay = numberFormatter.number(from: delayText.text!)
        progressView?.delay = delay?.doubleValue
        if isAnimating == false {
            sender.setTitle("Stop", for: .normal)
            progressView?.startProgressView()
            
            
        } else {
            sender.setTitle("Start", for: .normal)
            progressView?.stopProgressView()
            
            
        }
        isAnimating = !isAnimating
    }
    
    @IBOutlet weak var incrementButton: UIButton!
    
    @IBAction func incrementButtonTap(_ sender: UIButton) {
        if determinateProgressView?.isDeterminate == true {
            determinatePos += 0.1
            
            determinateProgressView!.updateProgress(newValue: determinatePos)
            
            if determinatePos >= 1 {
                determinatePos = 0
            }
        }
    }
    
    @IBAction func determinateButtonTap(_ sender: UIButton) {
        if determinateProgressView?.isDeterminate == true {
            sender.setTitle("Determinate", for: .normal)
        } else {
            sender.setTitle("Indeterminate", for: .normal)
        }
        determinateProgressView?.isDeterminate = !(determinateProgressView?.isDeterminate)!
        
        incrementButton.isEnabled = (determinateProgressView?.isDeterminate)!
    }
}

