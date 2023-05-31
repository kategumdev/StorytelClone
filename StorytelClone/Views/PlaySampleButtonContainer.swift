//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit
import AVFoundation


class PlaySampleButtonContainer: UIView {
    // MARK: - Static properties
    static let buttonHeight: CGFloat = RoundButtonsStack.roundWidth
    
    // MARK: - Instance properties
    var audioPlayer: AVPlayer?
    var isPlaying = false
    
    var audioUrlString: String?
    
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor.label
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
        return button
    }()
    
    private let customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        imageView.image = image
        return imageView
    }()

    private let customTitleLabel: UILabel = {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .semibold, maxPointSize: 40)
        let label = UILabel.createLabelWith(font: scaledFont, text: "Play a sample")
        return label
    }()

    private lazy var horzStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.addArrangedSubview(customImageView)
        stack.addArrangedSubview(customTitleLabel)
        return stack
    }()

    // MARK: - Initializers
    init(audioUrlString: String?) {
        self.audioUrlString = audioUrlString
        super.init(frame: .zero)
        backgroundColor = UIColor.customBackgroundColor
        addSubview(button)
        addButtonAction()
        button.addSubview(horzStack)
        applyConstraints()
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = UIColor.customBackgroundColor
//        addSubview(button)
//        button.addSubview(horzStack)
//        applyConstraints()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View life cycle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            button.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    // MARK: - Helper methods
    private func addButtonAction() {
        guard audioUrlString != nil else { return }
        print("adding button action")
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.handleButtonTapped()
          }), for: .touchUpInside)
    }
    #warning("it is not triggered when tapping on custom image and label views")
    
    private func handleButtonTapped() {
        if isPlaying {
            audioPlayer?.replaceCurrentItem(with: nil)
            audioPlayer = nil
            isPlaying = false
            toggleButtonImageAndText()
            return
        }
        
        if let urlString = audioUrlString,
           let url = URL(string: urlString) {
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
            print("play")
            audioPlayer?.play()
            isPlaying = true
            toggleButtonImageAndText()
        }
//            let audioURL = URL(string: "YOUR_AUDIO_URL_HERE")
    }
    
    private func toggleButtonImageAndText() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        if isPlaying {
            customImageView.image = UIImage(systemName: "stop.fill", withConfiguration: symbolConfig)
            customTitleLabel.text = ""
        } else {
            customImageView.image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
            customTitleLabel.text = "Play a sample"
        }
    }

    private func applyConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        horzStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horzStack.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            horzStack.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            horzStack.leadingAnchor.constraint(greaterThanOrEqualTo: button.leadingAnchor, constant: 10),
            horzStack.trailingAnchor.constraint(lessThanOrEqualTo: button.trailingAnchor, constant: -10)
        ])
    }
    
}
