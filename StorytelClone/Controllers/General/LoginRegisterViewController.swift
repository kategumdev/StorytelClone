//
//  LoginRegisterViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 19/7/23.
//

import UIKit

class LoginRegisterViewController: UIViewController {
    // MARK: - Instance properties
    private let tappedButtonKind: LoginRegisterButtonKind
    private var tableViewInitialOffsetY: Double = 0
    private var isInitialOffsetYSet = false
        
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
    
    private let textFieldPadding: CGFloat = 10
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .emailAddress
        commonConfigure(textField: textField)
        textField.placeholder = "Type your e-mail address"
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .default
        commonConfigure(textField: textField)
        
        textField.rightView = showHidePasswordButton
        textField.rightViewMode = .always
        
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var showHidePasswordButton: UIButton = {
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        let button = UIButton(frame: rect)
        button.tintColor = UIColor.systemGray
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: textFieldPadding,
            leading: textFieldPadding,
            bottom: textFieldPadding,
            trailing: textFieldPadding)
        button.configuration = config
        
        button.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.background.backgroundColor = .customTintColor
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 13,
            leading: 0,
            bottom: 13,
            trailing: 0)
        button.configuration = config
        return button
    }()
    
    private var isFirstTime = true
    
    // MARK: - Initializers
    init(clickedButtonKind: LoginRegisterButtonKind) {
        self.tappedButtonKind = clickedButtonKind
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.adjustAppearanceTo(
            currentOffsetY: mainScrollView.contentOffset.y,
            offsetYToCompareTo: tableViewInitialOffsetY,
            withVisibleTitleWhenTransparent: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainScrollView.frame = view.frame
        
        if isFirstTime {
            isFirstTime = false
            setStackSpacings()
            applyConstraints()
        }
    }
}

// MARK: - Helper methods
extension LoginRegisterViewController {
    private func setupUI() {
        view.backgroundColor = UIColor.customBackgroundColor
        
        mainScrollView.delegate = self
        mainScrollView.addSubview(vertStack)
        view.addSubview(mainScrollView)
        
        vertStack.addArrangedSubview(titleLabel)
        
        if tappedButtonKind == .emailRegister {
            setupUIForRegister()
        }
        
        if tappedButtonKind == .emailLogin {
            setupUIForLogin()
        }
        
        configureSubmitButton()
        view.addSubview(submitButton)
        
        setupNotificationObservers()
    }
    
    private func setupUIForRegister() {
        let titleText = "Create Account with E-mail"
        titleLabel.text = titleText
        
        let subtitleText = "Make sure to check your spelling so that you can " +
        "get important information about your account."
        subtitleLabel.text = subtitleText
        vertStack.addArrangedSubview(subtitleLabel)
        
        passwordTextField.placeholder = "Choose your password"
        toggleShowHidePasswordButtonImage()
        [emailTextField, passwordTextField].forEach { vertStack.addArrangedSubview($0) }
    }
    
    private func setupUIForLogin() {
        let titleText = "Log in with E-mail"
        titleLabel.text = titleText
        
        passwordTextField.placeholder = "Enter your password"
        toggleShowHidePasswordButtonImage()
        [emailTextField, passwordTextField].forEach { vertStack.addArrangedSubview($0) }
    }
    
    private func commonConfigure(textField: UITextField) {
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 4
        textField.layer.borderColor = UIColor.systemGray.cgColor
        textField.layer.borderWidth = 1.0
        
        let rect = CGRect(x: 0, y: 0, width: textFieldPadding, height: textField.frame.height)
        let paddingView = UIView(frame: rect)
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
    
    private func configureSubmitButton() {
        let text = tappedButtonKind == .emailRegister ? "Continue" : "Log in"
        submitButton.configuration?.attributedTitle = AttributedString(text)
        let scaledFont = UIFont.customCalloutSemibold
        submitButton.configuration?.attributedTitle?.font = scaledFont
        submitButton.configuration?.attributedTitle?.foregroundColor = UIColor.customBackgroundLight
    }
        
    @objc func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        toggleShowHidePasswordButtonImage()
    }
    
    private func toggleShowHidePasswordButtonImage() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        let image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        showHidePasswordButton.configuration?.image = image
    }
    
    private func setupNotificationObservers() {
        let textFields = [emailTextField, passwordTextField]
        for textField in textFields {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(textFieldBecameFirstResponder(_:)),
                name: UITextField.textDidBeginEditingNotification,
                object: textField)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(textFieldResignedFirstResponder(_:)),
                name: UITextField.textDidEndEditingNotification,
                object: textField)
        }
    }
    
    @objc func textFieldBecameFirstResponder(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            textField.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    @objc func textFieldResignedFirstResponder(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            textField.layer.borderColor = UIColor.systemGray.cgColor
        }
    }
    
    private func setStackSpacings() {
        if tappedButtonKind == .emailRegister {
            vertStack.setCustomSpacing(20, after: titleLabel)
            vertStack.setCustomSpacing(25, after: subtitleLabel)
        }
        
        if tappedButtonKind == .emailLogin {
            vertStack.setCustomSpacing(25, after: titleLabel)
        }
        
        vertStack.setCustomSpacing(25, after: emailTextField)
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
        
        let textFields = [emailTextField, passwordTextField]
        for textField in textFields {
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.heightAnchor.constraint(equalToConstant: 45),
                textField.widthAnchor.constraint(equalTo: vertStack.widthAnchor),
            ])
        }
        
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            submitButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.commonHorzPadding),
            submitButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.commonHorzPadding)
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension LoginRegisterViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        guard isInitialOffsetYSet else {
            tableViewInitialOffsetY = scrollView.contentOffset.y
            isInitialOffsetYSet = true
            return
        }
        
        // Toggle navbar from transparent to visible depending on current contentOffset.y
        navigationController?.adjustAppearanceTo(
            currentOffsetY: currentOffsetY,
            offsetYToCompareTo: tableViewInitialOffsetY,
            withVisibleTitleWhenTransparent: true)
    }
}
