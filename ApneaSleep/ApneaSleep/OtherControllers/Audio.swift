//
//  Audio.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class Audio: Codable {
    var audioDetails = AudioDetails(encodedAudio: "", audioName: "")

    init(encodedAudio: String, audioName: String) {
        self.audioDetails.encodedAudio = encodedAudio
        self.audioDetails.audioName = audioName
    }
}

class AudioDetails: Codable {
    var encodedAudio: String
    var audioName: String
    
    init(encodedAudio: String, audioName: String) {
        self.audioName = audioName
        self.encodedAudio = encodedAudio
    }
}
