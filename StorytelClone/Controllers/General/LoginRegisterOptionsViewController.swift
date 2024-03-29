//
//  LoginRegisterOptionsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/6/23.
//

import UIKit

class LoginRegisterOptionsViewController: UIViewController {
    // MARK: - Instance properties
    private let stackViewKind: LoginRegisterStackViewKind
    private let mainScrollView = UIScrollView()
    
    private lazy var stackView: LoginRegisterOptionsStack = {
        let buttonKinds = stackViewKind.buttonKinds
        var buttons = buttonKinds.map { CustomLoginRegisterButton(kind: $0) }
        let stackView = LoginRegisterOptionsStack(kind: stackViewKind, buttons: buttons)
        return stackView
    }()
    
    private var isFirstTime = true
    
    // MARK: - Initializers
    init(stackViewKind: LoginRegisterStackViewKind) {
        self.stackViewKind = stackViewKind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
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
    private func configureSelf() {
        view.backgroundColor = UIColor.customBackgroundColor
        configureNavBar()
        mainScrollView.addSubview(stackView)
        
        stackView.buttonDidTapCallback = { [weak self] buttonKind in
            let vc = LoginRegisterViewController(clickedButtonKind: buttonKind)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        view.addSubview(mainScrollView)
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.tintColor = .label
        
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        backButton.setTitleTextAttributes([.font: UIFont.customNavBarTitle], for: .normal)
        navigationItem.backBarButtonItem = backButton
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold)
        let image = UIImage(systemName: "xmark", withConfiguration: symbolConfig)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .done,
            target: self,
            action: #selector(closeButtonDidTap))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc private func closeButtonDidTap() {
        self.dismiss(animated: true)
    }
}
