//
//  ViewController.swift
//  MaterialDesignCircularProgressView
//
//  Created by Narbeh Mirzaei on 5/22/16.
//  Copyright © 2016 Narbeh Mirzaei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var progressView : GMDCircularProgressView?
    var isAnimating : Bool!
    @IBOutlet weak var delayText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        progressView = GMDCircularProgressView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width:50, height:50)))
        progressView?.center = self.view.center
        self.view.addSubview(progressView!)
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
}

