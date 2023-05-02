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

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.tintColor = .black
        let image = UIImage(systemName: "books.vertical")
        view.image = image
//        view.backgroundColor = .blue
        return view
    }()
    
    private lazy var roundViewWithImage: UIView = {
//        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: roundViewHeight, height: roundViewHeight)))
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
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 20)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 38, numberOfLines: 3)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let font = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        let label = UILabel.createLabel(withFont: font, maximumPointSize: 30, numberOfLines: 2, text: "Once you do, you will find them here.")
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vertStackView)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureFor(buttonKind: ScopeButtonKind?) {
        guard let buttonKind = buttonKind else { return }
        switch buttonKind {
        case .toRead: titleLabel.text = "It looks like you haven't added any books yet!"
        case .started: titleLabel.text = "It looks like you haven't started any books yet!"
        case .finished: titleLabel.text = "It looks like you haven't finished any books yet!"
        case .downloaded: titleLabel.text = "It looks like you haven't downloaded any books yet!"
        default: print("Case with \(buttonKind) not handled in switch")
        }
    }
    
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
