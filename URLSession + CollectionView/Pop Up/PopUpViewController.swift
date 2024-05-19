//
//  PopUpViewController.swift
//  URLSession + CollectionView
//
//  Created by fts on 04/05/2024.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentView()
        configureBackgroundView()
    }
    
    init() {
        super.init(nibName: "PopUpViewController", bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureContentView() {
        contentView.layer.cornerRadius = 30
        contentView.clipsToBounds = true
        contentView.alpha = 0
    }
    
    private func configureBackgroundView() {
        view.backgroundColor = .clear
        backgroundView.backgroundColor = .black.withAlphaComponent(0.6)
        backgroundView.alpha = 0
    }
    
    private func show(msg: String) {
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.backgroundView.alpha = 1
            self.contentView.alpha = 1
        }
        errorLabel.text = msg
    }
    
    private func hide() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut) {
            self.backgroundView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
            self.removeFromParent()
        }
    }
    
    func appear(sender: UIViewController, msg: String) {
        sender.present(self, animated: false) {
            self.show(msg: msg)
        }
    }
    
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        hide()
    }
}
