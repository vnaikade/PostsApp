//
//  NetworkManager.swift
//  TechieButlerApp
//


import Foundation
import UIKit
import CoreTelephony

protocol NetworkManagerGenerator {
    func callAPI<T>(withRequest request: APIRequestGenerator, model: T.Type) async throws -> T where T : Decodable
}

class NetworkManager: NetworkManagerGenerator {
    
    var session: URLSession!

    public func callAPI<T>(withRequest request: APIRequestGenerator, model: T.Type) async throws -> T where T : Decodable {

        guard NetworkUtility.isConnectedToNetwork() else {
            throw ErrorFactory.generateError(fromAPIError: .noInternet)
        }

        var req = request
        guard let urlRequest = req.asUrlRequest() else {
            throw ErrorFactory.generateError(fromAPIError: .invalidURLRequest)
        }
        
        session = .init(configuration: URLSessionConfiguration.ephemeral)

        do {
            let (data, response) = try await session.data(for: urlRequest)

            guard let response = response as? HTTPURLResponse else {
                throw ErrorFactory.generateError(fromAPIError: .noResponse)
            }

            switch response.statusCode {
            case 200...299:
                return try JSONDecoder().decode(T.self, from: data)
            default:
                throw ErrorFactory.generateError(fromAPIError: .httpStausCode(response.statusCode))
            }

        } catch let error {
            if error._code == NSURLErrorTimedOut {
                throw ErrorFactory.generateError(fromAPIError: .timeOut)
            } else {
                throw ErrorFactory.generateError(fromAPIError: .unknown)
            }
        }
    }
}
