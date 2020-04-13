//
//  ApneaSleep
//
//  Created by Gabriel Boccia Netto on 12/04/20.
//  Copyright © 2020 Estudos. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ApiResquest {
    let resourceUrl: URL
    
    init(endpoint: String){
        let resourceString = "https://sleepapp-java-base.herokuapp.com/\(endpoint)"
        guard let resourceUrl = URL(string: resourceString) else {fatalError()}
        
        self.resourceUrl = resourceUrl
    }
    
    func postUser(_ json: User, completion: @escaping (Result<JSON, APIError>) -> Void){

        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(json)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do{
                    let json = try JSON(data: jsonData)
                    completion(.success(json))
                } catch {
                    completion(.failure(.decodeProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.otherProblem))
        }
    }
    
    func get(completion: @escaping (Result<JSON, APIError>) -> Void){

        do {
            var urlRequest = URLRequest(url: resourceUrl)
            urlRequest.httpMethod = "GET"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do{
                    let json = try JSON(data: jsonData)
                    completion(.success(json))
                } catch {
                    completion(.failure(.decodeProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.otherProblem))
        }
    }
}
