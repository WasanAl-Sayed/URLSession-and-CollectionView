//
//  NetworkLayer.swift
//  URLSession + CollectionView
//
//  Created by fts on 09/05/2024.
//

import UIKit

class NetworkLayer {
    
    func getUser(username: String) async throws -> GithubUserModel {
        let endpoint = "https://api.github.com/users/\(username)"
        guard let url = URL(string: endpoint) else {
            throw GithubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GithubUserModel.self, from: data)
    }
    
    func getFollowers(username: String, page: Int) async throws -> [GithubFollowerModel] {
        let endpoint = "https://api.github.com/users/\(username)/followers?page=\(page)"
        guard let url = URL(string: endpoint) else {
            throw GithubError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GithubError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([GithubFollowerModel].self, from: data)
    }
    
    func loadImage(from url: String) async throws -> UIImage {
        guard let url = URL(string: url) else {
            throw GithubError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw GithubError.invalidData
        }
        
        return image
    }
}
