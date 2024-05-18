//
//  UserFollowersViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit
 
class UserFollowersViewModel {
    
    // MARK: - Properties
    private var networkLayer = NetworkLayer()
    private(set) var followers: [(GithubFollowerModel, UIImage)] = [] {
        didSet {
            onFollowersUpdated?()
        }
    }
    private(set) var filteredFollowers: [(GithubFollowerModel, UIImage)] = [] {
        didSet {
            onFilteredFollowersUpdated?()
        }
    }
    
    var username: String?
    
    // MARK: - Data Binding Callbacks
    var onFollowersUpdated: (() -> Void)?
    var onFilteredFollowersUpdated: (() -> Void)?
    var onError: ((GithubError) -> Void)?
    
    // MARK: - Initializer
    init(username: String) {
        self.username = username
    }
    
    // MARK: - Methods
    func getFollowers(
        username: String,
        page: Int
    ) {
        Task {
            do {
                let fetchedFollowers = try await networkLayer.getFollowers(username: username, page: page)
                self.followers += fetchedFollowers
                self.filteredFollowers += fetchedFollowers
            } catch {
                onError?(.invalidData)
            }
        }
    }
    
    func searchFollowers(name: String) {
        filteredFollowers.removeAll()
        filteredFollowers = name.isEmpty ? followers : followers.filter { $0.0.login.localizedCaseInsensitiveContains(name) }
    }
    
    func emptyFollowersArrays() {
        filteredFollowers.removeAll()
        followers.removeAll()
    }
}
