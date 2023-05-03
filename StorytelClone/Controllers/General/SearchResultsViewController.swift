//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class SearchResultsViewController: ScopeViewController {
    // MARK: - Instance properties
//    var modelForSearchQuery: [ScopeButtonKind : [Title]]?
        
    
    // MARK: - Initializers
    init() {
        super.init(withScopeButtonsKinds: ScopeButtonKind.kindsForSearchResults, scopeCollectionViewCellKind: ScopeCollectionViewCellKind.forSearchResults)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        // Search field becomes larger/smaller and collectonView needs to calculate new size for itself
        if traitCollection.preferredContentSizeCategory != previousTraitCollection?.preferredContentSizeCategory {
            collectionView.collectionViewLayout.invalidateLayout()
        }

    }
    
    // MARK: - Instance methods
    func revertToInitialAppearance() {
        scopeButtonsView.revertToInitialAppearance()
        
        // For rare cases if user taps on button and immediately taps Cancel button of parent search controller, isButtonTriggeredScroll won't be set to false and and cell will remain hidden when user taps into search bar again and search controller becomes visible
        toggleIsButtonTriggeredScrollAndUnhideCells()
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        setInitialOffsetsOfTablesInCells()
        collectionView.reloadData()
        
        let firstButton = scopeButtonsView.scopeButtons[0]
        scopeButtonsView.toggleButtonsColors(currentButton: firstButton)
    }
    
}
