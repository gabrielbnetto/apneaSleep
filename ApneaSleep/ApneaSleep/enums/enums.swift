//
//  enums.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 05/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

enum Keys: String {
    case JWT  = "ChaveParaGuardarJWT"
    case UID = "ChaveParaGuardarUID"
    case USERNAME  = "ChaveParaGuardarEmail"
    case PASSWORD  = "ChaveParaGuardarSenha"
    case NAME  = "ChaveParaGuardarNome"
    case IMAGEM  = "ChaveParaGuardarImagem"
}

enum APIError: Error {
    case tokenExpired
    case responseProblem
    case decodeProblem
    case otherProblem
}
