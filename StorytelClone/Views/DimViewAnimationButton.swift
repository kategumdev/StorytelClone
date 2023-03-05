//
//  DimViewAnimationButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 4/3/23.
//

import UIKit

class DimViewAnimationButton: UIButton {
    
    private var scaleForTransform: CGFloat
    
    private var buttonTimer: Timer?
    private var isButtonTooLongInHighlightedState = false
    
    private lazy var castViewForButtonAnimation: UIView = {
        let view = UIView()
        view.backgroundColor = Utils.customBackgroundColor
        return view
    }()

    // Owning view must inject this dependency when configuring button
    var book: Book? {
        didSet {
            configuration?.background.image = book?.coverImage
        }
    }
    
    // Owning view must inject this dependency when configuring button
    var callbackClosure: BookButtonCallbackClosure = {_ in}
    
    init(scaleForTransform: CGFloat) {
        self.scaleForTransform = scaleForTransform
        super.init(frame: .zero)
        configureButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        addSubview(castViewForButtonAnimation)
        castViewForButtonAnimation.fillSuperview()
        
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
                
                // Call closure passed to this cell by owning controller
                guard let book = self.book else { return }
                self.callbackClosure(book)
            }

        }), for: .touchUpInside)

        self.configurationUpdateHandler = { [weak self] theButton in
            guard let self = self else { return }
            if theButton.isHighlighted {
                print("button is highlighted")
                
                UIView.animate(withDuration: 0.1, animations: {
                    
                    self.transform = CGAffineTransform(scaleX: self.scaleForTransform, y: self.scaleForTransform)
                    self.castViewForButtonAnimation.alpha = 0.1
                    
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
                    
                    self.transform = .identity
                    self.castViewForButtonAnimation.alpha = 0
                    
                })
            }
        }
    }

}
