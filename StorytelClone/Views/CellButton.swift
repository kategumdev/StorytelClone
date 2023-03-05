//
//  DimViewAnimationButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/3/23.
//

import UIKit

class CellButton: UIButton {

    var buttonTimer: Timer?
    var isButtonTooLongInHighlightedState = false

    // Owning view injects this dependency as needed
    var book: Book? {
        didSet {
            configuration?.background.image = book?.coverImage
        }
    }
    // Owning view injects this dependency as needed
    var sectionKind: SectionKind?
    
    // Owning view injects this dependency as needed
    var categoryButton: ButtonCategory?
    
    // Owning view injects this dependency as needed
//    var callbackClosure: BookButtonCallbackClosure = {_ in}
//
//    // Owning view injects this dependency as needed
//    var wideButtonCallbackClosure: WideButtonCallbackClosure = {_ in}
//
//    // Owning view injects this dependency as needed
//    var categoryButtonCallbackClosure: CategoryButtonCallbackClosure = {_ in}

    var callback: ButtonCallbackClosure = {_ in}

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
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
                print("do nothing on touchUpInside")
                self.isButtonTooLongInHighlightedState = false

            } else {
                // Invalidate the timer and perform the touchUpInside action
                self.buttonTimer?.invalidate()
                print("DO smth on touchUpInside")
                
                if let book = self.book {
                    self.callback(book)
                } else if let sectionKind = self.sectionKind {
                    self.callback(sectionKind)
                } else if let categoryButton = self.categoryButton {
                    self.callback(categoryButton)
                }
            }

        }), for: .touchUpInside)
    }

}
