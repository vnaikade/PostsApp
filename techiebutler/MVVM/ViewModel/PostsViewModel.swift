//
//  PostsViewModel.swift
//  TechieButlerApp
//

import Foundation
import Combine

class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var error: NetworkError? = nil
    
    init(withError: Bool = false) {
        self.fetchPosts()
    }
    
    func fetchPosts(page: Int = 100) {
        Task {
            do {
                let postList = try await NetworkManager().callAPI(withRequest: TechieButlerRequest(page: page), model: [Post].self)
                DispatchQueue.main.async { [weak self] in
                    self?.error = nil
                    self?.posts = postList
                }
            } catch let error as NetworkError {
                processError(error: error)
            }
        }
    }
    
    func processError(error: NetworkError) {
        DispatchQueue.main.async { [weak self] in
            self?.error = error
        }
    }
}
