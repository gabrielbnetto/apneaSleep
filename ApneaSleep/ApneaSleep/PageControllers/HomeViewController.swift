//
//  HomeViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 09/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class HomeViewController: UIViewController {
//    @IBOutlet var backButtonView: UIView!
    
    @IBOutlet weak var hellowLabel: UILabel!
    var helloName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.USERNAME.rawValue){
            hellowLabel.text = "Olá " + userName + "!"
        }
    }

}
