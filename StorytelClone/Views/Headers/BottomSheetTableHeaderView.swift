//
//  BottomSheetTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 19/4/23.
//

import UIKit

class BottomSheetTableHeaderView: UIView {
    // MARK: - Instance properties
    private let titleText: String
    private let needsSeparatorView: Bool
    
    private let titleLabel = UILabel.createLabelWith(font: UIFont.customNavBarTitle)
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        let symbolConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "xmark")?.withConfiguration(symbolConfig)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: .normal)
        return button
    }()
    
    var closeButtonDidTapCallback: () -> () = {}
    
    // MARK: - Initializers
    init(titleText: String, needsSeparatorView: Bool) {
        self.titleText = titleText
        self.needsSeparatorView = needsSeparatorView
        super.init(frame: .zero)
        configureSelf()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        setupUI()
        addButtonAction()
    }
    
    private func setupUI() {
        titleLabel.text = titleText
        addSubview(titleLabel)
        addSubview(closeButton)
        if needsSeparatorView {
            addSeparatorView()
        }
        applyConstraints()
    }
    
    private func addSeparatorView() {
        let view = UIView()
        view.backgroundColor = UIColor.quaternaryLabel        
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 1),
            view.widthAnchor.constraint(equalTo: widthAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func addButtonAction() {
        closeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.closeButtonDidTapCallback()
        }), for: .touchUpInside)
    }
    
    private func applyConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.leadingAnchor.constraint(
                greaterThanOrEqualTo: leadingAnchor,
                constant: Constants.commonHorzPadding),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: closeButton.leadingAnchor,
                constant: -Constants.commonHorzPadding)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Constants.commonHorzPadding)
        ])
    }
}
