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
    
    private lazy var stackView: LoginRegisterStackView = {
        let stackKind = LoginRegisterStackViewKind.register
        let buttonKinds = stackKind.buttonKinds
        var buttons = buttonKinds.map { CustomLoginRegisterButton(kind: $0) }
        let stackView = LoginRegisterStackView(kind: stackKind, buttons: buttons)
        return stackView
    }()
//    private let stackView = LoginRegisterStackView(kind: .register)
    
    private var isFirstTime = true
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        mainScrollView.addSubview(stackView)
        view.addSubview(mainScrollView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.frame = view.frame
        
        if isFirstTime {
            isFirstTime = false
            stackView.applyConstraints()
        }
    }
    
    // MARK: - Helper methods
    private func configureNavBar() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(closeButtonDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    // MARK: - Actions
    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
    
}
