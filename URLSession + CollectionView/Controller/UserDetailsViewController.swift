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
    
    var user: GithubUserModel?
    var username: String?
    let viewModel = GithubViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        configureImageView()
        loadUserImage()
        viewUserData()
    }
    
    @IBAction func didClickGetFollowers(_ sender: Any) {
        guard let username = username else { return }
        viewModel.getFollowers(username: username)
        viewModel.followersLoaded = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier: "followersVC") as! UserFollowersViewController
                    viewController.navigationItem.title = "Followers"
                    viewController.viewModel = self.viewModel 
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
            case .failure(let error):
                print("Error loading followers:", error)
            }
        }
    }
    
    func configureImageView() {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }
    
    func viewUserData() {
        usernameLabel.text = user?.name
        bioLabel.text = user?.bio
        loadUserFollowers()
    }
    
    func loadUserFollowers() {
        let followersText = NSMutableAttributedString(string: "\(user?.name.components(separatedBy: " ").first ?? " ") has ")
        let followersCount = NSAttributedString(
            string: "\(user?.followers ?? 0)",
            attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        )
        followersText.append(followersCount)
        followersText.append(NSAttributedString(string: " followers"))
        followersNumberLabel.attributedText = followersText
    }
    
    func loadUserImage() {
        guard let urlString = user?.avatarUrl, let url = URL(string: urlString) else {
            print("Invalid image URL")
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
