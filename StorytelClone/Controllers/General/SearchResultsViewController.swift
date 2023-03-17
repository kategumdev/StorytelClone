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
    
//    private var cellsToHideContent: [Int]?
    private var cellsToHideContent = [Int]()
    private var indexPathsToUnhide = [IndexPath]()
    
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
        
        if isButtonTriggeredScroll {
            if cellsToHideContent.contains(indexPath.row) == true {
                cell.resultsTable.isHidden = true
                return cell
            } else {
                cell.resultsTable.isHidden = false
                cell.resultsTable.reloadData()
                return cell
            }
        }
        
        cell.resultsTable.isHidden = false
        cell.resultsTable.reloadData()
        return cell
        
    }
    
}


// MARK: - UIScrollViewDelegate
extension SearchResultsViewController {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        toggleIsButtonTriggeredScrollAndUnhideCells()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("\n\nscrollViewWillBeginDragging")
        toggleIsButtonTriggeredScrollAndUnhideCells()
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
        
        // Avoid setting leading anchor outside the stackView, because it causes constraints conflict on scroll back when current button is 0
        if leadingConstant < 0 {
            buttonsView.slidingLineLeadingAnchor.constant = 0.0
        } else {
            buttonsView.slidingLineLeadingAnchor.constant = leadingConstant
        }
                
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
    
    private func toggleIsButtonTriggeredScrollAndUnhideCells() {
        // When button on buttonsView is tapped, this property is set to true. It's needed for use in guard in didScroll to avoid executing logic for adjusting buttonsView. Toggling it to false lets that logic to execute when didScroll is triggered by user's swiping
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
            
            // Unhide those cells that are hidden and ready to become visible
            collectionView.reloadItems(at: indexPathsToUnhide)
        }
    }

    func revertToInitialAppearance() {
        buttonsView.revertToInitialAppearance()
        
        // For rare cases if user taps on button and immediately taps Cancel button, isButtonTriggeredScroll won't be set to false and and cell will remain hidden when user taps into search bar again and search controller becomes visible
        toggleIsButtonTriggeredScrollAndUnhideCells()
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
        
//        scrollToCell(0)
        
        let firstButton = buttonsView.scopeButtons[0]
        buttonsView.toggleButtonsColors(currentButton: firstButton)
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
//        let indexPath = IndexPath(item: cellIndex, section: 0)
        let tappedButtonIndex = cellIndex
        let currentButtonIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        guard tappedButtonIndex != currentButtonIndex else {
            print("          same indices")
            
            // To avoid behavior when it is set to true, because code below in this method won't be triggered and therefore no cells need to be hidden
            isButtonTriggeredScroll = false
            return
        }

        
        // Get array of indices of buttons between current and tapped one (excl current and tapped)
        let range: Range<Int> = currentButtonIndex < tappedButtonIndex ? currentButtonIndex + 1..<tappedButtonIndex : tappedButtonIndex + 1..<currentButtonIndex
        
        var buttonsIndicesBetween = [Int]()
        for index in range {
            buttonsIndicesBetween.append(index)
        }
        
        // Save to hide content when cells in between will be reused while scrollToItem performs to imitate UIPageViewController behavior
        cellsToHideContent = buttonsIndicesBetween
        
        // Reload cells in between that are already reused and ready to become visible
        var indexPaths = [IndexPath]()
        for index in buttonsIndicesBetween {
            let indexPath = IndexPath(item: index, section: 0)
            indexPaths.append(indexPath)
        }
        
        collectionView.reloadItems(at: indexPaths)
        
        indexPathsToUnhide = indexPaths
    
        let indexPath = IndexPath(item: tappedButtonIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func applyConstraints() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        // Constants added to hide borders of buttonsView on leading and trailing sides
        NSLayoutConstraint.activate([
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
