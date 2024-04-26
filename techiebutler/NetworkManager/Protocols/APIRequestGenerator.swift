//
//  APIRequestGenerator.swift
//  TechieButlerApp
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIRequestGenerator {
    var baseURL: String { get set }
    var method: HTTPMethod { get}
    var body: Data? { get set}
    var timeOut: TimeInterval {get  set}
}

extension APIRequestGenerator {
    var url: URL? {
        return URL(string: "\(self.baseURL)")
    }
    
    mutating func asUrlRequest() -> URLRequest? {
        guard let url = self.url else {
            return nil
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = self.method.rawValue
        urlRequest.timeoutInterval = self.timeOut
        urlRequest.httpBody = self.body
        return urlRequest
    }
}
