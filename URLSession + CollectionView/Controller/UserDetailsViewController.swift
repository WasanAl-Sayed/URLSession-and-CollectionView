//
//  UserDetailsViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 25/04/2024.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersNumberLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel: UserDetailsViewModel?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    // MARK: - Setup Methods
    
    private func configureViews() {
        configureImageView()
        usernameLabel.text = viewModel?.user?.name
        bioLabel.text = viewModel?.user?.bio
        followersNumberLabel.attributedText = viewModel?.getFollowersLabelText()
    }
    
    private func configureImageView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.image = viewModel?.image
    }
    
    // MARK: - Actions
    
    @IBAction func didPressGetFollowers(_ sender: UIButton) {
        guard let userName = viewModel?.username else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "followersVC") as? UserFollowersViewController
        let userFollowersViewModel = UserFollowersViewModel(username: userName)
        viewController?.viewModel = userFollowersViewModel
        self.navigationController?.pushViewController(viewController ?? UserFollowersViewController(), animated: true)
    }
}
