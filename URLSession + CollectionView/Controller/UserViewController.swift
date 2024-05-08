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
    
    let viewModel = GithubViewModel()
    var isButtonEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUserNameTextField()
    }

    func configureUserNameTextField() {
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
    
    private func usernameIsFull() {
        if isButtonEnabled {
            spinner.startAnimating()
            isButtonEnabled = false
            submitButton.isEnabled = false
            let animationDuration: TimeInterval = 2.5
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) { [weak self] in
                guard let self = self else { return }
                
                self.viewModel.getUser(username: self.usernameTextField.text ?? "") { result in
                    switch result {
                    case .success(let user):
                        self.handleSuccess(user: user)
                    case .failure(let error):
                        self.errorMessage(error: error)
                    }
                }
            }
        }
    }
    
    private func configureSubmitButton(isEnabled: Bool) {
        isButtonEnabled = isEnabled
        submitButton.isEnabled = isEnabled
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
    
    private func handleSuccess(user: GithubUserModel) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "userVC") as? UserDetailsViewController
            viewController?.user = user
            viewController?.username = self.usernameTextField.text ?? ""
            self.navigationController?.pushViewController(viewController ?? UserDetailsViewController(), animated: true)
        }
    }
    
    private func handleFailure(msg: String) {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
            let popUp = PopUpViewController()
            popUp.appear(sender: self, msg: msg)
            self.configureSubmitButton(isEnabled: true)
        }
    }
    
    @IBAction func didClickSubmitButton(_ sender: UIButton) {
        if let username = usernameTextField.text, !username.isEmpty {
            usernameIsFull()
        } else {
            handleFailure(msg: "Please enter username")
        }
    }
}
