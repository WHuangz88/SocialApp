//
//  NetworkManagerSpy.swift
//  SocialAppTests
//
//  Created by William Huang on 19/10/22.
//

@testable import SocialApp
import XCTest
import Foundation

class NetworkManagerSpy: NetworkManagerProtocol {

    func startRequest(request: APIData, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let data = try? JSONLoader.getData(fromJSON: "Mock"), let url = URL(string: request.absolutePath) {
            let response = HTTPURLResponse(url: url, statusCode: 200,
                                           httpVersion: nil, headerFields: nil)
            completion(data, response, nil)
        } else {
            completion(nil, nil, NetworkError.malformedURL)
        }
    }

    var cancelCalled = false
    func cancel() {
        cancelCalled = true
    }

}

struct JSONLoader {

    private init() {}

    enum TestError: Error {
        case fileNotFound
    }

    private class EmptyClass {}

    static func getData(fromJSON fileName: String) throws -> Data {
        let bundle = Bundle(for: JSONLoader.EmptyClass.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing File: \(fileName).json")
            throw TestError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            throw error
        }
    }
}
