//
//  CustomCollectionViewCell.swift
//  URLSession + CollectionView
//
//  Created by fts on 05/05/2024.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    static let identifier = "CustomCollectionViewCell"
    let viewModel = GithubViewModel()

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomCollectionViewCell", bundle: nil)
    }
    
    func configureCell(follower: GithubFollowerModel) {
        usernameLabel.text = follower.login.components(separatedBy: " ").first
        viewModel.loadImage(from: follower.avatarUrl) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
}
