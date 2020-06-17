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
    var audioDate: String
    var audioId: String
    
    init(audioName: String, audioDate: String, audioId: String){
        self.audioName = audioName
        self.audioDate = audioDate
        self.audioId = audioId
    }
}
