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
    
    @IBOutlet weak var recordingLabel: UILabel!
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var numberOfRecords = 0

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordingLabel.text = "Não está gravando"
        self.recordingLabel.textAlignment = .center
        stopButton.isEnabled = false
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (hasPermission) in
            if hasPermission { print("Tem persmissao")}
        }
    }
    
    //Function that gets path to directory that the files are saved
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    //Function that displays an alert
    func displayAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func record(_ sender: Any) {
        playButton.isEnabled = false
        stopButton.isEnabled = true
        recordingLabel.text = "Gravando..."
        self.recordingLabel.textAlignment = .center
        
        // Check if we have an active record
        if audioRecorder == nil {
            numberOfRecords += 1
            let fileName = getDirectory().appendingPathComponent("record\(numberOfRecords).m4a")
            print("@@@@@@")
            print(fileName)
            
            let settings = [ AVFormatIDKey : kAudioFormatAppleLossless,
                             AVEncoderBitRateKey: 44100.0,
                             AVNumberOfChannelsKey: 1,
                             AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue
                ] as [String : Any]
            
            //Start audio Recording
            do {
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                playButton.isEnabled = false
                stopButton.isEnabled = true
            } catch {
                playButton.isEnabled = true
                stopButton.isEnabled = false
                displayAlert(title: "Ops!", message: "A gravação falhou")
                print(error)
            }
        }
    }
    
    @IBAction func stopRecord(_ sender: Any) {
        //Stoping audio recording
        audioRecorder.stop()
        audioRecorder = nil
        playButton.isEnabled = true
        stopButton.isEnabled = false
        recordingLabel.text = "Não está gravando"
        self.recordingLabel.textAlignment = .center
    }
}
