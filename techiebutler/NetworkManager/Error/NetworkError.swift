//
//  NetworkError.swift
//  TechieButlerApp
//

import Foundation

class NetworkError: NSError {
    var errorType: APIError = .unknown
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(domain: String, code: Int, userInfo dict: [String: Any]? = nil) {
        super.init(domain: domain, code: code, userInfo: dict)
    }
}

enum APIError: Error, Equatable {
    case invalidURL
    case invalidURLRequest
    case unAuthorised
    case noResponse
    case sslPinningFailed
    case timeOut
    case noInternet
    case httpClientStatusCode(Int)
    case httpServerStatusCode(Int)
    case httpStausCode(Int)
    case unknown
    case parseFailed
}

enum ErrorFactory {
    
    static func generateError(domain: String, code: Int, userInfo: [String: Any]? = nil) -> NetworkError {
        NetworkError(domain: domain, code: code, userInfo: userInfo)
    }

    static func generateError(domain: String, code: Int, userInfo: [String: Any]? = nil) -> NSError {
        (NetworkError(domain: domain, code: code, userInfo: userInfo) as NSError)
    }
    
    static func generateError(fromNSError err: NSError) -> NetworkError {
        generateError(domain: err.domain, code: err.code, userInfo: err.userInfo)
    }
    
    static func generateError(fromAPIError err: APIError) -> NetworkError {
        let error = NetworkError(domain: "Network-API-Domain",
                      code: err.code,
                      userInfo: [NSLocalizedDescriptionKey: err.errorDescription as Any])
        error.errorType = err
        return error
    }
}

extension APIError: LocalizedError {

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidURLRequest:
            return "Invalid URL Request"
        case .noResponse:
            return "No Response"
        case .unknown:
            return "Sorry, we couldn't retrieve posts at the moment.\nTry again later."
        case .unAuthorised:
            return "Session Expired"
        case .sslPinningFailed:
            return "SSL Pinning failed"
        case .timeOut:
            return "Timeout Error Occurred"
        case .noInternet:
             return "No internet"
        case .httpClientStatusCode(let code):
             return "httpClientStatusCode: \(code)"
        case .httpServerStatusCode(let code ):
             return "httpServerStatusCode: \(code)"
        case .httpStausCode(let code):
             return "httpStausCode: \(code)"
        case .parseFailed:
            return "Parse failed"
        }
    }

    var code: Int {
        switch self {
        case .httpClientStatusCode(let code):
            return code
        case .httpServerStatusCode(let code):
            return code
        case .httpStausCode(let code):
            return code
        default:
            return .min
        }
    }
}
