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
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: - Properties

    var viewModel: UserFollowersViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        bindViewModel()
        viewModel?.fetchData()
    }
    
    // MARK: - Setup Methods
    private func configureViews() {
        loadingSpinner.startAnimating()
        title = "Followers"
        collectionView.register(
            FollowersCollectionViewCell.nib(),
            forCellWithReuseIdentifier: FollowersCollectionViewCell.identifier
        )
    }
    
    private func bindViewModel() {
        viewModel?.onDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.configureLoadingSpinner(isLoading: false)
                self?.collectionView.reloadData()
            }
        }
        
        viewModel?.onShowError = { [weak self] error in
            DispatchQueue.main.async {
                self?.configureLoadingSpinner(isLoading: false)
                self?.showErrorMessage(message: error)
            }
        }
    }
    
    // MARK: - UI Updates
    
    private func configureLoadingSpinner(isLoading: Bool) {
        loadingSpinner.isHidden = !isLoading
        isLoading ? loadingSpinner.startAnimating() : loadingSpinner.stopAnimating()
    }
    
    // MARK: - Helper Methods
    
    private func showErrorMessage(message: String) {
        let popUp = PopUpViewController()
        popUp.appear(sender: self, msg: message)
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
            withReuseIdentifier: FollowersCollectionViewCell.identifier,
            for: indexPath
        ) as? FollowersCollectionViewCell
        
        if let follower = viewModel?.filteredFollowers[indexPath.item] {
            cell?.configureCell(follower: follower)
        }
        return cell ?? UICollectionViewCell()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if !(viewModel?.isLoading ?? true) {
                viewModel?.fetchNextPage()
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
            
            let shouldShowSpinner = viewModel?.shouldShowSpinner ?? false
            footerView?.spinner.isHidden = !shouldShowSpinner
            shouldShowSpinner ? footerView?.spinner.startAnimating() : footerView?.spinner.stopAnimating()
            return footerView ?? UICollectionReusableView()
            
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}

extension UserFollowersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchFollowers(name: searchText)
    }
}
