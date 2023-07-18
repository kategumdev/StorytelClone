//
//  PopupButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 6/7/23.
//

import UIKit

protocol PopupButton where Self: UIButton {
    var buttonHeight: CGFloat { get }
    
    var animate: SaveBookButtonDidTapCallback { get set }
}
