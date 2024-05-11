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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let viewModel = GithubViewModel()
    var user: GithubUserModel?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        loadUserImage()
        viewUserData()
    }
    
    private func configureImageView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    private func loadUserImage() {
        guard let urlString = user?.avatarUrl else {
            print("Invalid image URL")
            return
        }
        
        viewModel.loadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }
    }
    
    private func viewUserData() {
        usernameLabel.text = user?.name
        bioLabel.text = user?.bio
        loadUserFollowersNumberLabel()
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
        spinner.startAnimating()
        guard let username = username else { return }
        
        viewModel.getFollowers(username: username, page: 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "followersVC") as? UserFollowersViewController
                    viewController?.navigationItem.title = "Followers"
                    viewController?.viewModel = self.viewModel
                    viewController?.username = self.username
                    self.navigationController?.pushViewController(viewController ?? UserFollowersViewController(), animated: true)
                }
            case .failure(let error):
                print("Error loading followers:", error)
            }
        }
    }
}
