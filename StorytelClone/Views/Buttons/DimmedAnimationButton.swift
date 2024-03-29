//
//  DimmedAnimationButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/3/23.
//

import UIKit

typealias DimmedAnimationBtnDidTapCallback = (_ controllerToPush: UIViewController) -> ()

class DimmedAnimationButton: UIButton {
    enum ButtonKind: Equatable {
        case toPushBookVcWith(Book)
        case toPushAllCategoriesVc
        case toPushCategoryVcForSeriesCategory
        case toPushCategoryVcForCategory(Category)
    }
    
    // MARK: - Instance properties
    var kind: ButtonKind?
    var buttonTimer: Timer?
    var isButtonTooLongInHighlightedState = false
    var didTapCallback: DimmedAnimationBtnDidTapCallback = {_ in}
    
    weak var viewToTransform: UIView?
    
    private lazy var dimViewForAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customBackgroundColor
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance method
    func addConfigurationUpdateHandlerWith(viewToTransform: UIView) {
        // Save passed viewToTransform into a weak property
        self.viewToTransform = viewToTransform
        
        viewToTransform.addSubview(dimViewForAnimation)
        dimViewForAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForAnimation.fillSuperview()
        
        self.configurationUpdateHandler = { [weak self] _ in
            guard let self = self,
            let transformView = self.viewToTransform else { return }
            
            if self.isHighlighted {

                UIView.animate(withDuration: 0.1, animations: {
                    transformView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        // The button is held for more than 2 seconds, avoid performing the action
                        self.isButtonTooLongInHighlightedState = true
                    }
                }
                self.buttonTimer = timer
            } else {
                UIView.animate(withDuration: 0.1, animations: {
                    transformView.transform = .identity
                    self.dimViewForAnimation.alpha = 0
                })
            }
        }
    }
    
    // MARK: - Helper methods
    private func configureSelf() {
        setupUI()
        
        self.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            if self.isButtonTooLongInHighlightedState {
                // The button is held more than 2 seconds, nothing needs to be done
                self.isButtonTooLongInHighlightedState = false
            } else {
                // Invalidate the timer and perform action
                self.buttonTimer?.invalidate()
                let controller = self.createControllerForCallback()
                self.didTapCallback(controller)
            }
        }), for: .touchUpInside)
    }
    
    private func setupUI() {
        layer.cornerRadius = Constants.commonBookCoverCornerRadius
        clipsToBounds = true

        var config = UIButton.Configuration.plain()
        config.background.imageContentMode = .scaleAspectFill
        
        // This prevents from dynamic cornerRadius, therefore button.layer.cornerRadius works
        config.background.cornerRadius = 0
        configuration = config
    }
    
    private func createControllerForCallback() -> UIViewController {
        guard let buttonKind = kind else { return UIViewController() }
        
        var controller: UIViewController
        switch buttonKind {
        case .toPushBookVcWith(let book):
            controller = BookViewController(book: book)
        case .toPushAllCategoriesVc:
            controller = AllCategoriesViewController(
                category: Category.todasLasCategorias,
                categoriesForButtons: Category.categoriesForAllCategories)
        case .toPushCategoryVcForSeriesCategory:
            controller = CategoryViewController(category: Category.series)
        case .toPushCategoryVcForCategory(let category):
            controller = CategoryViewController(category: category)
        }
        return controller
    }
}
