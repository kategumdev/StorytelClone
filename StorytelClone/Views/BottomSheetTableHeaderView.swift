//
//  BottomSheetTableHeaderView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 19/4/23.
//

import UIKit

class BottomSheetTableHeaderView: UIView {

    // MARK: - Instance properties
    private let titleLabel = UILabel.createLabel(withFont: Utils.navBarTitleFont, maximumPointSize: 18)
    
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
    
//    lazy var separatorView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(cgColor: BookViewController.lightBordersColor)
//
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        addSubview(view)
//        NSLayoutConstraint.activate([
//            view.heightAnchor.constraint(equalToConstant: BookViewController.lightBordersWidth),
//            view.widthAnchor.constraint(equalTo: widthAnchor),
//            view.leadingAnchor.constraint(equalTo: leadingAnchor),
//            view.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//        return view
//    }()
    
    // MARK: - Initializers
    init(titleText: String) {
        super.init(frame: .zero)
//        backgroundColor = .green
        titleLabel.text = titleText
        addSubview(titleLabel)
        addSubview(closeButton)
        addButtonAction()
        
        addSeparatorView()
                
        applyConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    private func addSeparatorView() {
        let view = UIView()
        view.backgroundColor = UIColor.quaternaryLabel
//        view.backgroundColor = UIColor(cgColor: BookViewController.lightBordersColor)
        
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
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: Constants.cvPadding),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -Constants.cvPadding)
        ])
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cvPadding)
        ])
    }

}
