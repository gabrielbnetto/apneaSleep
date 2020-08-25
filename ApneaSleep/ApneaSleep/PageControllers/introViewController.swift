//
//  introViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto (E) on 19/08/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import paper_onboarding

class introViewController: UIViewController {
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var headerLabel: UIView!
    
    static let titleFont = UIFont.boldSystemFont(ofSize: 32.0)
    static let descriptionFont = UIFont.systemFont(ofSize: 15.0)
    fileprivate let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "introImage")!,
                           title: "Análise em tempo real",
                           description: "Grave o áudio do seu sono para ter no dia seguinte uma análise completa sobre o audio enviado!",
                           pageIcon: UIImage(named: "graphIcon")!,
                           color: UIColor(red: 0.075, green: 0.086, blue: 0.173, alpha: 0.99),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "microphone")!,
                           title: "Grave seu Audio",
                           description: "Simples e intuitivo. Começe a gravar seu audio na hora de deitar e quando acordar, pare de gravar e envie para ter sua análise. Você pode até nomear seu audio como quiser para identificar depois!",
                           pageIcon: UIImage(named: "playIcon")!,
                           color: UIColor(red: 0.075, green: 0.086, blue: 0.173, alpha: 0.99),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "reportAnalysis")!,
                           title: "Relatório",
                           description: "Caso queira, enviamos um relátorio completo, com diversas informações sobre cada audio salvo para o seu email, além de mostrar algumas informações aqui no App!",
                           pageIcon: UIImage(named: "report")!,
                           color: UIColor(red: 0.075, green: 0.086, blue: 0.173, alpha: 0.99),
                           titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont),
        
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        finishButton.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupPaperOnboardingView()
        
        view.bringSubviewToFront(headerLabel)
        view.bringSubviewToFront(finishButton)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)

        // Add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }

}

extension introViewController: PaperOnboardingDelegate {

    func onboardingWillTransitonToIndex(_ index: Int) {
        finishButton.isHidden = index == 2 ? false : true
    }
}

extension introViewController: PaperOnboardingDataSource {

    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }

    func onboardingItemsCount() -> Int {
        return 3
    }
}
