//
//  SplashController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto (E) on 17/08/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
    
    @IBOutlet weak var splashAnimation: AnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func startAnimation() {
        let checkMarkAnimation =  AnimationView(name: "splashAnimation")
        splashAnimation.contentMode = .scaleAspectFit
        self.splashAnimation.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = self.splashAnimation.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            self.performSegue(withIdentifier: "splashToHome", sender: nil)
        }
    }

}
