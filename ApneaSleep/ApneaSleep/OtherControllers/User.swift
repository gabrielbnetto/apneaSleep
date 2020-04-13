//
//  UserData.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation

class User: Codable {
    var userId: String?
    var nome: String
    var email: String
    var pictureUrl: String

    init(nome: String, email:String, pictureUrl: String) {
        self.nome = nome
        self.email = email
        self.pictureUrl = pictureUrl
    }
}
