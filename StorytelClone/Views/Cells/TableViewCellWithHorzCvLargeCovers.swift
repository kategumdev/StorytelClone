//
//  TableViewCellWithHorzCvLargeCovers.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 5/3/23.
//

import UIKit

class TableViewCellWithHorzCvLargeCovers: UITableViewCell {
    
    static let identifier = "TableViewCellWithHorzCvLargeCovers"
    
    // Actual value injected when cell is being configured in cellForRowAt
    var books: [Book] = [Book]() // It will contain 42 random audiobooks
    
    var callbackClosure: ButtonCallbackClosure = {_ in}
    
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
 
    // MARK: - View life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    func configureWith(books: [Book], callbackForButtons: @escaping ButtonCallbackClosure) {
        self.books = books
        self.callbackClosure = callbackForButtons
    }

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension TableViewCellWithHorzCvLargeCovers: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 42
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LargeBookCollectionViewCell.identifier, for: indexPath) as? LargeBookCollectionViewCell else { return UICollectionViewCell()}

        let book = books[indexPath.row]
        
        // Pass callback closure this TableViewCellWithCollection got from owning controller to BookCollectionViewCell
        cell.configureFor(book: book, withCallbackForButton: callbackClosure)

        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TableViewCellWithHorzCvLargeCovers: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utils.calculatedHorzCvItemSizeLargeCovers
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
    }
     
}
