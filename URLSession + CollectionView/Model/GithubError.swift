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
            return NSLocalizedString("Invalid URL", comment: "The URL provided is invalid.")
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "The response from the server is invalid.")
        case .invalidData:
            return NSLocalizedString("Invalid Data", comment: "The data entered is invalid.")
        }
    }
}
