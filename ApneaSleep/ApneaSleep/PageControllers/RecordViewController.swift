//
//  RecordViewController.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 05/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords:Int = 0
    var fileName: URL!
    var fileWavName: URL!
    var time = 0
    var timer = Timer()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
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
        self.audioConversorToWav()
//        self.tranformAudioToBase64()
    }
    
    func buttonsEnabled(play: Bool, stop: Bool){
        playButton.isEnabled = play
        stopButton.isEnabled = stop
    }
    
    func audioConversorToWav(){
        self.fileWavName = getDirectory().appendingPathComponent("recordWav\(numberOfRecords).wav")
        try! FileManager.default.copyItem(at: self.fileName, to: self.fileWavName)
        try! FileManager.default.removeItem(at: self.fileName)
    }
    
//    func tranformAudioToBase64(){
//        if let base64String = try? Data(contentsOf: self.fileWavName).base64EncodedString() {
//            print(base64String)
//        }
//    }
//

    @objc func timerCount() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (_) in
            self!.time += 1
            
            let formattedSeconds = (self!.time / 36000)
            let formattedMinutes = ((self!.time % 3600) / 60)
            let formattedHour = ((self!.time % 3600) % 60)
            self!.timerLabel.text = "Tempo de Gravação: \(formattedSeconds):\(formattedMinutes):\(formattedHour) horas"
        })
    }
    
    func stoppedAudio() {
        audioRecorder.stop()
        audioRecorder = nil
        timer.invalidate()
        self.notRecordingLabels()
    }
    
    func notRecordingLabels() {
        timerLabel.text = "Tempo de Gravação: 00:00:00 horas"
        timerLabel.textAlignment = .center
        recordingLabel.text = "Não está gravando"
        self.recordingLabel.textAlignment = .center
        self.buttonsEnabled(play: true, stop: false)
    }
}


