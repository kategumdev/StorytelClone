//
//  TableViewCellWithHorzCvLargeCovers.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/3/23.
//

import UIKit

class TableViewCellWithHorzCvLargeCovers: UITableViewCell {
    
    static let identifier = "TableViewCellWithHorzCvLargeCovers"
    
    // MARK: - Instance properties
    // Actual value injected when cell is being configured in cellForRowAt
    var books: [Book] = [Book]() // It will contain 42 random audiobooks
    var dimmedAnimationButtonDidTapCallback: DimmedAnimationButtonDidTapCallback = {_ in}
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.paddingForHorzCvLargeCovers
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LargeBookCollectionViewCell.self, forCellWithReuseIdentifier: LargeBookCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Utils.customBackgroundColor
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
        
        if collectionView.contentOffset == CGPoint(x: 0, y: 0) {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    // MARK: - Instance methods
    func configureWith(books: [Book], callback: @escaping DimmedAnimationButtonDidTapCallback) {
        self.books = books
        self.dimmedAnimationButtonDidTapCallback = callback
        collectionView.reloadData()
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TableViewCellWithHorzCvLargeCovers: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeBookCollectionViewCell.identifier, for: indexPath) as? LargeBookCollectionViewCell else { return UICollectionViewCell()}

        let book = books[indexPath.row]
        
        // Pass callback closure this TableViewCellWithCollection got from owning controller to BookCollectionViewCell
        cell.configureFor(book: book, withCallback: dimmedAnimationButtonDidTapCallback)

        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TableViewCellWithHorzCvLargeCovers: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utils.calculatedHorzCvItemSizeLargeCovers
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.commonHorzPadding, bottom: 0, right: Constants.commonHorzPadding)
    }
     
}

