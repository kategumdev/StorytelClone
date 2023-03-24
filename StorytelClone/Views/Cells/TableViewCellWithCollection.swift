//
//  TableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class TableViewCellWithCollection: UITableViewCell {

    static let identifier = "TableViewCellWithCollection"
    
    // Actual value injected when cell is being configured in cellForRowAt
    var books: [Book] = [Book]() // It will contain only 10 random books
    
    var callbackClosure: ButtonCallback = {_ in}
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.cvPadding
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
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

        if collectionView.contentOffset != CGPoint(x: 0, y: 0) {
            collectionView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    func configureWith(books: [Book], callbackForButtons: @escaping ButtonCallback) {
        self.books = books
        self.callbackClosure = callbackForButtons
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

        guard let book = books.randomElement() else { return UICollectionViewCell()}
        
        // Pass callback closure this TableViewCellWithCollection got from owning controller to BookCollectionViewCell
        cell.configureFor(book: book, withCallbackForButton: callbackClosure)

        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension TableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Utils.calculatedCvItemSizeSquareCovers
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
    }
     
}
