//
//  UserViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit

class UserViewModel {
    
    // MARK: - Data Binding Callbacks
    
    var onDataFetched: ((GithubUserModel, UIImage) -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private var client = Client()
    
    // MARK: - Methods
    
    func getUser(username: String) {
        Task {
            do {
                let (user, image) = try await client.getUser(username: username)
                onDataFetched?(user, image)
            } catch {
                if let error = error as? GithubError {
                    onShowError?(error.localizedDescription)
                } else {
                    onShowError?(GithubError.invalidData.localizedDescription)
                }
                
            }
        }
    }
}
