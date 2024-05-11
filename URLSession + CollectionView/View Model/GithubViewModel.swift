//
//  GithubViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

class GithubViewModel {
    
    private(set) var followers: [GithubFollowerModel] = []
    private(set) var filteredFollowers: [GithubFollowerModel] = []
    
    private var networkLayer = NetworkLayer()
    
    func getUser(
        username: String,
        completion: @escaping (Result<GithubUserModel, GithubError>) -> Void
    ) {
        Task {
            do {
                let user = try await networkLayer.getUser(username: username)
                completion(.success(user))
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
        
        if name.isEmpty {
            filteredFollowers = followers
        } else {
            filteredFollowers = followers.filter { $0.login.localizedCaseInsensitiveContains(name) }
        }
    }
    
    func loadImage(
        from url: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        Task {
            do {
                let image = try await networkLayer.loadImage(from: url)
                completion(image)
            } catch {
                completion(nil)
            }
        }
    }
}
