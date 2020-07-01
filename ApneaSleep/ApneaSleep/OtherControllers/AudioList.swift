//
//  AudioList.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 15/06/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class AudioList: Codable {
    var audioName: String
    var inclusionDate: String
    var finishedProcessingDate: String
    var status: String
    var username: String
    var audioId: String
    var audioAnalysis = AudioAnalisys(didSpeak: "", audioId: "", possibleSpeech: "")

    init(audioName: String, username: String, audioId: String, status: String, inclusionDate: String, finishedProcessingDate: String, possibleSpeech: String, didSpeak: String){
        self.audioName = audioName
        self.username = username
        self.status = status
        self.inclusionDate = inclusionDate
        self.finishedProcessingDate = finishedProcessingDate
        self.audioId = audioId
        self.audioAnalysis.audioId = audioId
        self.audioAnalysis.possibleSpeech = possibleSpeech
        self.audioAnalysis.didSpeak = didSpeak
    }
}

class AudioAnalisys: Codable {
    var didSpeak: String
    var audioId: String
    var possibleSpeech: String

    init(didSpeak: String, audioId: String, possibleSpeech: String) {
        self.didSpeak = didSpeak
        self.audioId = audioId
        self.possibleSpeech = possibleSpeech
    }
}

