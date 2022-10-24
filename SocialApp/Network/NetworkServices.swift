//
//  NetworkServices.swift
//  SocialApp
//
//  Created by William Huang on 18/10/22.
//

import Foundation
import RxSwift

protocol NetworkService {
    func request<T: Decodable>(request: APIData,
                               type: T.Type) -> Single<T>
}

final class URLSessionNetworkService: NetworkService {

    private let authManager: NetworkManagerProtocol

    init(authorizationManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.authManager = authorizationManager
    }

    func request<T: Decodable>(request: APIData,
                               type: T.Type) -> Single<T> {
        return Single<T>.create { observer -> Disposable in

            self.authManager.startRequest(request: request) { (data, response, error) in

                if let _ = error{
                    let errorType = NetworkError.failed
                    observer(.failure(errorType))
                }

                guard let responseData = response as? HTTPURLResponse,
                      let receivedData = data else{
                    let errorType = NetworkError.noResponseData
                    observer(.failure(errorType))
                    return
                }

                let responseStatus = self.isValidResposne(response: responseData)
                switch responseStatus {
                case .success:
                    let jsonDecoder = JSONDecoder()
                    do {
                        let apiResponseModel = try jsonDecoder.decode(T.self, from: receivedData)
                        observer(.success(apiResponseModel))
                    } catch {
                        observer(.failure(NetworkError.unableToDecodeResponseData))
                    }
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create {
                self.authManager.cancel()
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
