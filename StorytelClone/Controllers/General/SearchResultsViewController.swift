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
        
        currentPageIndex = currentIndex
        print("currentPageIndex set: \(currentPageIndex)")
        
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
        
        currentPageIndex = currentIndex
        print("currentPageIndex set: \(currentPageIndex)")
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return nil
        }

    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let nextVC = pendingViewControllers.first as? PageContentViewController else { return }
    
//        guard let nextVCIndex = pages.firstIndex(of: nextVC) else { return }
//        let nextVCIndexInt = nextVCIndex + 0
//        currentPageIndex = nextVCIndexInt
//        print("pageViewController willTransitionTo cv \(String(describing: nextVC.textLabel.text))")
    }
    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//
//        guard let previousPage = previousViewControllers.last as? PageContentViewController, let previousPageIndex = pages.firstIndex(of: previousPage) else { return }
//        currentPageIndex = previousPageIndex
//    }
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("contentOffset: \(scrollView.contentOffset.x)")
        
        let currentOffsetX = scrollView.contentOffset.x
        
        let pageWidth = view.bounds.size.width
        
        let isScrollingForward = currentOffsetX > pageWidth
        print("isScrollingForward: \(isScrollingForward)")
        
        let difference = currentOffsetX - pageWidth
        
        guard difference != 0 else { return }
        
        let currentButton = buttonsView.scopeButtons[currentPageIndex]
        
        var buttonWidth: CGFloat
        
        if isScrollingForward {
            buttonWidth = currentButton.bounds.size.width
        } else if currentPageIndex == 0 {
            buttonWidth = -(buttonsView.scopeButtons[0].bounds.size.width)
        } else {
            let previousButton = buttonsView.scopeButtons[currentPageIndex - 1]
            buttonWidth = previousButton.bounds.size.width
        }
        
        
        
//        let currentButtonWidth = currentButton.bounds.size.width
        
        
        
        
        
//        if currentButtonIndex
        
//        if isScrollingForward {
//            locationToMoveTo = currentButton.frame.origin.x
//        } else if currentPageIndex == 0 {
//            locationToMoveTo = -(scopeButtons[0].bounds.size.width)
//        } else {
//            let previousButton = buttonsView.scopeButtons[currentPageIndex - 1]
//            locationToMoveTo = previousButton.frame.origin.x
//        }
        
        
//        let slidingLineX = difference / pageWidth * currentButtonWidth
        let slidingLineX = difference / pageWidth * buttonWidth

    
        
        
        let currentButtonInitialConstant = currentButton.frame.origin.x
        
        
//        let slidingLineCurrentConstant = buttonsView.slidingLineLeadingAnchor.constant
//        buttonsView.slidingLineLeadingAnchor.constant = slidingLineX
        buttonsView.slidingLineLeadingAnchor.constant = slidingLineX
//        print("slidingLineX: \(slidingLineX)")
        
        
        
        buttonsView.slidingLineLeadingAnchor.constant = currentButtonInitialConstant + slidingLineX
        
        
        
//        print("CONSTANT: \(buttonsView.slidingLineLeadingAnchor.constant)")
//        slidingLine.frame.origin.x = slidingLineX
        
        
        
        
        
//        let movePercentage = (difference * 100) / pageWidth
//        print("movePercentage: \(movePercentage)")
//
//        // Index of page in array equals index of button in array
//        let currentButton = buttonsView.scopeButtons[currentPageIndex]
//        let currentButtonWidth = currentButton.bounds.size.width
//        print("currentButtonWidth: \(currentButtonWidth)")
//
//        let pointsToMoveSlidingLine = (movePercentage / 100) * currentButtonWidth
//
//        print("BEFORE slidingLineLeadingAnchor: \(buttonsView.slidingLineLeadingAnchor.constant)")
//
//        let currentConstant = buttonsView.slidingLineLeadingAnchor.constant
////        buttonsView.slidingLineLeadingAnchor.constant = buttonsView.slidingLineLeadingAnchor.constant + pointsToMoveSlidingLine
//        buttonsView.slidingLineLeadingAnchor.constant = currentConstant + pointsToMoveSlidingLine
//        print("AFTER slidingLineLeadingAnchor: \(buttonsView.slidingLineLeadingAnchor.constant)")

        
        
        
        
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
            self?.goToSpecificPage(index: buttonIndex)
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
