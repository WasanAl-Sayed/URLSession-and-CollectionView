//
//  NetworkLayer.swift
//  URLSession + CollectionView
//
//  Created by fts on 09/05/2024.
//

import UIKit

class NetworkLayer {
    
    private let baseURL = "https://api.github.com"
    
    private func loadImage(from url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw GithubError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw GithubError.invalidData
        }
        
        return image
    }
    
    func getUser(username: String) async throws -> (GithubUserModel, UIImage) {
        let endpoint = "\(baseURL)/users/\(username)"
        guard let url = URL(string: endpoint) else {
            throw GithubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(GithubUserModel.self, from: data)
        let image = try await loadImage(from: user.avatarUrl)
        
        return (user, image)
    }
    
    func getFollowers(username: String, page: Int) async throws -> [(GithubFollowerModel, UIImage)] {
        let endpoint = "\(baseURL)/users/\(username)/followers?page=\(page)"
        guard let url = URL(string: endpoint) else {
            throw GithubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let followers = try decoder.decode([GithubFollowerModel].self, from: data)
        
        var followersWithImages: [(GithubFollowerModel, UIImage)] = []
        for follower in followers {
            do {
                let image = try await loadImage(from: follower.avatarUrl)
                followersWithImages.append((follower, image))
            } catch {
                print("Error loading image for follower: \(follower.login)")
            }
        }
        
        return followersWithImages
    }
}
