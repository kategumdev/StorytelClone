//
//  SearchResultsViewController.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class SearchResultsViewController: UIViewController {

    let buttonsView = SearchResultsButtonsView()
    
    private var pageController: UIPageViewController?
    
    private lazy var pages: [PageContentViewController] = {
        var array = [PageContentViewController]()
        
        for button in buttonsView.scopeButtons {
            let page = PageContentViewController()
            page.textLabel.text = button.titleLabel?.text
            array.append(page)
        }
        
        return array
    }()
//    private var currentIndex: Int = 0
    
    private var currentPageIndex: Int  = 0
    private var isButtonTriggeredScroll = false
    
    var buttonsScrollOffsetX: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Utils.customBackgroundColor
        view.addSubview(buttonsView)
        configureButtonsView()
        
        setupPageController()
        applyConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("SearchResultsViewController viewWillAppear")
    }
    
}

// MARK: - UIPageViewControllerDataSource, UIPageViewControllerDelegate
extension SearchResultsViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let currentViewController = viewController as? PageContentViewController else { return nil }
        guard let currentIndex = pages.firstIndex(of: currentViewController) else { return nil }
        
        // Needed for calculations in didScroll to synchronize moving of scrollView and slidingLine
        currentPageIndex = currentIndex
//        print("currentPageIndex in before: \(currentPageIndex)")
        
        if currentIndex == 0 {
            return nil
        } else {
            return pages[currentIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        print("viewControllerAfter")
        
        guard let currentViewController = viewController as? PageContentViewController else { return nil }
        guard let currentIndex = pages.firstIndex(of: currentViewController) else { return nil }
        
        // Needed for calculations in didScroll to synchronize moving of scrollView and slidingLine
        currentPageIndex = currentIndex
//        print("currentPageIndex in after: \(currentPageIndex)")
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        guard let nextVC = pendingViewControllers.first as? PageContentViewController else { return }
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        print("didFinishAnimating")
        isButtonTriggeredScroll = false

        
        // If page scroll was triggered by button tap, toggle isButtonTriggeredScroll and if next scroll will be triggered but user's swiping, logic in didScroll will perform to synchronize moving of scrollView and slidingLine
//        if isButtonTriggeredScroll == true {
//            isButtonTriggeredScroll = false
//            print("set to FALSE")
//        }

    }
    
//
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
//        return buttonsView.numberOfButtons
    }
    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return self.currentIndex
//    }
    
    
    
}

extension SearchResultsViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        print("scrollViewWillBeginDragging")
//        if isButtonTriggeredScroll == true {
//            isButtonTriggeredScroll = false
//        }
        
        isButtonTriggeredScroll = false

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        print("scrollViewDidEndDecelerating")
        // If page scroll was triggered by button tap, toggle isButtonTriggeredScroll and if next scroll will be triggered but user's swiping, logic in didScroll will perform to synchronize moving of scrollView and slidingLine
        if isButtonTriggeredScroll == true {
            isButtonTriggeredScroll = false
        }
        
        buttonsScrollOffsetX = buttonsView.scrollView.contentOffset.x
        print("set buttonsScrollOffsetX in scrollViewDidEndDecelerating: \(buttonsScrollOffsetX)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollViewDidScroll")
//        print("contentOffset: \(scrollView.contentOffset.x)")
        
        
        guard !isButtonTriggeredScroll else { return }
//        print("LOGIC IS PERFORMING with currentPageIndex \(currentPageIndex), contentOffset: \(scrollView.contentOffset.x)")
//        print("isButtonTriggeredScroll is \(isButtonTriggeredScroll)")
        
        let currentOffsetX = scrollView.contentOffset.x
        
        let pageWidth = view.bounds.size.width
        
        let isScrollingForward = currentOffsetX > pageWidth
//        print("isScrollingForward: \(isScrollingForward)")
        
        let difference = currentOffsetX - pageWidth
        
        guard difference != 0 else { return }
        
        let currentButton = buttonsView.scopeButtons[currentPageIndex]
        
        var buttonWidth: CGFloat
        
        if isScrollingForward {
            buttonWidth = currentButton.bounds.size.width
        } else {
            if currentPageIndex == 0 {
                buttonWidth = buttonsView.scopeButtons[0].bounds.size.width
            } else {
                let previousButton = buttonsView.scopeButtons[currentPageIndex - 1]
                buttonWidth = previousButton.bounds.size.width
            }
        }
        
        
        
 
        
        
        let scrollViewWidthToMove = buttonsView.partOfUnvisiblePart
        var newOffset = difference / pageWidth * scrollViewWidthToMove

        print("part: \(newOffset)")
        
        let initialOffset = buttonsScrollOffsetX
        var calculatedNewOffset = initialOffset + newOffset
        
        if calculatedNewOffset < 0 {
            calculatedNewOffset = 0
        }
        
        if calculatedNewOffset > buttonsView.scrollView.contentSize.width {
            calculatedNewOffset = buttonsView.scrollView.contentSize.width
        }

        
        buttonsView.scrollView.setContentOffset(CGPoint(x: calculatedNewOffset, y: 0), animated: false)
        print("offset set to \(calculatedNewOffset)")

        
        
        
        
        

        var slidingLineX = difference / pageWidth * buttonWidth
        
        if currentPageIndex == 0 && isScrollingForward == false {
            slidingLineX = -slidingLineX
        }

        let currentButtonInitialConstant = currentButton.frame.origin.x
        
//        buttonsView.slidingLineLeadingAnchor.constant = slidingLineX
        
        if currentPageIndex == 0 && !isScrollingForward {
            buttonsView.slidingLineLeadingAnchor.constant = -(currentButtonInitialConstant + slidingLineX)
        } else {
            buttonsView.slidingLineLeadingAnchor.constant = currentButtonInitialConstant + slidingLineX
        }
//        print("CONSTANT: \(buttonsView.slidingLineLeadingAnchor.constant)")
 
    }
}


// MARK: - Helper methods
extension SearchResultsViewController {
    
//    func goToSpecificPage(index: Int, ofViewControllers pages: [PageContentViewController]) {
//        pageController?.setViewControllers([pages[index]], direction: .forward, animated: true)
//    }
    
    private func goToSpecificPage(index: Int) {
        pageController?.setViewControllers([pages[index]], direction: .forward, animated: true)
    }
    
    func revertToInitialAppearance() {
        goToSpecificPage(index: 0)
        buttonsView.revertToInitialAppearance()
    }
    
    private func setupPageController() {
        self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        
        self.pageController?.dataSource = self
        self.pageController?.delegate = self
        
        guard let pageVCSubviews = self.pageController?.view.subviews else { return }
        for view in pageVCSubviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        
        self.pageController?.view.backgroundColor = Utils.customBackgroundColor
 
        let initialVC = pages[0]
        
        self.pageController?.setViewControllers([initialVC], direction: .forward, animated: true)
        
        guard let pageController = pageController else { return }
        self.view.addSubview(pageController.view)
        self.addChild(pageController)
        pageController.didMove(toParent: self)
        
    }
    
    private func configureButtonsView() {
        // Respond to button actions in buttonsView
        buttonsView.callBack = { [weak self] buttonIndex in
            guard let self = self else { return }
            
            // To avoid logic in didScroll to perform if page scroll is triggered by button tap
            self.currentPageIndex = buttonIndex
            self.buttonsScrollOffsetX = self.buttonsView.scrollView.contentOffset.x
//            print("CURRENT buttonIndex IS \(self?.currentPageIndex)")
            self.isButtonTriggeredScroll = true
            self.goToSpecificPage(index: buttonIndex)
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
    
    private func applyConstraints() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        // Constant 1 added to hide border of buttonsView on sides
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            buttonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: SearchResultsButtonsView.viewHeight)
        ])
        
        guard let pageVCView = self.pageController?.view else { return }
        pageVCView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageVCView.topAnchor.constraint(equalTo: buttonsView.bottomAnchor),
            pageVCView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageVCView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageVCView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
