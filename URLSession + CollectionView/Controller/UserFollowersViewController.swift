//
//  UserFollowersViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 30/04/2024.
//

import UIKit

class UserFollowersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel = GithubViewModel()
    var page = 2
    var isLoading = false
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            CustomCollectionViewCell.nib(),
            forCellWithReuseIdentifier: CustomCollectionViewCell.identifier
        )
    }
    
    func loadMoreFollowers() {
        isLoading = true
        spinner.startAnimating()
        
        viewModel.getFollowers(username: username ?? "", page: page) { [weak self] newFollowers in
            self?.isLoading = false
            DispatchQueue.main.async {
                self?.spinner.stopAnimating()
                self?.collectionView.reloadData()
            }
        }
    }
}

extension UserFollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel.filteredFollowers.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as? CustomCollectionViewCell
        let follower = viewModel.filteredFollowers[indexPath.item]
        cell?.configureCell(follower: follower)
        return cell ?? CustomCollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading {
                page += 1
                loadMoreFollowers()
            }
        }
    }
}

extension UserFollowersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFollowers(name: searchText)
        collectionView.reloadData()
    }
}
