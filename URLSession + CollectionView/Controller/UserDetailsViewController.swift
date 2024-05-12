//
//  UserDetailsViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 25/04/2024.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    private let viewModel = GithubViewModel()
    
    var user: GithubUserModel?
    var username: String?
    var userImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        viewUserData()
        viewUserImage()
    }
    
    private func configureImageView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    private func viewUserData() {
        usernameLabel.text = user?.name
        bioLabel.text = user?.bio
        loadUserFollowersNumberLabel()
    }
    
    private func viewUserImage() {
        DispatchQueue.main.async {
            self.imageView.image = self.userImage
        }
    }
    
    private func loadUserFollowersNumberLabel() {
        let followersText = NSMutableAttributedString(string: "\(user?.name.components(separatedBy: " ").first ?? " ") has ")
        let followersCount = NSAttributedString(
            string: "\(user?.followers ?? 0)",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        )
        followersText.append(followersCount)
        followersText.append(NSAttributedString(string: " followers"))
        followersNumberLabel.attributedText = followersText
    }
    
    @IBAction func didPressGetFollowers(_ sender: UIButton) {
        guard let username = username else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "followersVC") as? UserFollowersViewController
        viewController?.navigationItem.title = "Followers"
        viewController?.viewModel = self.viewModel
        viewController?.username = username
        self.navigationController?.pushViewController(viewController ?? UserFollowersViewController(), animated: true)
    }
}
