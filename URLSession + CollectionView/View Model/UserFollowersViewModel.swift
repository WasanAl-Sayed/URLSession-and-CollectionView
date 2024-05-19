//
//  UserFollowersViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit
 
class UserFollowersViewModel {
    
    // MARK: - Data Binding Callbacks
    var onFollowersUpdated: (() -> Void)?
    var onFilteredFollowersUpdated: (() -> Void)?
    var onError: (() -> Void)?
    
    // MARK: - Properties
    private var networkLayer = NetworkLayer()
    private var followers: [(follower: GithubFollowerModel, image: UIImage)] = [] {
        didSet {
            onFollowersUpdated?()
        }
    }
    private(set) var filteredFollowers: [(follower: GithubFollowerModel, image: UIImage)] = [] {
        didSet {
            onFilteredFollowersUpdated?()
        }
    }
    
    private(set) var username: String?
    
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
                onError?()
            }
        }
    }
    
    func searchFollowers(name: String) {
        filteredFollowers.removeAll()
        filteredFollowers = name.isEmpty ? followers : followers.filter { $0.follower.login.localizedCaseInsensitiveContains(name) }
    }
}
