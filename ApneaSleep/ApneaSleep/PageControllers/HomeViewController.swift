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
import Loaf

class HomeViewController: UIViewController {

    @IBOutlet weak var moonLoader: AnimationView!
    @IBOutlet weak var sleepQualityImage: AnimationView!
    @IBOutlet weak var personTalking: AnimationView!
    @IBOutlet weak var failAnimation: AnimationView!
    @IBOutlet weak var notTalkingSleep: AnimationView!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var noneResultView: UIView!
    @IBOutlet weak var nullResultView: UIView!
    var helloName = ""
    var checkMarkAnimationWalk = AnimationView()
    var checkNotTalkingAnimation = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userName: String = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue){
            helloLabel.text = "Olá " + userName + "!"
        }else{
            helloLabel.text = "Olá!"
        }
        self.views(result: true, null: true, none: true)
        self.startAnimation(animation: "moonLoader", view: self.moonLoader)
        
        let getRequest = ApiResquest(endpoint: "retrieveAudioListSummary")
        getRequest.get(completion: {result in
            switch result {
                case .success(let response):
                    DispatchQueue.main.async{
                        self.moonLoader.isHidden = true
                        if(response["shouldGoToDoctor"] == "S"){
                            self.views(result: false, null: true, none: true)
                            self.viewShadow(viewR: self.resultView)
                        }else if (response["shouldGoToDoctor"] == "N"){
                            self.views(result: true, null: true, none: false)
                            self.viewShadow(viewR: self.noneResultView)
                        }else{
                            self.views(result: true, null: false, none: true)
                            self.viewShadow(viewR: self.nullResultView)
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                        self.displayAlert(message: "Ocorreu um erro ao carregar sua análise!")
                        self.views(result: true, null: false, none: true)
                    }
            }
        })
    }
    
    func views(result: Bool, null: Bool, none: Bool) {
        self.resultView.isHidden = result
        self.nullResultView.isHidden = null
        self.noneResultView.isHidden = none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.startAnimation(animation: "sleepQualityImage", view: self.sleepQualityImage)
        self.startNotTalkingAnimation(animation: "notTalkingSleep", view: self.notTalkingSleep)
        self.startAnimation(animation: "failAnimation", view: self.failAnimation)
        self.startWalkingAnimation(animation: "personTalking", view: self.personTalking)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.checkMarkAnimationWalk.isHidden = true
        self.checkNotTalkingAnimation.isHidden = true
    }
    
    func viewShadow(viewR: UIView) {
        viewR.layer.cornerRadius = 10
        viewR.layer.shadowColor = UIColor.darkGray.cgColor
        viewR.layer.shadowRadius = 10.0
        viewR.layer.shadowOpacity = 0.4
        viewR.layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    func startNotTalkingAnimation(animation: String, view: AnimationView) {
        self.checkNotTalkingAnimation = AnimationView(name: animation)
        view.contentMode = .scaleAspectFit
        view.addSubview(checkNotTalkingAnimation)
        checkNotTalkingAnimation.frame = view.bounds
        checkNotTalkingAnimation.loopMode = .loop
        checkNotTalkingAnimation.play()
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
                                      possibleSpeech: audioAnalisys["possibleSpeech"].stringValue,
                                      didSpeak: audioAnalisys["didSpeak"].stringValue
                            ))
                            
                        }
                        mainLoaderController.stop()
                        self.performSegue(withIdentifier: "listAudios", sender: arrayAudio)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        mainLoaderController.stop()
                        self.displayAlert(message: "Ocorreu um erro ao tentar listar seus audios! Por favor, tente novamente em alguns segundos.")
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
    
    func displayAlert(message: String) {
        Loaf(message, state: .error, presentingDirection: .left, dismissingDirection: .right,sender: self).show()
    }

}

