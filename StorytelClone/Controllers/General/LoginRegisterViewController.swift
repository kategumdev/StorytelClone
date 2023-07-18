//
//  LoginRegisterViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 19/7/23.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    private let clickedButtonKind: LoginRegisterButtonKind
    
    private let mainScrollView = UIScrollView()
    
    private let vertStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .title2,
            weight: .semibold,
            basePointSize: 22,
            maxPointSize: 50)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .body,
            weight: .regular,
            maxPointSize: 39)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 0)
        label.textAlignment = .center
        return label
    }()
    
    private var isFirstTime = true
    
    // MARK: - Initializers
    init(clickedButtonKind: LoginRegisterButtonKind) {
        self.clickedButtonKind = clickedButtonKind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.frame = view.frame
        
        if isFirstTime {
            isFirstTime = false
            applyConstraints()
        }
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        view.backgroundColor = UIColor.customBackgroundColor
        mainScrollView.addSubview(vertStack)
        view.addSubview(mainScrollView)
        
        vertStack.addArrangedSubview(titleLabel)
        
        if clickedButtonKind == .emailLogin {
            setupUIForLogin()
        }
        
        if clickedButtonKind == .emailRegister {
            setupUIForRegister()
        }
    }
    
    private func setupUIForLogin() {
        let titleText = "Log in with E-mail"
        titleLabel.text = titleText
        
    }
    
    private func setupUIForRegister() {
        let titleText = "Create Account with E-mail"
        titleLabel.text = titleText
        
        let subtitleText = "Make sure to check your spelling so that you can " +
        "get important information about your account."
        subtitleLabel.text = subtitleText
        vertStack.addArrangedSubview(subtitleLabel)
    }
    
    private func applyConstraints() {
        vertStack.translatesAutoresizingMaskIntoConstraints = false
        let contentG = mainScrollView.contentLayoutGuide
        let frameG = mainScrollView.frameLayoutGuide
        
        let padding: CGFloat = Constants.commonHorzPadding
        NSLayoutConstraint.activate([
            vertStack.topAnchor.constraint(equalTo: contentG.topAnchor),
            vertStack.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: padding),
            vertStack.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -padding),
            vertStack.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
            vertStack.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: -padding * 2)
        ])
    }
}
