//
//  UserViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 25/04/2024.
//

import UIKit

class UserViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var spinnerView: UIView!
    
    // MARK: - Properties
    
    private let viewModel = UserViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserNameTextField()
        bindViewMode()
    }
    
    // MARK: - Setup Methods
    
    private func configureUserNameTextField() {
        let borderColor: UIColor = UIColor(named: "borderColor") ?? UIColor.black
        usernameTextField.layer.borderColor = borderColor.cgColor
        usernameTextField.layer.borderWidth = 0.7
        usernameTextField.layer.cornerRadius = 25
        let paddingView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 20,
                height: usernameTextField.frame.height
            )
        )
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
    }
    
    private func bindViewMode() {
        viewModel.onDataFetched = { [weak self] user, image in
            self?.handleUserFetchSuccess(user: user, image: image)
        }
        viewModel.onShowError = { [weak self] errorMessage in
            self?.handleUserFetchFailure(errorMessage: errorMessage)
        }
    }
    
    // MARK: - UI Updates
    
    private func configureSpinner(isEnabled: Bool) {
        spinnerView.isHidden = !isEnabled
        isEnabled ? spinner.startAnimating() : spinner.stopAnimating()
    }
    
    // MARK: - Helper Methods
    
    private func fetchUser() {
        configureSpinner(isEnabled: true)
        viewModel.getUser(username: usernameTextField.text ?? "")
    }

    private func handleUserFetchSuccess(user: GithubUserModel, image: UIImage) {
        DispatchQueue.main.async {
            self.navigateToUserDetails(user: user, image: image)
            self.configureSpinner(isEnabled: false)
        }
    }
    
    private func handleUserFetchFailure(errorMessage: String) {
        DispatchQueue.main.async {
            self.showErrorMessage(message: errorMessage)
            self.configureSpinner(isEnabled: false)
        }
    }
    
    private func navigateToUserDetails(user: GithubUserModel, image: UIImage) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let userDetailsVC = storyboard.instantiateViewController(withIdentifier: "userVC") as? UserDetailsViewController {
            let userDetailsViewModel = UserDetailsViewModel(
                user: user,
                username: usernameTextField.text ?? "",
                image: image
            )
            userDetailsVC.viewModel = userDetailsViewModel
            navigationController?.pushViewController(userDetailsVC, animated: true)
        }
    }
    
    private func showErrorMessage(message: String) {
        let popUp = PopUpViewController()
        popUp.appear(sender: self, msg: message)
    }
    
    // MARK: - Actions
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            handleUserFetchFailure(errorMessage: "Please enter username")
            return
        }
        fetchUser()
    }
}
