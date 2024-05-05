//
//  GithubViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

class GithubViewModel {
    
    var followers: [GithubFollowerModel]?
    var followersLoaded: ((Result<Void, GithubError>) -> Void)?
    
    func getUser(username: String, completion: @escaping (Result<GithubUserModel, GithubError>) -> Void) {
        let endpoint = "https://api.github.com/users/\(username)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(.failure(.invalidResponse))
                    return
                }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(GithubUserModel.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(.invalidData))
            }
        }
    }
    
    func getFollowers(username: String) {
        let endpoint = "https://api.github.com/users/\(username)/followers"
        guard let url = URL(string: endpoint) else {
            followersLoaded?(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                self.followersLoaded?(.failure(.invalidData))
                print("Error fetching followers:", error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.followersLoaded?(.failure(.invalidResponse))
                print("Invalid response")
                return
            }
            guard let data = data else {
                self.followersLoaded?(.failure(.invalidData))
                print("No data received")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([GithubFollowerModel].self, from: data)
                self.followers = followers
                self.followersLoaded?(.success(()))
            } catch {
                self.followersLoaded?(.failure(.invalidData))
                print("Error decoding followers:", error)
            }
        }.resume()
    }
}
