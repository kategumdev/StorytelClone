//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

enum ScrollDirection {
    case forward
    case back
}

class SearchResultsViewController: UIViewController {

    private let buttonsView = SearchResultsButtonsView()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SearchResultsCollectionViewCell.self, forCellWithReuseIdentifier: SearchResultsCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = Utils.customBackgroundColor
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    private var tappedButtonIndex: Int? = nil
    
    private var previousOffsetX: CGFloat = 0
    private var isButtonTriggeredScroll = false
    
//    private var previousContentSize: UIContentSizeCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(buttonsView)
        configureButtonsView()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        applyConstraints()
        
//        previousContentSize = traitCollection.preferredContentSizeCategory
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//        let currentContentSize = traitCollection.preferredContentSizeCategory
//
//        if previousContentSize != currentContentSize {
//            print("view minY AFTER: \(view.bounds.minY)")
//
//            previousContentSize = currentContentSize
//        }
//    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsView.scopeButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
        
        print("\ndequeue cell \(buttonsView.buttonKinds[indexPath.row].rawValue)")
        
        cell.buttonKind = buttonsView.buttonKinds[indexPath.row]
        
        if cell.isBeingReused == true {
            cell.resultsTable.reloadData()
        }
        
        
//        // Set the text for the titleLabel of table view section header when cell is actually reused (not created). Otherwise the text may not be set correctly.
//        if let headerView = cell.resultsTable.headerView(forSection: 0) as? SearchResultsSectionHeaderView {
//            headerView.configureFor(buttonKind: buttonsView.buttonKinds[indexPath.row])
//            print("header title \(String(describing: headerView.titleLabel.text))")
//            cell.resultsTable.reloadData()
//        }

        return cell
    }
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
//
//        // Hide content of cells that are scrolled through while scrollToItem after button tap. This imitates behavior of UIPageViewContoller. If tappedButtonIndex is not nil, button was tapped and content of other cells must be hidden.
//        if let tappedButtonIndex = tappedButtonIndex {
//            if indexPath.row == tappedButtonIndex {
//                cell.resultsTable.isHidden = false
//                cell.buttonKind = buttonsView.buttonKinds[tappedButtonIndex]
//                cell.sectionHeader.configureFor(buttonKind: buttonsView.buttonKinds[tappedButtonIndex])
//
//                // Set the text for the titleLabel in the table view header view
//                if let headerView = cell.resultsTable.headerView(forSection: 0) as? SearchResultsSectionHeaderView {
//                    headerView.titleLabel.text = buttonsView.buttonKinds[tappedButtonIndex].rawValue
//                }
//
//                print("cell is reconfigured for \(buttonsView.buttonKinds[tappedButtonIndex].rawValue), header title: \(String(describing: cell.sectionHeader.titleLabel.text))")
//            } else {
//                cell.resultsTable.isHidden = true
//                }
//        } else {
//            cell.resultsTable.isHidden = false
//            cell.buttonKind = buttonsView.buttonKinds[indexPath.row]
//            cell.sectionHeader.configureFor(buttonKind: buttonsView.buttonKinds[indexPath.row])
//
//            // Set the text for the titleLabel in the table view header view
//            if let headerView = cell.resultsTable.headerView(forSection: 0) as? SearchResultsSectionHeaderView {
//                headerView.titleLabel.text = buttonsView.buttonKinds[indexPath.row].rawValue
//            }
//
//            print("cell is reconfigured for \(buttonsView.buttonKinds[indexPath.row].rawValue), header title: \(String(describing: cell.sectionHeader.titleLabel.text))")
//        }
//
//        return cell
//    }

}


// MARK: - UIScrollViewDelegate
extension SearchResultsViewController {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let tappedButtonIndex = tappedButtonIndex else { return }
        // Force-reload cell which is previous to the one to which scrollToItem was called. Otherwise it won't reload and may show no content as if it's scrolled through while scrollToItem
//        if tappedButtonIndex != 0 {
//            let previousButtonIndex = tappedButtonIndex - 1
//            collectionView.reloadItems(at: [IndexPath(item: previousButtonIndex, section: 0)])
//
//        }
        
//        collectionView.reloadData()
        
        self.tappedButtonIndex = nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("\n\nscrollViewWillBeginDragging")
        // When button on buttonsView is tapped, this property is set to true. It's needed for use in guard in didScroll to avoid executing logic for adjusting buttonsView. Toggling it to false lets that logic to execute when didScroll is triggered by user's swiping
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
        }
    }
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !isButtonTriggeredScroll else { return }
//        print("current contentOffset.x: \(scrollView.contentOffset.x)")
        let currentOffsetX = scrollView.contentOffset.x
        let pageWidth = collectionView.bounds.size.width
        let currentButtonIndex = buttonsView.getCurrentButtonIndex()
        let currentButton = buttonsView.scopeButtons[currentButtonIndex]
        
        // Adjust sliding line leading anchor constant
        let ranges = buttonsView.rangesOfButtons
        let previousButtonUpperBound = currentButtonIndex != 0 ? ranges[currentButtonIndex - 1].upperBound : 0.0
        
        let currentOffsetXInRangeOfPageWidth = currentButtonIndex == 0 ? currentOffsetX : currentOffsetX - (CGFloat(currentButtonIndex) * pageWidth)
        
        let currentButtonWidth = currentButton.bounds.size.width
        let slidingLineXProportionalPart = currentOffsetXInRangeOfPageWidth / pageWidth * currentButtonWidth
        
        let leadingConstant = previousButtonUpperBound + slidingLineXProportionalPart
        buttonsView.slidingLineLeadingAnchor.constant = leadingConstant
        
        // Adjust contentOffset.x of scroll of buttonsView
        buttonsView.adjustScrollViewOffsetX(currentOffsetXOfCollectionView: currentOffsetX, withPageWidth: pageWidth)
        
        let currentScrollDirection: ScrollDirection = currentOffsetX > previousOffsetX ? .forward : .back
        previousOffsetX = currentOffsetX
        
        // Toggle buttons' colors
        if currentScrollDirection == .back {
            buttonsView.toggleButtonsColors(currentButton: currentButton)
        } else {
            // Determine current button, because the way of determining currentButton above uses half-open range and it doesn't work for this particular case
            let currentButtonIndex = Int(currentOffsetX / pageWidth)
            let currentButton = buttonsView.scopeButtons[currentButtonIndex]
            buttonsView.toggleButtonsColors(currentButton: currentButton)
        }

        // Adjust sliding line width
        buttonsView.adjustSlidingLineWidthWhen(currentScrollDirectionOfCv: currentScrollDirection, currentButtonIndex: currentButtonIndex, slidingLineXProportionalPart: slidingLineXProportionalPart, currentOffsetXOfCvInRangeOfOnePageWidth: currentOffsetXInRangeOfPageWidth, pageWidthOfCv: pageWidth)
    }

}

// MARK: - Helper methods
extension SearchResultsViewController {

    func revertToInitialAppearance() {
        buttonsView.revertToInitialAppearance()
        scrollToCell(0)
    }
    
    private func configureButtonsView() {
        // Respond to button actions in buttonsView
        buttonsView.callBack = { [weak self] buttonIndex in
            guard let self = self else { return }
            // To avoid logic in didScroll to perform if scroll is triggered by button tap
            self.isButtonTriggeredScroll = true
            
            self.scrollToCell(buttonIndex)
        }
        
        // Hide top border of buttonsView
        let hideView = UIView()
        hideView.backgroundColor = Utils.customBackgroundColor
        view.addSubview(hideView)
        
        hideView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hideView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -1),
            hideView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hideView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hideView.heightAnchor.constraint(equalToConstant: 3)
        ])
    }
    
    private func scrollToCell(_ cellIndex: Int) {
        let indexPath = IndexPath(item: cellIndex, section: 0)
        tappedButtonIndex = cellIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func applyConstraints() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        // Constant 1 added to hide borders of buttonsView on leading and trailing sides
        NSLayoutConstraint.activate([
//            buttonsView.topAnchor.constraint(equalTo: view.topAnchor),
            buttonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SearchResultsButtonsView.viewHeight)
        ])
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
