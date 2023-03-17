//
//  PosterTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 3/3/23.
//

import UIKit

class PosterTableViewCell: UITableViewCell {
    
    static let identifier = "PosterTableViewCell"
        
    static let calculatedWidth: CGFloat = UIScreen.main.bounds.size.width - (Constants.cvPadding * 2)
    
    static let calculatedHeightForRow: CGFloat = calculatedHeight + Constants.posterAndLargeCoversCellTopPadding
    
    static let calculatedHeight: CGFloat = {
        let height = round(calculatedWidth + (calculatedWidth / 6))
        return height
    }()
    
    // MARK: - Instance properties
    private let posterButton = CellButton()
    
    private lazy var dimViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = Utils.customBackgroundColor
        contentView.addSubview(posterButton)
        contentView.addSubview(dimViewForButtonAnimation)
        addButtonUpdateHandler()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    func configureFor(book: Book, withCallbackForButton callback: @escaping ButtonCallback) {
        posterButton.book = book
        posterButton.callback = callback
        
        posterButton.configuration?.background.image = book.coverImage
    }
    
    private func addButtonUpdateHandler() {
        posterButton.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                    self.dimViewForButtonAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
                        self.posterButton.isButtonTooLongInHighlightedState = true
                    }
                }
                self.posterButton.buttonTimer = timer
                
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = .identity
                    self.dimViewForButtonAnimation.alpha = 0
                })
            }
        }
    }
    
    private func applyConstraints() {
        dimViewForButtonAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForButtonAnimation.fillSuperview()
        
        posterButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterButton.widthAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedWidth),
            posterButton.heightAnchor.constraint(equalToConstant: PosterTableViewCell.calculatedHeight),
            posterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.posterAndLargeCoversCellTopPadding),
            posterButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        ])
    }
}
