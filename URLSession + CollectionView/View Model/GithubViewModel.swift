//
//  GithubViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

class GithubViewModel {
    
    var followers: [(GithubFollowerModel, UIImage)] = []
    var filteredFollowers: [(GithubFollowerModel, UIImage)] = []
    
    private var networkLayer = NetworkLayer()
    
    func getUser(
        username: String,
        completion: @escaping (Result<(GithubUserModel, UIImage), GithubError>) -> Void
    ) {
        Task {
            do {
                let (user, image) = try await networkLayer.getUser(username: username)
                completion(.success((user, image)))
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    
    func getFollowers(
        username: String,
        page: Int,
        completion: @escaping (Result<Void, GithubError>) -> Void
    ) {
        Task {
            do {
                let fetchedFollowers = try await networkLayer.getFollowers(username: username, page: page)
                self.followers += fetchedFollowers
                self.filteredFollowers += fetchedFollowers
                completion(.success(()))
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    
    func searchFollowers(name: String) {
        filteredFollowers.removeAll()
        filteredFollowers = name.isEmpty ? followers : followers.filter { $0.0.login.localizedCaseInsensitiveContains(name) }
    }
}
