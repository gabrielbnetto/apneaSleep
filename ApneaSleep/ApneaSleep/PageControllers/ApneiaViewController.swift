//
//  ApneiaViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto (E) on 17/09/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit

class ApneiaViewController: UIViewController {
    @IBOutlet weak var percentageApneia: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners()
    }
    
    func roundedCorners(){
        let path = UIBezierPath(roundedRect: percentageApneia.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 13, height: 13))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        percentageApneia.layer.mask = mask
    }
}
