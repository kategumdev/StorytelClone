//
//  scopeButtonsViewSearchResults.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 7/3/23.
//

import UIKit

class ScopeButtonsViewSearchResults: UIScrollView {
    
    static let buttonKinds: [ButtonKind] = [.top, .books, .authors, .narrators, .series, .tags]
    
    enum ButtonKind: String {
        case top = "Top"
        case books = "Books"
        case authors = "Authors"
        case narrators = "Narrators"
        case series = "Series"
        case tags = "Tags"
    }

    let scopeButtons: [UIButton] = {
       var buttons = [UIButton]()
       
        for kind in buttonKinds {
            let button = UIButton()
            button.setTitle(kind.rawValue, for: .normal)
            button.titleLabel?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 16)
            
            if kind == .top {
                button.setTitleColor(Utils.tintColor, for: .normal)
            } else {
                button.setTitleColor(UIColor.label, for: .normal)
            }
            
            button.sizeToFit()
            buttons.append(button)
        }
        return buttons
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
//        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 33
        scopeButtons.forEach { stack.addArrangedSubview($0) }
        return stack
    }()
    
//    lazy var separatorLine: CALayer = {
//        let separatorLine = CALayer()
//        separatorLine.frame = CGRect(x: 0, y: bounds.size.height - 1, width: bounds.size.width, height: 3)
//        separatorLine.backgroundColor = UIColor.black.cgColor
//
//
//
//        return separatorLine
//    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        showsHorizontalScrollIndicator = false
        
        contentInset = UIEdgeInsets(top: 0, left: Constants.cvPadding, bottom: 0, right: Constants.cvPadding)
        applyConstraints()
        

//        layer.addSublayer(separatorLine)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
//        translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            stackView.heightAnchor.constraint(equalTo: contentLayoutGuide.heightAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentLayoutGuide.trailingAnchor),
            
//
//            stackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
            stackView.heightAnchor.constraint(equalTo: frameLayoutGuide.heightAnchor)
        ])
        
    }
    
    
    
    
    
//    private let scopeButtonsView: UIScrollView = {
//        let scrollView = UIScrollView()
//        let button = UIButton()
//        button.titleLabel?.font = UIFont.preferredCustomFontWith(weight: .medium, size: 18)
//        button.sizeToFit()
//
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.alignment = .center
//
//        let buttons: [UIButton]
//
//
//    }()


}
