//
//  enums.swift
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 05/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

enum Keys: String {
    case USERID = "ChaveParaGuardarIdUsuario"
    case USERNAME  = "ChaveParaGuardarUsuarioNome"
    case PASSWORD  = "ChaveParaGuardarSenha"
    case EMAIL  = "ChaveParaGuardarEmail"
    case IMAGEM  = "ChaveParaGuardarImagem"
}

enum APIError: Error {
    case responseProblem
    case decodeProblem
    case otherProblem
}
