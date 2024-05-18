//
//  UserViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit

class UserViewModel {
    
    // MARK: - Properties
    private var networkLayer = NetworkLayer()
    
    var onSuccess: ((GithubUserModel, UIImage) -> Void)?
    var onFailure: ((GithubError) -> Void)?
    
    // MARK: - Methods
    func getUser(username: String) {
        Task {
            do {
                let (user, image) = try await networkLayer.getUser(username: username)
                onSuccess?(user, image)
            } catch {
                onFailure?(.invalidData)
            }
        }
    }
    
    func errorMessage(error: GithubError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL!"
        case .invalidData:
            return "Invalid Data!"
        case .invalidResponse:
            return "Invalid Response!"
        }
    }
}
