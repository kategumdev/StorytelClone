//
//  TableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class TableViewCellWithCollection: UITableViewCell {

    static let identifier = "TableViewCellWithCollection"
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.minimumLineSpacing = Constants.cvPadding  
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
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

}

extension TableViewCellWithCollection: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as? BookCollectionViewCell else { return UICollectionViewCell()}
        
        // Randomly configure items with different badges
        if indexPath.row < 5 && indexPath.row % 2 == 0 {
            cell.configure(withCoverNumber: indexPath.row + 1, forItemKind: .audioBookAndEbook)
        } else if indexPath.row % 2 == 0 {
            cell.configure(withCoverNumber: indexPath.row + 1, forItemKind: .ebook)
        } else {
            cell.configure(withCoverNumber: indexPath.row + 1, forItemKind: .audiobook)
        }
        return cell
    }
    
}

extension TableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        Constants.calculatedCvItemSizeSquareCovers
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
    }
     
}
