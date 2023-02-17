//
//  TableViewCellWithCollection.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 16/2/23.
//

import UIKit

class TableViewCellWithCollection: UITableViewCell {

    static let identifier = "TableViewCellWithCollection"
    
    private let cvPadding: CGFloat = 18
    private let amountOfVisibleCvItems: CGFloat = 3
    
    private let collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160, height: 160)
//        layout.minimumLineSpacing = cvPadding
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    lazy var calculatedItemSize: CGSize = {
        let contentViewWidth = contentView.bounds.width
        let width = (contentViewWidth - cvPadding * amountOfVisibleCvItems) / amountOfVisibleCvItems
        
        let fullWidth = contentViewWidth + (width / 2)
        let itemWidth = (fullWidth - cvPadding * amountOfVisibleCvItems) / amountOfVisibleCvItems
    
        let size = CGSize(width: round(itemWidth), height: round(itemWidth))
        print(size)
        return size
    }()

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
        
        
        // HARDCODED IMAGES
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.configure(withImageNumber: 1)
            }
            
            if indexPath.row == 1 {
                cell.configure(withImageNumber: 2)
            }
            
            if indexPath.row == 2 {
                cell.configure(withImageNumber: 3)
            }
        }
        
        
//        cell.backgroundColor = .black

        return cell
    }

    
}

extension TableViewCellWithCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        calculatedItemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        cvPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: cvPadding, bottom: 0, right: cvPadding)
    }
    
}
