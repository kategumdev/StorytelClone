//
//  NoDataBackgroundView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/5/23.
//

import UIKit

enum NoDataBackgroundViewKind: Equatable {
    case forBookshelfVc(scopeButtonKind: ScopeButtonKind)
    case networkingError(error: NetworkManagerError)
}

class NoDataBackgroundView: UIView {
    // MARK: - Instance properties
    private let kind: NoDataBackgroundViewKind
    private let roundViewHeight: CGFloat = UIScreen.main.bounds.width / 4
    
    private lazy var vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        [horzStackView, titleLabel, subtitleLabel].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(26, after: horzStackView)
        stack.setCustomSpacing(15, after: titleLabel)
        return stack
    }()
        
    private let titleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .title3,
            weight: .semibold,
            maxPointSize: 38)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 3)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(
            textStyle: .callout,
            weight: .regular,
            maxPointSize: 30)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 2)
        label.text = "Once you do, you will find them here."
        label.textAlignment = .center
        return label
    }()
    
    private lazy var horzStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        [UIView(), roundViewWithImage, UIView()].forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
    private lazy var roundViewWithImage: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "noBooksScopeRoundBackground")
        view.layer.cornerRadius = roundViewHeight / 2
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: roundViewHeight),
            view.widthAnchor.constraint(equalToConstant: roundViewHeight)
        ])
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.fillSuperview(withConstant: roundViewHeight / 4)
        return view
    }()

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        let image = UIImage(systemName: "books.vertical")
        view.image = image
        return view
    }()

    // MARK: - Initializers
    init(kind: NoDataBackgroundViewKind) {
        self.kind = kind
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    private func setupUI() {
        addSubview(vertStackView)
        
        switch kind {
        case .forBookshelfVc(let buttonKind):
            switch buttonKind {
            case .toRead: titleLabel.text = "It looks like you haven't added any books yet!"
            case .started: titleLabel.text = "It looks like you haven't started any books yet!"
            case .finished: titleLabel.text = "It looks like you haven't finished any books yet!"
            case .downloaded: titleLabel.text = "It looks like you haven't downloaded any books yet!"
            default: print("Case with \(buttonKind) not handled in switch")
            }
        case .networkingError(let error):
            switch error {
            case .noInternetConnection:
                imageView.image = UIImage(systemName: "exclamationmark.triangle")
                titleLabel.text = "No internet connection"
                subtitleLabel.text = "Please check your internet connection and try again."
            case .failedToFetch:
                imageView.image = UIImage(systemName: "exclamationmark.bubble")
                titleLabel.text = "Something went wrong"
                subtitleLabel.text = "There was a problem loading data. Check your connection and try again"
            case .noResults:
                imageView.image = UIImage(systemName: "magnifyingglass")
                titleLabel.text = "No results found"
                subtitleLabel.text = "Check the spelling or try different keywords."
            }
        }
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50),
            vertStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            vertStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
