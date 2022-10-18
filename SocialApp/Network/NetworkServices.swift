//
//  NetworkServices.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation

protocol NetworkService {
    func request<T: Decodable>(request: APIData,
                               type: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void)
}

final class URLSessionNetworkService: NetworkService {

    private let authManager: NetworkManagerProtocol

    init(authorizationManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.authManager = authorizationManager
    }

    func request<T: Decodable>(request: APIData,
                               type: T.Type,
                               completion: @escaping (Result<T, Error>) -> Void) {
        self.authManager.startRequest(request: request) { (data, response, error) in

            if let _ = error{
                let errorType = NetworkError.failed
                completion(.failure(errorType))
                return
            }

            guard let responseData = response as? HTTPURLResponse,
                  let receivedData = data else{
                let errorType = NetworkError.noResponseData
                completion(.failure(errorType))
                return
            }

            let responseStatus = self.isValidResposne(response: responseData)
            switch responseStatus {
            case .success:
                let jsonDecoder = JSONDecoder()
                do {
                    let apiResponseModel = try jsonDecoder.decode(T.self, from: receivedData)
                    completion(.success(apiResponseModel))
                } catch {
                    completion(.failure(NetworkError.unableToDecodeResponseData(errorDescription: error.localizedDescription)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    private func isValidResposne(response: HTTPURLResponse) -> Result<String, NetworkError> {
        switch response.statusCode{
        case 200...299:
            return .success("Valid Response")
        case 401:
            return .failure(NetworkError.authenticationError)
        case 500:
            return .failure(NetworkError.badRequest)
        default:
            return .failure(NetworkError.failed)
        }
    }
}
