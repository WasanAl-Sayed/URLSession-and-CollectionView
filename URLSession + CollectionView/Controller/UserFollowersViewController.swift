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
    @IBOutlet weak var spinnerView: UIView!
    
    private var page = 1
    private var isLoading = false
    
    var viewModel = GithubViewModel()
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            CustomCollectionViewCell.nib(),
            forCellWithReuseIdentifier: CustomCollectionViewCell.identifier
        )
        emptyViewModelArrays()
        loadFollowers()
    }
    
    private func emptyViewModelArrays() {
        viewModel.filteredFollowers.removeAll()
        viewModel.followers.removeAll()
    }
    
    private func loadFollowers() {
        isLoading = true
        spinnerView.isHidden = false
        spinner.startAnimating()
        
        viewModel.getFollowers(username: username ?? "", page: page) { [weak self] newFollowers in
            self?.isLoading = false
            DispatchQueue.main.async {
                self?.spinnerView.isHidden = true
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
        cell?.configureCell(follower: follower.0, image: follower.1)
        return cell ?? CustomCollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !isLoading {
                page += 1
                loadFollowers()
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
