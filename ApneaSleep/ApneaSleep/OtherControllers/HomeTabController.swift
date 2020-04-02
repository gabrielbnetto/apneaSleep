//
//  HomeTabController.swift
//  apnea
//
//  Created by Banco Santander Brasil on 02/03/20.
//  Copyright © 2020 Estudos. All rights reserved.

import Foundation
import UIKit

@objc class HomeTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    @objc func set(selectedIndex index : Int) {
        _ = self.tabBarController(self, shouldSelect: self.viewControllers![index])
    }
}

@objc extension HomeTabController: UITabBarControllerDelegate {
    @objc func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
        let toView = viewController.view else { return false }
        if fromView != toView {
            UIView.transition(from: fromView, to: toView, duration: 0.1, options: [.transitionCrossDissolve], completion: { (true) in })
            self.selectedViewController = viewController
        }
        return true
    }
}
