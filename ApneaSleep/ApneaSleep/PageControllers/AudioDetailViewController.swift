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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Olha so: \(audio)")
        audioNameLabel.text = audio.audioName
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
