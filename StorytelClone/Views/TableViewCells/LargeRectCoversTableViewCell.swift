//
//  LargeRectCoversTableViewCell.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/3/23.
//

import UIKit

class LargeRectCoversTableViewCell: UITableViewCell {
    
    static let identifier = "LargeRectCoversTableViewCell"
    
    static let visiblePartOfThirdCover: CGFloat = 14
    static let horzPadding: CGFloat = 8
    
    static let itemSize: CGSize = {
        let contentViewWidth = UIScreen.main.bounds.width
        let visiblePartOfThirdCover = 14
        
        let widthForContent = contentViewWidth - ((horzPadding * 2) + Constants.commonHorzPadding + CGFloat(visiblePartOfThirdCover))
        let itemWidth = widthForContent / (Constants.numberOfVisibleCvItemsInRow - 1)
        let roundedItemWidth = round(itemWidth)

        // Get height for 2:3 aspect ratio
        let height = ((3/2) * roundedItemWidth) + Constants.topPaddingForPosterAndLargeRectCoversCells
        let size = CGSize(width: roundedItemWidth, height: height)
        return size
    }()
    
    static let rowHeight: CGFloat = {
        return itemSize.height
    }()
    
    // MARK: - Instance properties
    var books = [Book]() // It will contain 42 random audiobooks
    var dimmedAnimationButtonDidTapCallback: DimmedAnimationBtnDidTapCallback = {_ in}
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = horzPadding
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LargeBookCollectionViewCell.self, forCellWithReuseIdentifier: LargeBookCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.customBackgroundColor
        return collectionView
    }()
 
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.backgroundView = activityIndicator
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        if books.isEmpty {
            activityIndicator.startAnimating()
        }
        
        collectionView.frame = contentView.bounds
        
        if collectionView.contentOffset == CGPoint(x: 0, y: 0) {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        books = [Book]()
        collectionView.reloadData()
    }
    
    // MARK: - Instance methods
    func configureWith(books: [Book], callback: @escaping DimmedAnimationBtnDidTapCallback) {
        self.books = books
        dimmedAnimationButtonDidTapCallback = callback
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LargeRectCoversTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.isEmpty ? 0 : books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeBookCollectionViewCell.identifier, for: indexPath) as? LargeBookCollectionViewCell else { return UICollectionViewCell()}

        let book = books[indexPath.row]
        cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension LargeRectCoversTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return LargeRectCoversTableViewCell.itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
    }
     
}

