//
//  GithubError.swift
//  URLSession + CollectionView
//
//  Created by fts on 02/05/2024.
//
import UIKit

enum GithubError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid Response"
        case .invalidData:
            return "Invalid Data"
        }
    }
}
