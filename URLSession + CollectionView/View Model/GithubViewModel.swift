//
//  GithubViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

class GithubViewModel {
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
}
