//
//  AudioDetailViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 15/06/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import Lottie
import Loaf

class AudioDetailViewController: UIViewController {
    var audio = AudioList(audioName: "", username: "", audioId: "", status: "", inclusionDate: "", finishedProcessingDate: "", possibleSpeech: "", didSpeak: "")
    @IBOutlet weak var audioNameLabel: UILabel!
    @IBOutlet weak var mainImage: AnimationView!
    @IBOutlet weak var speechLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var audioDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioNameLabel.text = audio.audioName
        if(audio.status == "E"){
            statusLabel.text = "Status: Erro"
        }else if(audio.status == ""){
            statusLabel.text = " "
        }
        
        if(audio.audioAnalysis.possibleSpeech != ""){
            speechLabel.text = audio.audioAnalysis.possibleSpeech
        }
        audioDate.text = audio.inclusionDate
        speechLabel.sizeToFit()
        startAnimation()
    }
    
    @IBAction func sendMail(_ sender: Any) {
        if(audio.status == "E"){
            DispatchQueue.main.async{
                self.displayAlert(message: "O audio selecionado para o envio do email está com erro! \nSolicite um que foi analisado!", type: 2)
            }
            return;
        }
        
        mailLoaderController.start()
//        let audioEmail = AudioEmail(audioId: self.audio.audioId)
//        let postRequest = ApiResquest(endpoint: "sendAudioDataEmail")
//        postRequest.postEmail(audioEmail, completion: {result in
//            switch result {
//                case .success( _):
//                    DispatchQueue.main.async{
//                        mailLoaderController.stop()
//                        self.displayAlert(message: "Email enviado com sucesso!", type: 1)
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async{
//                        mailLoaderController.stop()
//                        self.displayAlert(message: "Ocorreu um erro ao enviar email! Por favor, tente novamente em alguns segundos.", type: 3)
//                        print(error)
//                    }
//            }
//        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            mailLoaderController.stop()
        }
    }
    
    func startAnimation() {
        let checkMarkAnimation = AnimationView(name: "soundGif")
        mainImage.contentMode = .scaleAspectFit
        self.mainImage.addSubview(checkMarkAnimation)
        checkMarkAnimation.frame = self.mainImage.bounds
        checkMarkAnimation.loopMode = .loop
        checkMarkAnimation.play()
    }
    
    func displayAlert (message: String, type: Int) {
        switch type {
            case 1:Loaf(message, state: .custom(.init(backgroundColor: .black, icon: UIImage(named: "sendMail"))), sender: self).show()
            case 2:Loaf(message, state: .warning, sender: self).show()
            default:Loaf(message, state: .error, sender: self).show()
        }
    }
}
