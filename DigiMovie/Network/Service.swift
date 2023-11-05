//
//  MovieService.swift
//  DigiMovie
//
//  Created by Arda Sisli on 2.11.2023.
//

import Foundation

enum HttpError: Error {
    case  errorDecodingData
}

protocol HttpClientProtocol {
    func fetchData<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void)
}

class HttpClient: HttpClientProtocol {
    
    private let client: URLSession
    
    init(client: URLSession) {
        self.client = client
    }
    
    func fetchData<T: Codable>(url: URL,
                           completion: @escaping (Result<T, Error>) -> Void) {
        
        client.dataTask(with: url) { (data,respone,error) in
            if error != nil || data == nil { return }
            
            do {
                let moviedata = try JSONDecoder().decode(T.self, from: data!)
                completion(.success(moviedata))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
            
        }.resume()
    }
}
