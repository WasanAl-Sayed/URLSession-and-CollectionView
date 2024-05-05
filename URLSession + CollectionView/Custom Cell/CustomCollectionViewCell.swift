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
        loadFollowerImage(follower: follower)
    }
    
    func loadFollowerImage(follower: GithubFollowerModel) {
        let urlString = follower.avatarUrl
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching image:", error)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            } else {
                print("Invalid image data")
            }
        }
        task.resume()
    }
}
