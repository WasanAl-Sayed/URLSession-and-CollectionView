//
//  GithubViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

class GithubViewModel {
    
    private(set) var followers: [GithubFollowerModel]?
    private(set) var filteredFollowers: [GithubFollowerModel]?
    var followersLoaded: ((Result<Void, GithubError>) -> Void)?
    
    func getUser(
        username: String,
        completion: @escaping (
            Result<GithubUserModel, GithubError>
        ) -> Void
    ) {
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
            
            if let error  {
                self.followersLoaded?(.failure(.invalidData))
                print("Error fetching followers:", error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                self.followersLoaded?(.failure(.invalidResponse))
                print("Invalid response")
                return
            }
            
            guard let data else {
                self.followersLoaded?(.failure(.invalidData))
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([GithubFollowerModel].self, from: data)
                self.followers = followers
                self.filteredFollowers = followers
                self.followersLoaded?(.success(()))
            } catch {
                self.followersLoaded?(.failure(.invalidData))
                print("Error decoding followers:", error)
            }
        }.resume()
    }
    
    func searchFollowers(name: String) {
        filteredFollowers?.removeAll()
        
        if name.isEmpty {
            filteredFollowers = followers
        } else {
            filteredFollowers = followers?.filter { $0.login.localizedCaseInsensitiveContains(name) }
        }
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil)
            return
        }
            
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
