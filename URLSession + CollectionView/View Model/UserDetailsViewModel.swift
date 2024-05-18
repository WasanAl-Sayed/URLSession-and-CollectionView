//
//  UserDetailsViewModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 18/05/2024.
//

import UIKit

class UserDetailsViewModel {
    
    // MARK: - Properties
    var networkLayer = NetworkLayer()
    var user: GithubUserModel?
    var username: String?
    var image: UIImage?
    
    // MARK: - Initializer
    init(user: GithubUserModel, username: String, image: UIImage) {
        self.user = user
        self.username = username
        self.image = image
    }
    
    // MARK: - Methods
    func loadUserFollowersNumberLabel() -> NSMutableAttributedString {
        let followersText = NSMutableAttributedString(string: "\(user?.name.components(separatedBy: " ").first ?? " ") has ")
        let followersCount = NSAttributedString(
            string: "\(user?.followers ?? 0)",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        )
        followersText.append(followersCount)
        followersText.append(NSAttributedString(string: " followers"))
        return followersText
    }
}
