//
//  UserData.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class User: Codable {
    var name: String
    var username: String
    var pictureUrl: String
    var uid: String

    init(name: String, username:String, pictureUrl: String, uid: String) {
        self.name = name
        self.uid = uid
        self.username = username
        self.pictureUrl = pictureUrl
    }
}
