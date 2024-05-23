//
//  UserFollowersViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit
 
class UserFollowersViewModel {
    
    // MARK: - Data Binding Callbacks
    
    var onDataFetched: (() -> Void)?
    var onShowError: ((String) -> Void)?
    
    // MARK: - Properties
    
    private var client = Client()
    private var followers: [FollowersCellUIModel] = []
    private(set) var filteredFollowers: [FollowersCellUIModel] = []
    private(set) var username: String
    private var page = 1
    private(set) var isLoading = false
    var shouldShowSpinner: Bool {
        return isLoading && !filteredFollowers.isEmpty
    }
    
    // MARK: - Initializer
    
    init(username: String) {
        self.username = username
    }
    
    // MARK: - Methods
    
    func fetchData(page: Int = 1) {
        guard !isLoading else { return }
        self.page = page
        isLoading = true
        
        Task {
            do {
                let fetchedFollowers = try await client.getFollowers(username: username, page: page)
                self.followers += fetchedFollowers
                self.filteredFollowers = self.followers
                self.isLoading = false
                self.onDataFetched?()
            } catch {
                self.isLoading = false
                if let error = error as? GithubError {
                    onShowError?(error.localizedDescription)
                } else {
                    onShowError?(GithubError.invalidData.localizedDescription)
                }
            }
        }
    }
    
    func fetchNextPage() {
        guard !isLoading else { return }
        fetchData(page: page + 1)
    }
    
    func searchFollowers(name: String) {
        filteredFollowers = if name.isEmpty {
            followers
        } else {
            followers.filter { $0.name.localizedCaseInsensitiveContains(name) }
        }
        onDataFetched?()
    }
}
