//
//  UserFollowersViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 30/04/2024.
//

import UIKit

class UserFollowersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = GithubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CustomCollectionViewCell.nib(), forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
    }
}

extension UserFollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.followers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCollectionViewCell.identifier,
            for: indexPath
        ) as? CustomCollectionViewCell
        if let follower = viewModel.followers?[indexPath.item] {
            cell?.configureCell(follower: follower)
        }
        return cell ?? CustomCollectionViewCell()
    }
}
