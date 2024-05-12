//
//  UserViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 25/04/2024.
//

import UIKit

class UserViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var submitButton: UIButton!
    
    private let viewModel = GithubViewModel()
    private var isButtonEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserNameTextField()
    }
    
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
        usernameTextField.backgroundColor = .clear
        usernameTextField.leftView = paddingView
        usernameTextField.leftViewMode = .always
    }
    
    private func configureUIElements(bool: Bool) {
        if bool {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
        usernameTextField.isUserInteractionEnabled = bool
        isButtonEnabled = bool
        submitButton.isEnabled = bool
    }
    
    private func usernameIsFull() {
        if isButtonEnabled {
            configureUIElements(bool: false)
            
            viewModel.getUser(username: usernameTextField.text ?? "") { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let (user, image)):
                    self.handleSuccess(user: user, image: image)
                case .failure(let error):
                    self.errorMessage(error: error)
                }
            }
        }
    }
    
    private func errorMessage(error: GithubError) {
        switch error {
        case .invalidURL:
            self.handleFailure(msg: "Invalid URL!")
        case .invalidData:
            self.handleFailure(msg: "Invalid Data!")
        case .invalidResponse:
            self.handleFailure(msg: "Invalid Response!")
        }
    }
    
    private func handleSuccess(user: GithubUserModel, image: UIImage) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "userVC") as? UserDetailsViewController
            viewController?.user = user
            viewController?.username = self.usernameTextField.text ?? ""
            viewController?.userImage = image
            self.spinner.stopAnimating()
            self.usernameTextField.isUserInteractionEnabled = true
            self.configureUIElements(bool: true)
            self.navigationController?.pushViewController(viewController ?? UserDetailsViewController(), animated: true)
        }
    }
    
    private func handleFailure(msg: String) {
        DispatchQueue.main.async {
            let popUp = PopUpViewController()
            popUp.appear(sender: self, msg: msg)
            self.configureUIElements(bool: true)
        }
    }
    
    @IBAction func didPressSubmitButton(_ sender: UIButton) {
        if let username = usernameTextField.text, !username.isEmpty {
            usernameIsFull()
        } else {
            handleFailure(msg: "Please enter username")
        }
    }
}
