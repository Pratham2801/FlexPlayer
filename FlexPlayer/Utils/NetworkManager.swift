//
//  NetworkManager.swift
//  FlexPlayer
//
//  Created by admin25 on 06/08/25.
//
import Foundation

// A potential error we can encounter during network operations
enum NetworkError: Error {
    case badURL
    case requestFailed(Error)
    case decodingFailed
    case invalidResponse
}

// A simple, reusable network manager
class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch<T: Codable>(from urlString: String, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            // Ensure we're on the main thread for the completion handler
            // as it will likely trigger UI updates.
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.requestFailed(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.decodingFailed))
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(.decodingFailed))
                }
            }
        }.resume()
    }
}
