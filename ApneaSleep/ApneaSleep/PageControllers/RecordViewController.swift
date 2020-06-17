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

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
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
            if hasPermission { print("Tem persmissao")}
        }
        
        self.audioName.isHidden = true
        self.resendButton.isHidden = true
        self.audioClear.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func displayAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func record(_ sender: Any) {
        self.buttonsEnabled(play: false, stop: true)
        recordingLabel.text = "Gravando..."
        
        if audioRecorder == nil {
            numberOfRecords += 1
            self.fileName = getDirectory().appendingPathComponent("record\(numberOfRecords).m4a")

            print("@@@@@@")
            print(self.fileName)
            
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
                displayAlert(title: "Ops!", message: "Ocorreu um erro ao realizar a gravação, por favor, tente novamente.")
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
        if let base64String = try? Data(contentsOf: self.fileName).base64EncodedString() {                self.base64 = base64String
    //            print(self.base64)
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
            
            if(formattedSeconds < 10){
                zeroSeconds = "0"
            }else{
                zeroSeconds = ""
            }
            if (formattedMinutes < 10){
                zeroMinutes = "0"
            }else{
                zeroMinutes = ""
            }
            if (formattedHour < 10){
                zeroHours = "0"
            }else{
                zeroHours = ""
            }
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
        timerLabel.textAlignment = .center
        recordingLabel.text = "Não está gravando"
        self.recordingLabel.textAlignment = .center
        self.buttonsEnabled(play: true, stop: false)
    }
    
    func sendAudio(encodedAudio: String) {
        let audio = Audio(encodedAudio: encodedAudio, audioName: self.audioName.text!)
        let postRequest = ApiResquest(endpoint: "receiveEncodedAudio")
        postRequest.postAudio(audio, completion: {result in
            switch result {
            case .success(let sucess):
                DispatchQueue.main.async {
                    print("User: \(sucess)")
                    self.resendButton.isHidden = true
                    self.audioName.isHidden = true
                    self.audioClear.isHidden = true
                    self.audioName.text = ""
                    mainLoaderController.stop()
                    self.displayAlert(title: "Sucesso", message: "Audio foi enviado e salvo com sucesso.")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.displayAlert(title: "Erro", message: "Ocorreu um erro ao tentar salvar o seu audio, por favor tente novamente mais tarde!.")
                    print("Error: \(error)")
                    mainLoaderController.stop()
                }
            }
        })
    }
    
    @IBAction func resendAudio(_ sender: Any) {
        if(self.audioName.text?.isEmpty == false){
            mainLoaderController.start()
            self.transformToBase64andSendAudio()
        }else{
             self.displayAlert(title: "Erro", message: "E necessario informar um nome para o audio!")
        }
    }
    
    @IBAction func clearAudio(_ sender: Any) {
        self.resendButton.isHidden = true
        self.audioName.isHidden = true
        self.audioClear.isHidden = true
        self.audioName.text = ""
    }
}
