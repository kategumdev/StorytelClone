//
//  BookOverviewStackView.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 24/3/23.
//

import UIKit

class BookOverviewStackView: UIStackView {
    
    private let book: Book

    private let mainTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredCustomFontWith(weight: .regular, size: 16) // Set the font size for the text view
        textView.isScrollEnabled = false // Disable scrolling so the text view can grow vertically
        textView.textColor = .label
        textView.textAlignment = .left
        textView.text = "«Ningún escritor del género ha aprovechado tanto como Tolkien las propiedades características de la Misión, el viaje heróico, el Objeto Numinoso, satisfaciendo nuestro sentido de la realidad histórica y social… Tolkien ha triunfado donde fracasó Milton.» —W.H. Auden\n«La invención de los pueblos extraños, incidentes curiosos u hechos maravillosos es en este segundo volumen de la trilogía tan exuberante y convincente como siempre. A medida que avanza la historia, el mundo del Anillo crece en dimensión y misterio, poblado por figuras curiosas, terroríficas, adorables o divertidas. La historia misma es soberbia.» —The Observer"
        return textView
    }()
    
    private let releasePublisherTextView: UITextView = {
        let textView = UITextView()
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        textView.isScrollEnabled = false // Disable scrolling so the text view can grow vertically
        textView.textColor = .secondaryLabel
        textView.textAlignment = .right
        textView.text = "Audiobook\nRelease: 25 Jan 2023\nPublisher: Planeta Audio"
        return textView
    }()
    
    private let translatorsTextView: UITextView = {
        let textView = UITextView()
        let font = UIFont.preferredCustomFontWith(weight: .semibold, size: 13)
        textView.isScrollEnabled = false // Disable scrolling so the text view can grow vertically
        textView.textColor = .secondaryLabel
        textView.textAlignment = .right
        textView.text = "Translators\nMatilde Horner, Luis Doménech"
        return textView
    }()
    
    init(book: Book) {
        self.book = book
        super.init(frame: .zero)
        axis = .vertical
        alignment = .center
        [mainTextView, releasePublisherTextView, translatorsTextView].forEach { addArrangedSubview($0)}
        applyConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        
       
        
//        guard let superview = superview else { return }
        
        
        let textViews = [mainTextView, releasePublisherTextView, translatorsTextView]
        
        for textView in textViews {
            textView.translatesAutoresizingMaskIntoConstraints = false
            // Calculate height
            let width = bounds.width - Constants.cvPadding * 2
            let size = textView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
            let height = size.height
            NSLayoutConstraint.activate([
                textView.heightAnchor.constraint(equalToConstant: height),
                textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2)
            ])
        }
        
        // Set stack view height
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: topAnchor),
            translatorsTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
//        mainTextView.translatesAutoresizingMaskIntoConstraints = false
//        // Calculate height for mainTextView
//        let mainTextViewSize = mainTextView.sizeThatFits(CGSize(width: bounds.width - Constants.cvPadding * 2, height: .greatestFiniteMagnitude))
//        let mainTextViewHeight = mainTextViewSize.height
//        NSLayoutConstraint.activate([
//            mainTextView.heightAnchor.constraint(equalToConstant: mainTextViewHeight),
//            mainTextView.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.cvPadding * 2)
//        ])
//
//        releasePublisherTextView.translatesAutoresizingMaskIntoConstraints = false
//        let releasePublisherTextViewSize = releasePublisherTextView.sizeThatFits(CGSize(width: bounds.width - Constants.cvPadding * 2, height: .greatestFiniteMagnitude))
//        let releasePublisherTextViewHeight = releasePublisherTextViewSize.height
//
    }
    

}
