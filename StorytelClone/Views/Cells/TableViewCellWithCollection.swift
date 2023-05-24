//
//  TableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class TableViewCellWithCollection: UITableViewCell {

    // MARK: - Static properties
    static let identifier = "TableViewCellWithCollection"
    
    static let rowHeight: CGFloat = {
        let topPadding: CGFloat = BadgeView.badgeTopAnchorPoints + 3
        return Constants.largeSquareBookCoverSize.height + topPadding
    }()
    
    // MARK: - Instance properties
    var books = [Book]() // It will contain only 10 books
    private var resizedImages = [UIImage]()
    private var itemSizes = [CGSize]()
    
    var dimmedAnimationButtonDidTapCallback: DimmedAnimationButtonDidTapCallback = {_ in}
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.commonHorzPadding
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.customBackgroundColor
        return collectionView
    }()
 
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds

        if collectionView.contentOffset != CGPoint(x: 0, y: 0) {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    // MARK: - Instance methods
    func configureWith(books: [Book], callback: @escaping DimmedAnimationButtonDidTapCallback) {
        self.books = books
        self.dimmedAnimationButtonDidTapCallback = callback
        
        // Resize images for use in cv cells and in sizeForItemAt method of cv
        for book in books {
            let height = Constants.largeSquareBookCoverSize.height
            if let image = book.coverImage {
                let resizedImage = image.resizeFor(targetHeight: height)
                resizedImages.append(resizedImage)
                let itemSize = CGSize(width: resizedImage.size.width, height: TableViewCellWithCollection.rowHeight)
                itemSizes.append(itemSize)
            }
        }
        collectionView.reloadData()
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell()}

        let book = books[indexPath.row]
        let resizedImage = resizedImages[indexPath.row]
        cell.configureFor(book: book, resizedImage: resizedImage, withCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSizes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
    }
     
}
