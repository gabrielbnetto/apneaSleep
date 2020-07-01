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
    var audioName: String
    

    init(encodedAudio: String, audioName: String) {
        self.audioDetails.encodedAudio = encodedAudio
        self.audioName = audioName
    }
}

class AudioDetails: Codable {
    var encodedAudio: String
    
    init(encodedAudio: String, audioName: String) {
        self.encodedAudio = encodedAudio
    }
}
