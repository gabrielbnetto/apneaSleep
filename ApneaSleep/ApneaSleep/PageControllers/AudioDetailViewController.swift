//
//  AudioDetailViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 15/06/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import Lottie

class AudioDetailViewController: UIViewController {
    var audio = AudioList(audioName: "", username: "", audioId: "", status: "", inclusionDate: "", finishedProcessingDate: "", possibleSpeech: "", didSpeak: "")
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var mainImage: AnimationView!
    @IBOutlet weak var speechLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Olha so: \(audio)")
        audioNameLabel.text = audio.audioName
        if(audio.status == "E"){
            statusLabel.text = "Erro"
        }
        if(audio.audioAnalysis.possibleSpeech == "" || audio.audioAnalysis.possibleSpeech == nil){
            speechLabel.text = "Não conseguimos detectar nenhuma fala do seu audio"
        }else{
            speechLabel.text = audio.audioAnalysis.possibleSpeech
        }
        speechLabel.sizeToFit()
        startAnimation()
    }
    
    func startAnimation() {
        let checkMarkAnimation = AnimationView(name: "soundGif")
        mainImage.contentMode = .scaleAspectFit
        self.mainImage.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = self.mainImage.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
    }
}
