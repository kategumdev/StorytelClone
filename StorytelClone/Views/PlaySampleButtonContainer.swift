//
//  PlaySampleButton.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 29/3/23.
//

import UIKit
import AVFoundation

// Container is needed to cover book description text beneath when in "compressed" appearance
class PlaySampleButtonContainer: UIView {
    // MARK: - Static properties
    static let buttonHeight: CGFloat = RoundButtonsStack.roundWidth
    
    // MARK: - Instance properties
    var audioPlayer: AVPlayer?
    var isPlaying = false
    var timer: Timer?
    var audioUrlString: String?
    
    private let button: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = PlaySampleButtonContainer.buttonHeight / 2
        
        var buttonConfig = UIButton.Configuration.plain()
        buttonConfig.contentInsets = .zero
        buttonConfig.titleAlignment = .leading
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        let image = UIImage(systemName: "play.fill", withConfiguration: symbolConfig)
        buttonConfig.image = image
        buttonConfig.imagePadding = 12
        button.configuration = buttonConfig
        return button
    }()

    // MARK: - Initializers
    init(audioUrlString: String?) {
        self.audioUrlString = audioUrlString
        super.init(frame: .zero)
        backgroundColor = UIColor.customBackgroundColor
        addSubview(button)
        setButtonTextAndImage()
        addButtonAction()
        applyConstraints()
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer?.invalidate()
        audioPlayer?.replaceCurrentItem(with: nil)
        audioPlayer = nil
        #warning("Not sure if it's necessary to nil out audioPlayer here")
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
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.isPlaying ? self.stopPlaying() : self.playAudio()
          }), for: .touchUpInside)
    }
    
    private func stopPlaying() {
        timer?.invalidate()
        audioPlayer?.replaceCurrentItem(with: nil)
        audioPlayer = nil
        isPlaying = false
        setButtonTextAndImage()
    }
    
    private func playAudio() {
        if let urlString = audioUrlString,
           let url = URL(string: urlString) {
            let playerItem = AVPlayerItem(url: url)
            audioPlayer = AVPlayer(playerItem: playerItem)
            audioPlayer?.play()
            isPlaying = true
            setButtonTextAndImage()
        }
    }

    private func setButtonTextAndImage() {
        let scaledFont = UIFont.createScaledFontWith(textStyle: .callout, weight: .semibold, maxPointSize: 40)

        let text = isPlaying ? "00:00 / 03:00" : "Play a sample"
        button.configuration?.attributedTitle = AttributedString(text)
        button.configuration?.attributedTitle?.font = scaledFont

        if isPlaying {
            var reversePlaybackInSeconds = 180
            var forwardPlaybackInSeconds = 0

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
                reversePlaybackInSeconds -= 1
                if reversePlaybackInSeconds == 0 {
                    self?.stopPlaying()
                    return
                }
                let minutesLeft = reversePlaybackInSeconds / 60
                let secondsLeft = reversePlaybackInSeconds % 60
                
                forwardPlaybackInSeconds += 1
                let minutesPlayed = forwardPlaybackInSeconds / 60
                let secondsPlayed = forwardPlaybackInSeconds % 60

                let timeString = String(format: "%02d:%02d / %02d:%02d", minutesPlayed, secondsPlayed, minutesLeft, secondsLeft)
                self?.button.configuration?.attributedTitle = AttributedString(timeString)
                self?.button.configuration?.attributedTitle?.font = scaledFont
            }
        }

        let imageName = isPlaying ? "stop.fill" : "play.fill"
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 19, weight: .semibold)
        let image = UIImage(systemName: imageName, withConfiguration: symbolConfig)
        button.configuration?.image = image
    }
    
    private func applyConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: PlaySampleButtonContainer.buttonHeight),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: -Constants.commonHorzPadding * 2),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
}
