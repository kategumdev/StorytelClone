//
//  RegisterViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/6/23.
//

import UIKit

class RegisterViewController: UIViewController {
    
    // MARK: - Instance properties
    private let mainScrollView = UIScrollView()
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        view.addSubview(mainScrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.frame = view.frame
    }
    
    
    // MARK: - Helper methods
    private func configureNavBar() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(closeButtonDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
}
