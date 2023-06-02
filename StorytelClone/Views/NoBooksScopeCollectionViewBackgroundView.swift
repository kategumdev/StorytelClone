//
//  NoBooksScopeCollectionViewBackgroundView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 2/5/23.
//

import UIKit

class NoBooksScopeCollectionViewBackgroundView: UIView {
    
    // MARK: - Instance properties
    private let roundViewHeight: CGFloat = UIScreen.main.bounds.width / 4
    private let scopeButtonsViewKind: ScopeButtonsViewKind?
    private let scopeButtonKind: ScopeButtonKind?
    private let networkManagerError: NetworkManagerError?

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        let image = UIImage(systemName: "books.vertical")
        view.image = image
        return view
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
    
    private let titleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .title3, weight: .semibold, maxPointSize: 38)
        let label = UILabel.createLabelWith(font: scaledFont, numberOfLines: 3)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .regular, maxPointSize: 30)
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
    
    private lazy var vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        [horzStackView, titleLabel, subtitleLabel].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(26, after: horzStackView)
        stack.setCustomSpacing(15, after: titleLabel)
        return stack
    }()

    // MARK: - Initializers
    init(scopeButtonKind: ScopeButtonKind? = nil, scopeButtonsViewKind: ScopeButtonsViewKind? = nil, networkManagerError: NetworkManagerError?) {
        self.scopeButtonKind = scopeButtonKind
        self.scopeButtonsViewKind = scopeButtonsViewKind
        self.networkManagerError = networkManagerError
        super.init(frame: .zero)
        addSubview(vertStackView)
        configureSelf()
        applyConstraints()
    }
    
//    init(scopeButtonKind: ScopeButtonKind? = nil, scopeButtonsViewKind: ScopeButtonsViewKind? = nil) {
//        self.scopeButtonKind = scopeButtonKind
//        self.scopeButtonsViewKind = scopeButtonsViewKind
//        super.init(frame: .zero)
//        addSubview(vertStackView)
//        applyConstraints()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    private func configureSelf() {
        if scopeButtonsViewKind == .forBookshelfVc {
            // Configuration for BookshelfVC
            guard let buttonKind = scopeButtonKind else { return }
            switch buttonKind {
            case .toRead: titleLabel.text = "It looks like you haven't added any books yet!"
            case .started: titleLabel.text = "It looks like you haven't started any books yet!"
            case .finished: titleLabel.text = "It looks like you haven't finished any books yet!"
            case .downloaded: titleLabel.text = "It looks like you haven't downloaded any books yet!"
            default: print("Case with \(buttonKind) not handled in switch")
            }
            return
        }
        
        // Configuration for other cases
        if networkManagerError == .noInternetConnection {
            imageView.image = UIImage(systemName: "exclamationmark.triangle")
            titleLabel.text = "No internet connection"
            subtitleLabel.text = "Please check your internet connection and try again."
            return
        }
        
        if networkManagerError == .failedToFetch {
            imageView.image = UIImage(systemName: "exclamationmark.bubble")
            titleLabel.text = "Something went wrong"
            subtitleLabel.text = "There was a problem loading data. Check your connection and try again"
            return
        }
        
        if networkManagerError == .noResults {
            imageView.image = UIImage(systemName: "magnifyingglass")
            titleLabel.text = "No results found"
            subtitleLabel.text = "Check the spelling or try different keywords."
        }
        
//        imageView.image = UIImage(systemName: "magnifyingglass")
//        titleLabel.text = "No results found"
//        subtitleLabel.text = "Check the spelling or try different keywords."
        return
    }
    
//    func configure(noInternetConnection: Bool = false, fetchingErrorOcurred: Bool = false) {
//        if scopeButtonsViewKind == .forBookshelfVc {
//            // Configuration for BookshelfVC
//            guard let buttonKind = scopeButtonKind else { return }
//            switch buttonKind {
//            case .toRead: titleLabel.text = "It looks like you haven't added any books yet!"
//            case .started: titleLabel.text = "It looks like you haven't started any books yet!"
//            case .finished: titleLabel.text = "It looks like you haven't finished any books yet!"
//            case .downloaded: titleLabel.text = "It looks like you haven't downloaded any books yet!"
//            default: print("Case with \(buttonKind) not handled in switch")
//            }
//        }
//
//        // Configuration for other cases
//        if noInternetConnection {
//            imageView.image = UIImage(systemName: "exclamationmark.triangle")
//            titleLabel.text = "No internet connection"
//            subtitleLabel.text = "Please check your internet connection and try again."
//            return
//        }
//
//        if fetchingErrorOcurred {
//            imageView.image = UIImage(systemName: "exclamationmark.bubble")
//            titleLabel.text = "Something went wrong"
//            subtitleLabel.text = "There was a problem loading data. Check your connection and try again"
//            return
//        }
//
//        imageView.image = UIImage(systemName: "magnifyingglass")
//        titleLabel.text = "No results found"
//        subtitleLabel.text = "Check the spelling or try different keywords."
//        return
//    }
    
//    func configure(noInternetConnection: Bool, fetchingErrorOcurred: Bool) {
//        // Configuration for SearchResultsfVC
//        if scopeButtonsViewKind == .forSearchResultsVc {
//            if noInternetConnection {
//                imageView.image = UIImage(systemName: "exclamationmark.triangle")
//                titleLabel.text = "No internet connection"
//                subtitleLabel.text = "Please check your internet connection and try again."
//                return
//            }
//
//            if fetchingErrorOcurred {
//                imageView.image = UIImage(systemName: "exclamationmark.bubble")
//                titleLabel.text = "Something went wrong"
//                subtitleLabel.text = "There was a problem loading data. Check your connection and try again"
//                return
//            }
//
//            imageView.image = UIImage(systemName: "magnifyingglass")
//            titleLabel.text = "No results found"
//            subtitleLabel.text = "Check the spelling or try different keywords."
//            return
//        }
//
//        // Configuration for BookshelfVC
//        guard let buttonKind = scopeButtonKind else { return }
//        switch buttonKind {
//        case .toRead: titleLabel.text = "It looks like you haven't added any books yet!"
//        case .started: titleLabel.text = "It looks like you haven't started any books yet!"
//        case .finished: titleLabel.text = "It looks like you haven't finished any books yet!"
//        case .downloaded: titleLabel.text = "It looks like you haven't downloaded any books yet!"
//        default: print("Case with \(buttonKind) not handled in switch")
//        }
//    }
    
    // MARK: - Helper methods
    private func applyConstraints() {
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vertStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -50),
            vertStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            vertStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
