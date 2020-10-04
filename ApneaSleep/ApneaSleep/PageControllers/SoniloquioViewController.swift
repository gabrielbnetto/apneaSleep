//
//  SoniloquioViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto (E) on 17/09/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit

class SoniloquioViewController: UIViewController {
    @IBOutlet weak var percentageSoniloquio: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners()
    }
    
    func roundedCorners(){
        let path = UIBezierPath(roundedRect: percentageSoniloquio.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 13, height: 13))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        percentageSoniloquio.layer.mask = mask
    }
}
