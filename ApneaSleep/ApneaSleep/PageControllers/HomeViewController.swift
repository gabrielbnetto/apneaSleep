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
import SwiftyJSON

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
    var helloName = ""
    var checkMarkAnimationWalk = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewShadow()
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue){
            helloLabel.text = "Olá " + userName + "!"
        }
        self.nullResultView.isHidden = true
        self.resultView.isHidden = true
        self.startAnimation(animation: "moonLoader", view: self.moonLoader)
        
        let getRequest = ApiResquest(endpoint: "retrieveAudioListSummary")
        getRequest.get(completion: {result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async{
                        self.moonLoader.isHidden = true
                        self.startAnimation(animation:
                            "sleepQualityImage", view: self.sleepQualityImage)
                        if(response["shouldGoToDoctor"] == "S"){
                            self.resultView.isHidden = false
                            self.resultLabel1.text = "Você está falando durante seu sono."
                            self.resultLabel2.text = "Recomendamos que você procure um profissional para verificar se não possui nenhum problema de saúde."
                        }else if (response["shouldGoToDoctor"] == "N"){
                            self.resultView.isHidden = false
                            self.resultLabel1.text = "Você não está falando durante seu sono."
                            self.resultLabel2.text = "Mesmo com este resultado, a análise ainda esta suscetível a erros, caso sinta algo estranho, recomendamos que procure um profissional da área."
                        }else{
                            self.startAnimation(animation: "failAnimation", view: self.failAnimation)
                            self.resultView.isHidden = true
                            self.nullResultView.isHidden = false
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        })
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
                        var arrayAudio = [AudioList]()
                        for (_, audioList):(String, JSON) in response{
                            let audioAnalisys = JSON(audioList["audioAnalisys"])
                            arrayAudio.append(AudioList(audioName: audioList["audioName"].stringValue,
                                      username: audioList["username"].stringValue,
                                      audioId: audioList["audioId"].stringValue,
                                      status: audioList["status"].stringValue,
                                      inclusionDate: audioList["inclusionDate"].stringValue,
                                      finishedProcessingDate: audioList["finishedProcessingDate"].stringValue,
                                      possibleSpeech: audioAnalisys["possibleSpeech"].stringValue, didSpeak: audioAnalisys["didSpeak"].stringValue
                            ))
                            
                        }
                        mainLoaderController.stop()
                        self.performSegue(withIdentifier: "listAudios", sender: arrayAudio)
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

