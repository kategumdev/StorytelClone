//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class SearchResultsViewController: UIViewController {

    let buttonsView = SearchResultsButtonsView()
    
    lazy var collectionView: UICollectionView = {
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
    
    // It must be set to button when it is tapped before scrollToItem and set to nil when scrollToItem finished animation. Check this property in cellForRowAt to hide content of other cells while scrollToItem animation to imitate behavior of UIPageViewController.
    private var tappedButtonIndex: Int? = nil
    
    
    enum ScrollDirection {
        case forward
        case back
    }
    
    
    private var currentButtonIndex: Int = 0
    
    private var destinationButtonIndex: Int = 1
    
    private lazy var originXOfAllButtons = buttonsView.getOriginXOfAllButtons()

    private var currentPageIndex: Int  = 0
    private var isButtonTriggeredScroll = false
    
    var buttonsScrollOffsetX: CGFloat = 0.0
    
    var willEndDraggingAtOffsetX: CGFloat = 0.0
    var didEndDecelerated = false
//    var decelerate = true
    
    var previousOffsetX: CGFloat = 0
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(buttonsView)
        configureButtonsView()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        applyConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SearchResultsViewController viewWillAppear")
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsView.scopeButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultsCollectionViewCell.identifier, for: indexPath) as? SearchResultsCollectionViewCell else { return UICollectionViewCell() }
        
        // Hide content of cells that are scrolled through while scrollToItem after button tap. This imitates behavior of UIPageViewContoller. If tappedButtonIndex is not nil, button was tapped and content of other cells must be hidden.
        if let tappedButtonIndex = tappedButtonIndex {
            if indexPath.row == tappedButtonIndex {
                cell.textLabel.text = buttonsView.scopeButtons[tappedButtonIndex].titleLabel?.text
            } else {
                cell.textLabel.text = ""
            }
        } else {
            cell.textLabel.text = buttonsView.scopeButtons[indexPath.row].titleLabel?.text
        }

        return cell
    }
        
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    }
}

extension SearchResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
     
}

extension SearchResultsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let tappedButtonIndex = tappedButtonIndex else { return }
        // Force-reload cell which is previous to the one to which scrollToItem was called. Otherwise it won't reload and may show no content as if it's scrolled through while scrollToItem
        if tappedButtonIndex != 0 {
            let previousButtonIndex = tappedButtonIndex - 1
            collectionView.reloadItems(at: [IndexPath(item: previousButtonIndex, section: 0)])
        }
        self.tappedButtonIndex = nil
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
//        currentButtonIndex = buttonsView.getCurrentButtonIndex()
//        print("   currentButtonIndex: \(currentButtonIndex)")
        
        isButtonTriggeredScroll = false

    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        print("scrollViewWillEndDragging at \(targetContentOffset.pointee.x)")
        willEndDraggingAtOffsetX = targetContentOffset.pointee.x
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print("scrollViewDidEndDragging, decelerate = \(decelerate)")
//        self.decelerate = decelerate
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        didEndDecelerated = true
        // If page scroll was triggered by button tap, toggle isButtonTriggeredScroll and if next scroll will be triggered but user's swiping, logic in didScroll will perform to synchronize moving of scrollView and slidingLine
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
        }
        
        buttonsScrollOffsetX = buttonsView.scrollView.contentOffset.x
//        print("set buttonsScrollOffsetX in scrollViewDidEndDecelerating: \(buttonsScrollOffsetX)")
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("current contentOffset.x: \(scrollView.contentOffset.x)")
        
        let currentOffsetX = scrollView.contentOffset.x
        let pageWidth = collectionView.bounds.size.width
        var currentScrollDirection: ScrollDirection = .forward // value must be changed in next if-else
        if currentOffsetX > previousOffsetX {
            currentScrollDirection = .forward
            print("FORWARD")
        } else {
            currentScrollDirection = .back
            print("BACK")
        }
        
        previousOffsetX = currentOffsetX
        
        let currentLeadingConstant = buttonsView.slidingLineLeadingAnchor.constant
        
        
        
        
        
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        print("scrollViewDidScroll")
////
////        let currentButtonIndex = buttonsView.getCurrentButtonIndex()
//        print("   currentButtonIndex: \(currentButtonIndex)")
//        print("contentOffset: \(scrollView.contentOffset.x)")
//
//
//        guard !isButtonTriggeredScroll else { return }
//
////        previousOffsetX = scrollView.contentOffset.x
//        print("previous: \(previousOffsetX), current: \(scrollView.contentOffset.x)")
//
//
//        let currentOffsetX = scrollView.contentOffset.x
//        let pageWidth = view.bounds.size.width
////        let isScrollingForward = currentOffsetX > pageWidth
//        let isScrollingForward = currentOffsetX > previousOffsetX
//        previousOffsetX = scrollView.contentOffset.x
//        var difference = currentOffsetX - pageWidth
//        print("difference: \(difference)")
//
//
//        // For cases when contentOffset is counting from 0 to 414 after quick scroll back and forward
//        if isScrollingForward && currentOffsetX < pageWidth {
//            difference = currentOffsetX
////            difference = pageWidth - currentOffsetX
//            print("difference set to \(difference)")
//        }
//
//
//        if !isScrollingForward && currentOffsetX < 0 {
//            print("              !isScrollingForward && currentOffsetX < 0")
//        }
//
//
////        if difference < 0 {
////            difference = pageWidth - currentOffsetX
////            difference = abs(difference)
//////            isScrollingForward =
////        }
//
//
//
//        guard difference != 0 else {
////            print("difference 0, button is \(currentButtonIndex)")
//            return }
//
//
////        if isScrollingForward {
////            if destinationButtonIndex + 1 != pages.count - 1 {
////                destinationButtonIndex += 1
////            }
////        } else {
////            if destinationButtonIndex - 1 >= 0 {
////                destinationButtonIndex -= 1
////            }
////        }
////
////        let destinationButton = buttonsView.scopeButtons[destinationButtonIndex]
////
////        let buttonWidth = destinationButton.bounds.size.width
//
//
//        var currentButton = buttonsView.scopeButtons[currentButtonIndex]
//        if currentOffsetX < 0 {
//            currentButton = buttonsView.scopeButtons[currentButtonIndex + 1]
//        }
//
//
////        let currentButton = buttonsView.scopeButtons[currentButtonIndex]
//
//        var buttonWidth: CGFloat
//        if isScrollingForward {
//            buttonWidth = currentButton.bounds.size.width
//            print("     FORWARD")
//        } else {
//            print("     BACK")
//            if currentButtonIndex == 0 {
//                buttonWidth = buttonsView.scopeButtons[0].bounds.size.width
//            } else {
//                let previousButton = buttonsView.scopeButtons[currentButtonIndex - 1]
//                buttonWidth = previousButton.bounds.size.width
//            }
//        }
//
//
//
//  // LOGIC FOR MOVING CONTENTOFFSETX OF SCROLL VIEW OF BUTTONSVIEW
//
////        let scrollViewWidthToMove = buttonsView.partOfUnvisiblePart
////        let newOffset = difference / pageWidth * scrollViewWidthToMove
////
////        print("part: \(newOffset)")
////
////        let initialOffset = buttonsScrollOffsetX
////        var calculatedNewOffset = initialOffset + newOffset
////
////        if calculatedNewOffset < 0 {
////            calculatedNewOffset = 0
////        }
////
////        if calculatedNewOffset > buttonsView.scrollView.contentSize.width {
////            calculatedNewOffset = buttonsView.scrollView.contentSize.width
////        }
////
////
////        buttonsView.scrollView.setContentOffset(CGPoint(x: calculatedNewOffset, y: 0), animated: false)
////        print("offset set to \(calculatedNewOffset)")
//
//
//
//        var slidingLineX = difference / pageWidth * buttonWidth
//
//        if currentButtonIndex == 0 && isScrollingForward == false {
//            slidingLineX = -slidingLineX
//        }
//
//        let currentButtonInitialConstant = currentButton.frame.origin.x
//
////        buttonsView.slidingLineLeadingAnchor.constant = slidingLineX
//        if currentButtonIndex == 0 && !isScrollingForward {
//            var constant: CGFloat = -(currentButtonInitialConstant + slidingLineX)
//            if constant < 0 {
//                constant = 0
//            }
//            buttonsView.slidingLineLeadingAnchor.constant = constant
//
//
////            buttonsView.slidingLineLeadingAnchor.constant = -(currentButtonInitialConstant + slidingLineX)
//            print("currentButtonIndex == 0 && !isScrollingForward, constant: \(-(currentButtonInitialConstant + slidingLineX))")
//        } else {
//            buttonsView.slidingLineLeadingAnchor.constant = currentButtonInitialConstant + slidingLineX
//            print("CONSTANT: \(buttonsView.slidingLineLeadingAnchor.constant)")
//
//        }
////        print("CONSTANT: \(buttonsView.slidingLineLeadingAnchor.constant)")
//    }
}






// MARK: - Helper methods
extension SearchResultsViewController {
    

    
    func revertToInitialAppearance() {
        buttonsView.revertToInitialAppearance()
    }
    
    
    private func configureButtonsView() {
        // Respond to button actions in buttonsView
        buttonsView.callBack = { [weak self] buttonIndex in
            guard let self = self else { return }
            
            // To avoid logic in didScroll to perform if page scroll is triggered by button tap
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
        // Constant 1 added to hide border of buttonsView on sides
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
