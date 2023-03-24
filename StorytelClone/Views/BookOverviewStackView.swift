//
//  BookOverviewStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 24/3/23.
//

import UIKit

class BookOverviewStackView: UIStackView {
    
//    static func createSecondaryTextViewWith(text: String) -> UITextView {
//        let textView = UITextView()
//        textView.backgroundColor = .clear
//        textView.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        textView.isScrollEnabled = false
//        textView.textColor = .label.withAlphaComponent(0.8)
//        textView.textAlignment = .left
//        textView.text = text
//        return textView
//    }
    
    static func createSecondaryTextView() -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        textView.isScrollEnabled = false
        textView.textColor = .label.withAlphaComponent(0.8)
        textView.textAlignment = .left
//        textView.text = text
        return textView
    }
    
    private let book: Book

    private let mainTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.preferredCustomFontWith(weight: .regular, size: 16)
        textView.isScrollEnabled = false
        textView.textColor = .label
        textView.textAlignment = .left
//        textView.text = "«Ningún escritor del género ha aprovechado tanto como Tolkien las propiedades características de la Misión, el viaje heróico, el Objeto Numinoso, satisfaciendo nuestro sentido de la realidad histórica y social… Tolkien ha triunfado donde fracasó Milton.» —W.H. Auden\n«La invención de los pueblos extraños, incidentes curiosos u hechos maravillosos es en este segundo volumen de la trilogía tan exuberante y convincente como siempre. A medida que avanza la historia, el mundo del Anillo crece en dimensión y misterio, poblado por figuras curiosas, terroríficas, adorables o divertidas. La historia misma es soberbia.» —The Observer"
        return textView
    }()
    
    private lazy var mainTextViewHeightAnchor = mainTextView.heightAnchor.constraint(equalToConstant: 100)
    
//    private let releasePublisherTextView = createSecondaryTextViewWith(text: "Audiobook\nRelease: 25 Jan 2023\nPublisher: Planeta Audio")
    private let releasePublisherTextView = createSecondaryTextView()

    
//    private let releasePublisherTextView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .clear
//        textView.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        textView.isScrollEnabled = false
//        textView.textColor = .label.withAlphaComponent(0.8)
//        textView.textAlignment = .left
//        textView.text = "Audiobook\nRelease: 25 Jan 2023\nPublisher: Planeta Audio"
//        return textView
//    }()
    
    private lazy var releasePublisherTextViewHeightAnchor = releasePublisherTextView.heightAnchor.constraint(equalToConstant: 100)
    
//    private let translatorsTextView = createSecondaryTextViewWith(text: "Translators\nMatilde Horner, Luis Doménech")
    private let translatorsTextView = createSecondaryTextView()

    
//    private let translatorsTextView: UITextView = {
//        let textView = UITextView()
//        textView.backgroundColor = .clear
//        textView.font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
//        textView.isScrollEnabled = false
//        textView.textColor = .label.withAlphaComponent(0.8)
//        textView.textAlignment = .left
//        textView.text = "Translators\nMatilde Horner, Luis Doménech"
//        return textView
//    }()
    
    private lazy var translatorsTextViewHeightAnchor  = translatorsTextView.heightAnchor.constraint(equalToConstant: 100)
    
    private var isFirstTime = true
    
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        
        configureTextViews()
                
        [mainTextView, releasePublisherTextView, translatorsTextView].forEach { addArrangedSubview($0)}
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isFirstTime {
//            print("bounds width: \(bounds.width)")
            let mainTextViewConstant = calculateHeightFor(textView: mainTextView)
            mainTextViewHeightAnchor.constant = mainTextViewConstant
            
            let releasePublisherTextViewConstant = calculateHeightFor(textView: releasePublisherTextView)
            releasePublisherTextViewHeightAnchor.constant = releasePublisherTextViewConstant

            let translatorsTextViewConstant = calculateHeightFor(textView: translatorsTextView)
            translatorsTextViewHeightAnchor.constant = translatorsTextViewConstant
        } else {
            isFirstTime = false
        }

    }
    
    private func configureTextViews() {
        
        mainTextView.text = "«Ningún escritor del género ha aprovechado tanto como Tolkien las propiedades características de la Misión, el viaje heróico, el Objeto Numinoso, satisfaciendo nuestro sentido de la realidad histórica y social… Tolkien ha triunfado donde fracasó Milton.» —W.H. Auden\n«La invención de los pueblos extraños, incidentes curiosos u hechos maravillosos es en este segundo volumen de la trilogía tan exuberante y convincente como siempre. A medida que avanza la historia, el mundo del Anillo crece en dimensión y misterio, poblado por figuras curiosas, terroríficas, adorables o divertidas. La historia misma es soberbia.» —The Observer"
        releasePublisherTextView.text = "Audiobook\nRelease: 25 Jan 2023\nPublisher: Planeta Audio"
        translatorsTextView.text = "Translators\nMatilde Horner, Luis Doménech"
    }
    
    private func calculateHeightFor(textView: UITextView) -> CGFloat {
        let width = bounds.width - Constants.cvPadding * 2
        let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        let height = size.height
        return height
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        let textViews = [mainTextView, releasePublisherTextView, translatorsTextView]
        for textView in textViews {
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2).isActive = true
        }
        
        mainTextViewHeightAnchor.isActive = true
        releasePublisherTextViewHeightAnchor.isActive = true
        translatorsTextViewHeightAnchor.isActive = true
        
        // Set stack view height
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            translatorsTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Force layoutSubviews() second to get correct bounds.width for setting height of text views
        layoutIfNeeded()
    }

}
