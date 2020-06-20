//
//  HomeViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 09/03/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Lottie

class HomeViewController: UIViewController {

    @IBOutlet weak var moonLoader: AnimationView!
    @IBOutlet weak var sleepQualityImage: AnimationView!
    @IBOutlet weak var personTalking: AnimationView!
    @IBOutlet weak var failAnimation: AnimationView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultLabel1: UILabel!
    @IBOutlet weak var resultLabel2: UILabel!
    @IBOutlet weak var nullResultView: UIView!
    
    var teste = 3
    var helloName = ""
    var checkMarkAnimationWalk = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShadow()
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue){
            helloLabel.text = "Olá " + userName + "!"
        }
        startAnimation(animation: "moonLoader", view: moonLoader)
        self.startAnimation(animation: "sleepQualityImage", view: self.sleepQualityImage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.moonLoader.isHidden = true
            self.startAnimation(animation:
                "sleepQualityImage", view: self.sleepQualityImage)
            if(self.teste == 1){
                self.resultView.isHidden = false
                self.resultLabel1.text = "Você está falando durante seu sono."
                self.resultLabel2.text = "Recomendamos que você procure um profissional para verificar se não possui nenhum problema de saúde."
            }else if (self.teste == 2){
                self.resultView.isHidden = false
                self.resultLabel1.text = "Você não está falando durante seu sono."
                self.resultLabel2.text = "Mesmo com este resultado, a análise ainda esta suscetível a erros, caso sinta algo estranho, recomendamos que procure um profissional da área."
            }else{
                self.startAnimation(animation: "failAnimation", view: self.failAnimation)
                self.resultView.isHidden = true
                self.nullResultView.isHidden = false
            }
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startAnimation(animation: "failAnimation", view: self.sleepQualityImage)
        self.startWalkingAnimation(animation: "personTalking", view: self.personTalking)
        self.startAnimation(animation: "sleepQualityImage", view: self.sleepQualityImage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.checkMarkAnimationWalk.isHidden = true
    }
    
    func viewShadow() {
        self.resultView.layer.cornerRadius = 10
        self.resultView.layer.shadowColor = UIColor.darkGray.cgColor
        self.resultView.layer.shadowRadius = 10.0
        self.resultView.layer.shadowOpacity = 0.4
        self.resultView.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    func startWalkingAnimation(animation: String, view: AnimationView) {
        self.checkMarkAnimationWalk = AnimationView(name: animation)
        view.contentMode = .scaleAspectFit
        view.addSubview(checkMarkAnimationWalk)
        checkMarkAnimationWalk.frame = view.bounds
        checkMarkAnimationWalk.loopMode = .loop
        checkMarkAnimationWalk.play()
    }
    
    func startAnimation(animation: String, view: AnimationView) {
        let checkMarkAnimation = AnimationView(name: animation)
        view.contentMode = .scaleAspectFit
        view.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = view.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
    }
}

