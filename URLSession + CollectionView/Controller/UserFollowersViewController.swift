//
//  UserFollowersViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 30/04/2024.
//

import UIKit

class UserFollowersViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var page = 1
    private var isLoading = false
    
    var viewModel: UserFollowersViewModel?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        collectionView.register(
            CustomCollectionViewCell.nib(),
            forCellWithReuseIdentifier: CustomCollectionViewCell.identifier
        )
        loadFollowers()
    }
    
    // MARK: - Setup Methods
    private func setupBindings() {
        viewModel?.onFollowersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.configureLoadingSpinner(status: true)
                self?.collectionView.reloadData()
                self?.isLoading = false
            }
        }
            
        viewModel?.onFilteredFollowersUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
            
        viewModel?.onError = { [weak self] in
            DispatchQueue.main.async {
                self?.configureLoadingSpinner(status: true)
                self?.isLoading = false
            }
        }
    }
    
    private func loadFollowers() {
        guard let username = viewModel?.username, !isLoading else { return }
        isLoading = true
        if page == 1 {
            configureLoadingSpinner(status: false)
        } else {
            collectionView.reloadSections(IndexSet(integer: 0))
        }
        viewModel?.getFollowers(username: username, page: page)
    }
    
    // MARK: - UI Updates
    private func configureLoadingSpinner(status: Bool) {
        loadingSpinner.isHidden = status
        status ? loadingSpinner.stopAnimating() : loadingSpinner.startAnimating()
    }
}

extension UserFollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return viewModel?.filteredFollowers.count ?? 0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as? CustomCollectionViewCell
        if let follower = viewModel?.filteredFollowers[indexPath.item] {
            cell?.configureCell(
                username: follower.follower.login.components(separatedBy: " ").first ?? "",
                image: follower.image
            )
        }
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
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "footer",
                for: indexPath
            ) as? FooterReusableView
            
            isLoading && page != 1 ? footerView?.spinner.startAnimating() : footerView?.spinner.stopAnimating()
            footerView?.spinner.isHidden = !(isLoading && page != 1)
            return footerView ?? UICollectionReusableView()
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

extension UserFollowersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchFollowers(name: searchText)
        collectionView.reloadData()
    }
}
