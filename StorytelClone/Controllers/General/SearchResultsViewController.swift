//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class SearchResultsViewController: ScopeViewController {
    // MARK: - Instance properties
    var networkManagerError: NetworkManagerError? = nil {
        didSet {
            for table in scopeTablesForCvCells {
                table.networkManagerError = networkManagerError
            }
        }
    }

    // MARK: - Initializers
    init() {
        super.init(withScopeButtonsViewKind: .forSearchResultsVc)
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
    
    func handleSearchResult(_ result: SearchResult) {
        switch result {
        case .success(let fetchedBooks):
            networkManagerError = nil
            var books = fetchedBooks
            books.shuffle()
            let newModel = createNewModelWith(books: books)

            DispatchQueue.main.async { [weak self] in
                self?.modelForSearchQuery = newModel
            }
        case .failure(let error):
            if let networkError = error as? NetworkManagerError {
                DispatchQueue.main.async { [weak self] in
                    self?.networkManagerError = networkError
                    self?.modelForSearchQuery = self?.createNewModelWith(books: nil)
                }
            }
        }
    }
    
    // MARK: - Helper methods
    // This method doesn't fetch data, it just shows hardcoded data
    private func createNewModelWith(books: [Book]?) -> [ScopeButtonKind : [Title]] {
        var newModel = [ScopeButtonKind : [Title]]()
        let buttonKinds = ScopeButtonsViewKind.forSearchResultsVc.buttonKinds

        guard let fetchedBooks = books else {
            buttonKinds.forEach { newModel[$0] = [Book]() }
            return newModel
        }
        
        // Handle case when !books.isEmpty, set hardcoded data for other buttondKinds
        for buttonKind in buttonKinds {
            switch buttonKind {
            case .top: newModel[buttonKind] = [Book.book5, Storyteller.neilGaiman, Series.series1, Storyteller.tolkien, Storyteller.author9, Book.book1, Book.book10, Storyteller.author10, Storyteller.author6]
            case .books: newModel[buttonKind] = fetchedBooks
            case .authors: newModel[buttonKind] = [Storyteller.neilGaiman, Storyteller.tolkien, Storyteller.author1, Storyteller.author2, Storyteller.author3, Storyteller.author4, Storyteller.author5, Storyteller.author6, Storyteller.author7, Storyteller.author8, Storyteller.author9, Storyteller.author10]
            case .narrators: newModel[buttonKind] = [Storyteller.narrator10, Storyteller.narrator3, Storyteller.narrator5]
            case .series:
                newModel[buttonKind] = [Series.series3, Series.series2, Series.series1]
            case .tags: newModel[buttonKind] = [Tag.tag10, Tag.tag9, Tag.tag10]
            default: newModel[buttonKind] = [Title]()
            }
        }
        return newModel
    }
    
}
