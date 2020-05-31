//
//  Audio.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class Audio: Codable {
    var audioDetails = AudioDetails(encodedAudio: "")

    init(encodedAudio: String) {
        self.audioDetails.encodedAudio = encodedAudio
    }
}

class AudioDetails: Codable {
    var encodedAudio: String
    
    init(encodedAudio:String) {
        self.encodedAudio = encodedAudio
    }
}
