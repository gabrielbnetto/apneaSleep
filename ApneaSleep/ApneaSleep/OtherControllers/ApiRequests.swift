//
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftKeychainWrapper

struct ApiResquest {
    let resourceUrl: URL
    
    init(endpoint: String){
        let resourceString = "https://sleepapp-java-base.herokuapp.com/\(endpoint)"
        guard let resourceUrl = URL(string: resourceString) else {fatalError()}
        
        self.resourceUrl = resourceUrl
    }
    
    func authenticateUser(_ json: User, completion: @escaping (Bool) -> ()){
        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(json)

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(false)
                    return
                }

                do{
                    let json = try JSON(data: jsonData)
                    let userToken = json["jwt"].stringValue
                    print(userToken)
                    KeychainWrapper.standard.set(userToken, forKey: Keys.JWT.rawValue)
                    completion(true)
                } catch {
                    completion(false)
                }
            }
            dataTask.resume()
        } catch {
            completion(false)
        }
    }

    func get(completion: @escaping (Result<JSON, APIError>) -> Void){
        let jwt = KeychainWrapper.standard.string(forKey: Keys.JWT.rawValue)
        var urlRequest = URLRequest(url: resourceUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(jwt!)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
            let httpResponse = response as? HTTPURLResponse
            if(httpResponse!.statusCode == 403){
                let postRequest = ApiResquest(endpoint: "authenticate")
                postRequest.authenticateUser(self.setUser(), completion: {result in
                    switch result{
                    case true: print("renovado")
                    case false: print("não renovado")}
                })
                completion(.failure(.tokenExpired))
                return
            }else if(httpResponse!.statusCode == 200){
                do{
                    let json = try JSON(data: data!)
                    completion(.success(json))
                } catch {
                    completion(.failure(.decodeProblem))
                }
            }else{
                completion(.failure(.responseProblem))
            }
        }
        dataTask.resume()
    }
    
    func postAudio(_ json: Audio, completion: @escaping (Result<JSON, APIError>) -> Void){
        do {
            let jwt: String = KeychainWrapper.standard.string(forKey: Keys.JWT.rawValue)!
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(json)

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                let httpResponse = response as? HTTPURLResponse
                if(httpResponse!.statusCode == 403){
                    let postRequest = ApiResquest(endpoint: "authenticate")
                    postRequest.authenticateUser(self.setUser(), completion: {result in
                        switch result{
                        case true: print("renovado")
                        case false: print("não renovado")}
                    })
                    completion(.failure(.tokenExpired))
                    return
                }else if(httpResponse!.statusCode == 200){
                    completion(.success(true))
                }else{
                    completion(.failure(.responseProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.otherProblem))
        }
    }
    
    func postEmail(_ json: AudioEmail, completion: @escaping (Result<JSON, APIError>) -> Void){
        do {
            let jwt: String = KeychainWrapper.standard.string(forKey: Keys.JWT.rawValue)!
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(json)

            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                let httpResponse = response as? HTTPURLResponse
                if(httpResponse!.statusCode == 403){
                    let postRequest = ApiResquest(endpoint: "authenticate")
                    postRequest.authenticateUser(self.setUser(), completion: {result in
                        switch result{
                        case true: print("renovado")
                        case false: print("não renovado")}
                    })
                    completion(.failure(.tokenExpired))
                    return
                }else if(httpResponse!.statusCode == 200){
                    completion(.success(true))
                }else{
                    completion(.failure(.responseProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.otherProblem))
        }
    }
    
    func setUser() -> User {
        let name = KeychainWrapper.standard.string(forKey: Keys.NAME.rawValue)
        let email = KeychainWrapper.standard.string(forKey: Keys.USERNAME.rawValue)
        let uid = KeychainWrapper.standard.string(forKey: Keys.UID.rawValue)
        let pictureUrl = KeychainWrapper.standard.string(forKey: Keys.IMAGEM.rawValue)
        
        let user = User(name: name!, username: email!, pictureUrl: pictureUrl!, uid: uid!)
        return user
    }
}
