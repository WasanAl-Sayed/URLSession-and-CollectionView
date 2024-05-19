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
    private var networkLayer = NetworkLayer()
    
    // MARK: - Methods
    func getUser(username: String) {
        Task {
            do {
                let (user, image) = try await networkLayer.getUser(username: username)
                onDataFetched?(user, image)
            } catch let error as GithubError {
                onShowError?(error.localizedDescription)
            } catch {
                onShowError?(GithubError.invalidData.localizedDescription)
            }
        }
    }
}
