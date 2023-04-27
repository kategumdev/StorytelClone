//
//  DimViewAnimationButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/3/23.
//

import UIKit

typealias DimViewCellButtonDidTapCallback = (Any) -> ()

class DimViewCellButton: UIButton {
    // MARK: - Instance properties
    var buttonTimer: Timer?
    var isButtonTooLongInHighlightedState = false

    // Owning view injects one of these 3 dependencies as needed
    var book: Book?
    var sectionKind: SectionKind?
    var categoryButton: ButtonCategory?
    
//    var callback: ButtonCallback = {_ in}
    var dimViewCellButtoDidTapCallback: DimViewCellButtonDidTapCallback = {_ in}
    #warning("Maybe replace Any with smth else")
    
    weak var viewToTransform: UIView?
    
    private lazy var dimViewForAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
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
    
    // MARK: - Instance methods
    func addConfigurationUpdateHandlerWith(viewToTransform: UIView) {
        // Save passed view from argument as weak property
        self.viewToTransform = viewToTransform
        viewToTransform.addSubview(dimViewForAnimation)
        dimViewForAnimation.translatesAutoresizingMaskIntoConstraints = false
        dimViewForAnimation.fillSuperview()
        
        self.configurationUpdateHandler = { [weak self] _ in
            guard let self = self,
            let transformView = self.viewToTransform else { return }
            
            if self.isHighlighted {
                print("button is highlighted")

                UIView.animate(withDuration: 0.1, animations: {
                    transformView.transform = CGAffineTransform(scaleX: 0.93, y: 0.93)
                    self.dimViewForAnimation.alpha = 0.1
                })
                let timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
                    if self.isHighlighted {
                        print("Button held for more than 2 seconds, do not perform action")
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
        layer.cornerRadius = Constants.bookCoverCornerRadius
        clipsToBounds = true

        var config = UIButton.Configuration.plain()
        config.background.imageContentMode = .scaleAspectFill
        
        // This prevents from dynamic cornerRadius and button.layer.cornerRadius works
        config.background.cornerRadius = 0
        configuration = config
        
        self.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }

            if self.isButtonTooLongInHighlightedState {
//                print("do nothing on touchUpInside")
                self.isButtonTooLongInHighlightedState = false

            } else {
                // Invalidate the timer and perform the touchUpInside action
                self.buttonTimer?.invalidate()
//                print("DO smth on touchUpInside")
                if let book = self.book {
                    self.dimViewCellButtoDidTapCallback(book)
                } else if let sectionKind = self.sectionKind {
                    self.dimViewCellButtoDidTapCallback(sectionKind)
                } else if let categoryButton = self.categoryButton {
                    self.dimViewCellButtoDidTapCallback(categoryButton)
                }
            }

        }), for: .touchUpInside)
    }
}
