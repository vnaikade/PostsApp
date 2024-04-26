//
//  TechieButlerRequest.swift
//  TechieButlerApp
//


import Foundation

class TechieButlerRequest: APIRequestGenerator {
    var baseURL: String
    var method: HTTPMethod
    var body: Data?
    var timeOut: TimeInterval

    init(page: Int) {
        self.baseURL = "https://jsonplaceholder.typicode.com/posts"
        self.method = .get
        self.timeOut = 60
    }
}
