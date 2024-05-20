//
//  FollowersCollectionViewCell.swift
//  URLSession + CollectionView
//
//  Created by fts on 05/05/2024.
//

import UIKit

class FollowersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let identifier = "FollowersCollectionViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FollowersCollectionViewCell", bundle: nil)
    }
    
    func configureCell(follower: FollowersCellUIModel) {
        usernameLabel.text = follower.name
        imageView.image = follower.image
    }
}
