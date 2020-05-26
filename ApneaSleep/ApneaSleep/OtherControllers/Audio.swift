//
//  Audio.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class Audio: Codable {
    var userId: String
    var audioDetails = AudioDetails(encodedAudio: "")

    init(userId: String, encodedAudio: String) {
        self.userId = userId
        self.audioDetails.encodedAudio = encodedAudio
    }
}

class AudioDetails: Codable {
    var encodedAudio: String
    var audioFormat: String
    
    init(encodedAudio:String) {
        self.encodedAudio = encodedAudio
        self.audioFormat = ".wav"
    }
}
