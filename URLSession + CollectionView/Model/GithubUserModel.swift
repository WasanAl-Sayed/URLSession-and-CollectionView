//
//  GithubUserModel.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//

import UIKit

struct GithubUserModel: Codable {
    let name: String
    let avatarUrl: String
    let bio: String
    let followers: Int
}
