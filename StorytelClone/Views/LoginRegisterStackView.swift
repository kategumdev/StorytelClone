//
//  LoginRegisterStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 28/6/23.
//

import UIKit

enum LoginRegisterStackViewKind {
    case login
    case register
    
    var buttonKinds: [LoginRegisterButtonKind] {
        switch self {
        case .login: return [LoginRegisterButtonKind.appleLogin, LoginRegisterButtonKind.emailLogin]
        case .register: return [LoginRegisterButtonKind.appleRegister, LoginRegisterButtonKind.emailRegister]
        }
    }
    
    var titleLabelText: String {
        switch self {
        case .login: return "Log in "
        case .register: return "Create Account"
        }
    }
    
}

class LoginRegisterStackView: UIStackView {
    
    // MARK: - Instance properties
    private let kind: LoginRegisterStackViewKind
    private let buttons: [LoginRegisterButton]
    
    private lazy var titleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .title2, weight: .semibold, basePointSize: 22, maxPointSize: 50)
        let label = UILabel.createLabelWith(font: scaledFont, text: kind.titleLabelText)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private var firstTime = true
    
    // MARK: - Initializers
    init(kind: LoginRegisterStackViewKind, buttons: [LoginRegisterButton]) {
        self.kind = kind
        self.buttons = buttons
        super.init(frame: .zero)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()

        if firstTime {
            firstTime = false
            // Setting spacing here avoids constraints' conflict
            spacing = 9
            setCustomSpacing(38, after: titleLabel)
        }
    }

    // MARK: - Instance methods
    func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview as? UIScrollView else { return }
        
        let contentG = superview.contentLayoutGuide
        let frameG = superview.frameLayoutGuide
        
        let padding: CGFloat = Constants.commonHorzPadding
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: contentG.topAnchor),
            leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: padding),
            trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -padding),
            bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
            widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: -padding * 2)
        ])
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        axis = .vertical
        alignment = .center
        addArrangedSubview(titleLabel)
        buttons.forEach { addArrangedSubview($0) }
    }
    
}
