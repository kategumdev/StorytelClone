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
    private var books = [Book]()
    private var dimmedAnimationButtonDidTapCallback: DimmedAnimationBtnDidTapCallback = {_ in}
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.hidesWhenStopped = true
        return view
    }()
    
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        books = [Book]()
        
        if collectionView.contentOffset != CGPoint(x: 0, y: 0) {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - Instance methods
    func configureFor(books: [Book], callback: @escaping DimmedAnimationBtnDidTapCallback) {
        self.books = books
        dimmedAnimationButtonDidTapCallback = callback
        activityIndicator.stopAnimating()
        collectionView.reloadData()
    }
     
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if books.isEmpty {
            return 0
        } else if books.count < 10 {
            return books.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell()}
        
        let book = books[indexPath.row]
        cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemHeight = TableViewCellWithCollection.rowHeight
        var itemWidth = Constants.largeSquareBookCoverSize.width
        
        if !books.isEmpty, let coverImage = books[indexPath.row].coverImage {
            itemWidth = coverImage.size.width
        }
        return CGSize(width: itemWidth, height: itemHeight)
     }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
    }
     
}
