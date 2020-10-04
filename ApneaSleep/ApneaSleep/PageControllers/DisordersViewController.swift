//
//  SleepDisordersViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto (E) on 16/09/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import Foundation

class SleepDisordersViewController: UIViewController {
    
    @IBOutlet weak var ApneiaView: UIView!
    @IBOutlet weak var OutroView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ApneiaView.layer.shadowOffset = .zero
        ApneiaView.layer.shadowRadius = 9
        ApneiaView.layer.shadowColor = UIColor.black.cgColor
        ApneiaView.layer.shadowOpacity = 0.5
        
        OutroView.layer.shadowOffset = .zero
        OutroView.layer.shadowRadius = 9
        OutroView.layer.shadowColor = UIColor.black.cgColor
        OutroView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func tappedOutro(_ sender: Any) {
        self.performSegue(withIdentifier: "outroDetails", sender: nil)
    }
    
    @IBAction func tappedApneia(_ sender: Any) {
        self.performSegue(withIdentifier: "apneiaDetails", sender: nil)
    }
}

