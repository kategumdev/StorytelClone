//
//  OneBookOverviewCellSubviewsContainer.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/3/23.
//

import UIKit

/// Created as a separate class to enable calculation of OneBookOverviewTableViewCell height
class OneBookOverviewCellSubviewsContainer: UIView {
    // MARK: - Static properties
    static let borderColor = UIColor(named: "borderBookOverview")
    static let backgroundColor = UIColor.powderGrayBackgroundColor
    
    // MARK: - Instance properties
    private var book: Book?
    private let dataPersistenceManager: any DataPersistenceManager
    
    let dimmedAnimationButton: DimmedAnimationButton = {
        let button = DimmedAnimationButton()
        button.backgroundColor = backgroundColor
        button.layer.borderColor = borderColor?.cgColor
        button.layer.borderWidth = 0.9
        return button
    }()
    
    private lazy var vertStackView: UIStackView = {
        let stack = UIStackView()
        stack.isUserInteractionEnabled = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering
        [bookTitleLabel, overviewLabel, starHorzStackView].forEach { stack.addArrangedSubview($0) }
        stack.setCustomSpacing(12.0, after: bookTitleLabel)
        stack.setCustomSpacing(15, after: overviewLabel)
        return stack
    }()
    
    private let bookTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        let font = UIFont.createStaticFontWith(weight: .semibold, size: 31)
        label.font = font
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let font = UIFont.createScaledFontWith(textStyle: .footnote, weight: .regular, maxPointSize: 21)
        let label = UILabel.createLabelWith(font: font, numberOfLines: 5)
        return label
    }()
        
    private lazy var starHorzStackView = StarHorzStackView(withSaveAndEllipsisButtons: false)
    
    private let squareImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = Constants.commonBookCoverCornerRadius
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var saveButton = SaveBookButton()
    
    var saveBookButtonDidTapCallback: SaveBookButtonDidTapCallback = {_ in}
    
    // MARK: - Initializers
    init(dataPersistenceManager: some DataPersistenceManager = CoreDataManager.shared) {
        self.dataPersistenceManager = dataPersistenceManager
        super.init(frame: .zero)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("OneBookOverviewCellSubviewsContainer is not configured to be instantiated from storyboard")
    }
    
    // MARK: -
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            dimmedAnimationButton.layer.borderColor = OneBookOverviewCellSubviewsContainer.borderColor?.cgColor
        }
    }
    
    // MARK: - Instance methods
    func configureFor(book: Book?) {
        guard let book = book else {
            bookTitleLabel.attributedText = NSAttributedString(string: "")
            overviewLabel.attributedText = NSAttributedString(string: "")
            squareImageView.image = UIImageView.placeholderImage
            starHorzStackView.isHidden = true
            saveButton.isHidden = true
            return
        }
        
        self.book = book
        
        let titleString = book.title
        bookTitleLabel.attributedText = NSAttributedString(string: titleString).withLineHeightMultiple(0.8)
        
        let overviewString = book.overview
        overviewLabel.attributedText = NSAttributedString(string: overviewString).withLineHeightMultiple(0.9)
        
        starHorzStackView.isHidden = false
        starHorzStackView.configureWith(book: book)
        
        squareImageView.image = book.coverImage
        
        dimmedAnimationButton.kind = .toPushBookVcWith(book)
        
        saveButton.isHidden = false
        updateSaveButton(isBookBeingAdded: book.isOnBookshelf())
      }
    
    // MARK: - Helper methods
    private func configureSelf() {
        setupUI()
        addSaveButtonAction()
        dimmedAnimationButton.addConfigurationUpdateHandlerWith(viewToTransform: self)
    }
    
    private func setupUI() {
        addSubview(dimmedAnimationButton)
        dimmedAnimationButton.addSubview(vertStackView)
        addSubview(squareImageView)
        addSubview(saveButton)
        applyConstraints()
    }
    
    private func addSaveButtonAction() {
        saveButton.addAction(UIAction(handler: { [weak self] _ in
            self?.handleSaveButtonTapped()
        }), for: .touchUpInside)
    }
    
    private func handleSaveButtonTapped() {
        guard let book = book else { return }
        Utils.playHaptics(withStyle: .soft, andIntensity: 0.7)
        
        dataPersistenceManager.addOrDeletePersistedBookFrom(book: book) { [weak self] result in
            switch result {
            case .success(let bookState):
                let isBookBeingAdded = bookState == .added ? true : false
                self?.updateSaveButton(isBookBeingAdded: isBookBeingAdded)
                self?.saveBookButtonDidTapCallback(isBookBeingAdded)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateSaveButton(isBookBeingAdded: Bool) {
        saveButton.tintColor = isBookBeingAdded ? UIColor.customTintColor : .label
        saveButton.updateImage(isBookBeingAdded: isBookBeingAdded)
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        /* These two constraints are useful only when creating container for calculation of row height
         for the cell using this container */
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            heightAnchor.constraint(
                equalTo: dimmedAnimationButton.heightAnchor,
                constant: 15)
        ])
        
        let leadingConstant: CGFloat = 24
        let imageTopConstant: CGFloat = 8
        let paddingBetweenImageAndStack: CGFloat = 17
        
        vertStackView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant: CGFloat =
        Constants.mediumSquareBookCoverSize.height - imageTopConstant + paddingBetweenImageAndStack
        NSLayoutConstraint.activate([
            vertStackView.topAnchor.constraint(
                equalTo: dimmedAnimationButton.topAnchor,
                constant: topAnchorConstant),
            vertStackView.leadingAnchor.constraint(
                equalTo: dimmedAnimationButton.leadingAnchor,
                constant: leadingConstant),
            vertStackView.widthAnchor.constraint(
                equalTo: dimmedAnimationButton.widthAnchor,
                constant: -(leadingConstant * 2))
        ])
 
        let buttonTopConstant: CGFloat = 15 // Padding between section header label and this button
        dimmedAnimationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedAnimationButton.topAnchor.constraint(
                equalTo: topAnchor,
                constant: buttonTopConstant),
            dimmedAnimationButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: Constants.commonHorzPadding),
            dimmedAnimationButton.widthAnchor.constraint(
                equalTo: widthAnchor,
                constant: -(Constants.commonHorzPadding * 2)),
            dimmedAnimationButton.bottomAnchor.constraint(
                equalTo: vertStackView.bottomAnchor,
                constant: 14)
        ])
        
        squareImageView.translatesAutoresizingMaskIntoConstraints = false
        let imageWidthAndHeight: CGFloat = Constants.mediumSquareBookCoverSize.width
        NSLayoutConstraint.activate([
            squareImageView.topAnchor.constraint(
                equalTo: dimmedAnimationButton.topAnchor,
                constant: -imageTopConstant),
            squareImageView.leadingAnchor.constraint(
                equalTo: dimmedAnimationButton.leadingAnchor,
                constant: leadingConstant),
            squareImageView.widthAnchor.constraint(equalToConstant: imageWidthAndHeight),
            squareImageView.heightAnchor.constraint(equalToConstant: imageWidthAndHeight)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(
                equalTo: dimmedAnimationButton.topAnchor,
                constant: 23),
            saveButton.trailingAnchor.constraint(
                equalTo: dimmedAnimationButton.trailingAnchor,
                constant: -23)
        ])
    }
}
