//
//  AudioEmail.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 22/07/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import UIKit

class AudioEmail: Codable {
    var audioId: String
    
    init(audioId: String) {
        self.audioId = audioId
    }
}
