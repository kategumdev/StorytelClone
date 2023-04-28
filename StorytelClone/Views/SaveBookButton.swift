//
//  SaveBookButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/4/23.
//

import UIKit

typealias SaveBookButtonDidTapCallback = (Bool) -> ()

class SaveBookButton: UIButton {
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = UIColor.label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    func toggleImage(isBookAdded: Bool) {
        let newImageName = isBookAdded ? "heart.fill" : "heart"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        let newImage = UIImage(systemName: newImageName, withConfiguration: symbolConfig)
        self.setImage(newImage, for: .normal)
    }
    
    func animateImageView(withCompletion completion: ((Bool) -> Void)?) {
        let imageView = self.imageView!
        // Set the initial transform of the view
        imageView.transform = CGAffineTransform.identity
        
        UIView.animateKeyframes(withDuration: 0.6, delay: 0, options: [.calculationModeCubic, .beginFromCurrentState], animations: {

            let duration1 = 0.15 // shorter duration for 1st keyframe
            let duration2 = 0.4 // longer duration for 2nd and 3rd keyframes
            let duration4 = 0.15 // shorter duration for 4th keyframe

            // First keyframe: animate to 30% of initial size
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration1) {
                imageView.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }

            // Second keyframe: animate back to 100% of initial size with longer duration
            UIView.addKeyframe(withRelativeStartTime: duration1, relativeDuration: duration2) {
                imageView.transform = CGAffineTransform.identity
            }

            // Third keyframe: animate to 50% of initial size with the same duration as 2nd keyframe
            UIView.addKeyframe(withRelativeStartTime: duration1 + duration2, relativeDuration: duration2) {
                imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            }

            // Fourth keyframe: animate back to 100% of initial size with spring animation
            UIView.addKeyframe(withRelativeStartTime: duration1 + duration2 + duration2, relativeDuration: duration4) {
                imageView.transform = CGAffineTransform.identity
            }
            
            UIView.animate(withDuration: duration4, delay: 0.0, usingSpringWithDamping: 0.2, initialSpringVelocity: 6.0, options: [.allowUserInteraction], animations: {
                imageView.transform = CGAffineTransform.identity
            }, completion: nil )

        }, completion: completion)
    }

}
