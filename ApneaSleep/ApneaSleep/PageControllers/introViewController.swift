//
//  introViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 19/08/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import paper_onboarding
import Comets

class introViewController: UIViewController, CAAnimationDelegate {
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
                           titleColor:
            .white, descriptionColor: UIColor.white, titleFont: titleFont, descriptionFont: descriptionFont
    )]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        finishButton.isHidden = true
        let width = view.bounds.width
        let height = view.bounds.height
        let startCometsList = [CGPoint(x: 100, y: 0), CGPoint(x: 0.4 * width, y: 0), CGPoint(x: 0.8 * width, y: 0), CGPoint(x: 0, y: height - 0.8 * width), CGPoint(x: width, y: height - 150), CGPoint(x: 0, y: 0.4 * height), CGPoint(x: width, y: 0.5 * height), CGPoint(x: width, y: 0.2 * height)]
        let endCometsList = [CGPoint(x: 0, y: 100), CGPoint(x: width, y: 0.8 * width), CGPoint(x: width, y: 0.2 * width), CGPoint(x: 0.6 * width, y: height), CGPoint(x: width - 100, y: height), CGPoint(x: width, y: 0.75 * height), CGPoint(x: 0.3, y: height), CGPoint(x: 0, y: 350)]
        
        var comets = [Comet]()
        var i = 0
        
        while (i < startCometsList.count) {
            comets.append(Comet(startPoint: startCometsList[i],
                  endPoint: endCometsList[i],
                  lineColor: UIColor.white.withAlphaComponent(0.2),
                  cometColor: UIColor.white))
//            self.view.layer.addSublayer(comets[i].drawLine())
            self.view.layer.insertSublayer(comets[i].animate(), at: 1)
            i += 1
        }

        var index = 0
        let x = [40, 120, 310, 190, 330, 20, 105, 240, 50, 320, 170, 80, 300, 30, 170, 350, 260, 80, 300, 50]
        let y = [80, 42, 35, 130, 150, 220, 170, 200, 300, 280, 430, 400, 370, 600, 570, 610, 660, 690, 780, 770]
        let delayTime = [0, 0.8, 0.3, 0.7, 0.2, 1, 0.1, 0.6, 0.4, 0.8, 0.2, 0.7, 0.1, 0.9, 0.2, 0.6, 0.3, 1, 0, 0.9]
        while(index < x.count){
            draw(x: x[index], y: y[index], delayTime: delayTime[index])
            index += 1
        }
    }

    func draw(x: Int, y: Int, delayTime: Double) {
        let xCoord = x
        let yCoord = y
        let radius = 5

        let dotPath = UIBezierPath(ovalIn: CGRect(x: xCoord, y: yCoord, width: radius, height: radius))

        let layer = CAShapeLayer()
        layer.path = dotPath.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.white.cgColor

        let startColor = UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0).cgColor
        let finishColor = UIColor(red:0.54, green:0.54, blue:0.57, alpha:1.0).withAlphaComponent(0.0).cgColor

        let gradient = CAGradientLayer()
        gradient.frame = self.view.bounds
        gradient.colors = [startColor,finishColor]

        let shapeMask = CAShapeLayer()
        shapeMask.path = dotPath.cgPath

        gradient.mask = shapeMask
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [startColor, finishColor]
        animation.toValue = [finishColor, startColor]
        animation.duration = 2.0
        animation.beginTime = CACurrentMediaTime() + delayTime;
        animation.autoreverses = true
        animation.repeatCount = Float.infinity

        gradient.add(animation, forKey: nil)
        view.layer.addSublayer(gradient)

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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

        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0)
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
