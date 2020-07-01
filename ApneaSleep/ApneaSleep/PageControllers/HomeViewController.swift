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
        let getRequest = ApiResquest(endpoint: "retrieveAudioListSummary")
        getRequest.get(completion: {result in
            switch result {
                case .success(let response):
                    print(response)
                case .failure(let error):
                    print(error)
            }
        })
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
        self.failAnimation.isHidden = true
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
    
    @IBAction func goToListPage() {
        mainLoaderController.start()
        let getRequest = ApiResquest(endpoint: "retrieveAudioList")
        getRequest.get(completion: {result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        let arrayType = response.arrayValue.map{
                            AudioList(audioName: $0["audioName"].stringValue,
                                      username:$0["username"].stringValue,
                                      audioId: $0["audioId"].stringValue,
                                      status: $0["status"].stringValue,
                                      inclusionDate: $0["inclusionDate"].stringValue,
                                      finishedProcessingDate: $0["finishedProcessingDate"].stringValue,
                                      possibleSpeech: $0["possibleSpeech"].stringValue,
                                      didSpeak: $0["didSpeak"].stringValue
                            )
                        }
                        mainLoaderController.stop()
                        self.performSegue(withIdentifier: "listAudios", sender: arrayType)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        mainLoaderController.stop()
                        self.displayAlert()
                        print("Error: \(error)")
                    }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination.isKind(of: ListAudioViewController.self)) {
            let vc = segue.destination as! ListAudioViewController
            if let audio = sender as? Array<AudioList> {
                vc.audios = audio
            }
        }
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "Erro", message: "Ocorreu um erro ao tentar listar seus audios! Por favor, tente novamente em alguns segundos.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

