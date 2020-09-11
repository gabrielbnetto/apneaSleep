//
//  RecordViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 05/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftKeychainWrapper
import Loaf

class RecordViewController: UIViewController, AVAudioRecorderDelegate, UITextFieldDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords:Int = 0
    var fileName: URL!
    var time = 0
    var timer = Timer()
    var base64: String = ""
    
    @IBOutlet weak var audioClear: UIButton!
    @IBOutlet weak var audioName: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let number: Int = UserDefaults.standard.object(forKey: "recordNumber") as? Int {
            self.numberOfRecords = number
        }

        self.notRecordingLabels()
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission {
                print("Tem permissao")
            } else {
                self.displayAlert(message: "Você não permitiu que o ApneaSleep grave seu audio. \nÉ necessário habilitar nas configurações do seu celular!", type: 3)
                self.buttonsEnabled(play: false, stop: false)
            }
        }
        
        self.audioName.isHidden = true
        self.resendButton.isHidden = true
        self.audioClear.isHidden = true
        audioName.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func displayAlert (message: String, type: Int) {
        switch type {
            case 1: Loaf(message, state: .error, sender: self).show()
                    mainLoaderController.stop()
            case 2: Loaf(message,
                         state: .custom(.init(backgroundColor: .black, icon: UIImage(named: "moon"))),
                         presentingDirection: .left, dismissingDirection: .right, sender: self).show()
            default:Loaf(message, state: .warning, sender: self).show()
        }
    }
    
    @IBAction func record(_ sender: Any) {
        self.buttonsEnabled(play: false, stop: true)
        recordingLabel.text = "Gravando..."
        
        if audioRecorder == nil {
            numberOfRecords += 1
            self.fileName = getDirectory().appendingPathComponent("record\(numberOfRecords).m4a")
            let settings = [ AVFormatIDKey : kAudioFormatAppleLossless,
                             AVEncoderBitRateKey: 44100.0,
                             AVNumberOfChannelsKey: 1,
                             AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ] as [String : Any]
            
            do {
                audioRecorder = try AVAudioRecorder(url: self.fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                self.timerCount()
            } catch {
                self.stoppedAudio()
                displayAlert(message: "Ocorreu um erro ao realizar a gravação, por favor, tente novamente.", type: 1)
                print(error)
            }
        }
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        self.stoppedAudio()
        UserDefaults.standard.set(numberOfRecords, forKey: "recordNumber")
        self.audioName.isHidden = false
        self.resendButton.isHidden = false
        self.audioClear.isHidden = false
    }
    
    func buttonsEnabled(play: Bool, stop: Bool){
        playButton.isEnabled = play
        stopButton.isEnabled = stop
    }
    
    func transformToBase64andSendAudio(){
        if let base64String = try? Data(contentsOf: self.fileName).base64EncodedString() {
            self.base64 = base64String
            self.sendAudio(encodedAudio: base64String)
        }
    }

    @objc func timerCount() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self!.time += 1
            
            let formattedSeconds = (self!.time / 36000)
            let formattedMinutes = ((self!.time % 3600) / 60)
            let formattedHour = ((self!.time % 3600) % 60)
            
            var zeroSeconds = ""
            var zeroMinutes = ""
            var zeroHours = ""
            
            if(formattedSeconds < 10){ zeroSeconds = "0" }
            if (formattedMinutes < 10){ zeroMinutes = "0" }
            if (formattedHour < 10){ zeroHours = "0" }
            self!.timerLabel.text =
                "Tempo de Gravação: \(zeroSeconds)\(formattedSeconds):\(zeroMinutes)\(formattedMinutes):\(zeroHours)\(formattedHour) horas"
        })
    }
    
    func stoppedAudio() {
        audioRecorder.stop()
        audioRecorder = nil
        self.timer.invalidate()
        self.time = 0
        self.notRecordingLabels()
    }
    
    func notRecordingLabels() {
        timerLabel.text = "Tempo de Gravação: 00:00:00 horas"
        recordingLabel.text = "Não está gravando"
        self.buttonsEnabled(play: true, stop: false)
    }
    
    func sendAudio(encodedAudio: String) {
        let audio = Audio(encodedAudio: encodedAudio, audioName: self.audioName.text!)
        let postRequest = ApiResquest(endpoint: "receiveEncodedAudio")
        postRequest.postAudio(audio, completion: {result in
            switch result {
            case .success( _):
                DispatchQueue.main.async {
                    self.resendButton.isHidden = true
                    self.audioName.isHidden = true
                    self.audioClear.isHidden = true
                    self.audioName.text = ""
                    self.displayAlert(message: "Audio foi salvo com sucesso.", type: 2)
                    mainLoaderController.stop()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayAlert(message: "Ocorreu um erro ao tentar salvar o seu audio, por favor tente novamente mais tarde!.", type: 1)
                    self.animateButton(button: self.resendButton)
                    print("Error: \(error)")
                }
            }
        })
    }
    
    @IBAction func resendAudio(_ sender: Any) {
        if(self.audioName.text?.isEmpty == false){
            mainLoaderController.start()
            self.transformToBase64andSendAudio()
        }else{
            self.displayAlert(message: "E necessario informar um nome para o audio!", type: 3)
            self.animateButton(button: self.audioName)
        }
    }
    
    @IBAction func clearAudio(_ sender: Any) {
        self.resendButton.isHidden = true
        self.audioName.isHidden = true
        self.audioClear.isHidden = true
        self.audioName.text = ""
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let preText = textField.text as NSString?,
            preText.replacingCharacters(in: range, with: string).count <= 20 else {
            return false
        }
        return true
    }
    
    func animateButton(button: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: button.center.x - 10, y: button.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: button.center.x + 10, y: button.center.y))
        button.layer.add(animation, forKey: "position")
    }
}
