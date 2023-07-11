//
//  DefaultSDWebImageDownloader.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/7/23.
//

import Foundation
import SDWebImage

class DefaultSDWebImageDownloader: ImageDownloader {
    private let imageDownloader = SDWebImageDownloader()
    
    func downloadAndResizeImagesFor(books: [Book], subCategoryKind: SubCategoryKind, completion: @escaping (([Book]) -> Void)) {
        
        // Load and resize poster image
        guard subCategoryKind != .poster else {
            if let book = books.first, let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
                imageDownloader.downloadImage(with: imageURL) { image, data, error, success in
                    if let image = image {
                        let resizedImage = image.resizeFor(targetHeight: PosterTableViewCell.calculatedButtonHeight, andSetAlphaTo: 1)
                        var bookWithImage = book
                        bookWithImage.coverImage = resizedImage
                        completion([bookWithImage])
                    }
                }
            }
            return
        }
        
        // Load and resize images for other sub category kinds
        let downloadTaskGroup = DispatchGroup()
        
        // It will contain only books that have downloaded images
        var booksWithImages = [Book]()
        
        for book in books {
            if let imageURLString = book.imageURLString, let imageURL = URL(string: imageURLString) {
                downloadTaskGroup.enter()
                imageDownloader.downloadImage(with: imageURL) { image, data, error, success in
                    if let image = image {
                        var targetHeight: CGFloat
                        if subCategoryKind == .horzCv {
                            targetHeight = Constants.largeSquareBookCoverSize.height
                        } else {
                            // for sub category with large rectangle covers
                            targetHeight = LargeRectCoversTableViewCell.itemSize.height
                        }
                        let resizedImage = image.resizeFor(targetHeight: targetHeight, andSetAlphaTo: 1)
                        var bookWithImage = book
                        bookWithImage.coverImage = resizedImage
                        booksWithImages.append(bookWithImage)
                    }
                    downloadTaskGroup.leave()
                }
            }
        }
        
        downloadTaskGroup.notify(queue: DispatchQueue.main) {
            booksWithImages.shuffle()
            completion(booksWithImages)
        }
    }
    
    func cancelDownloads() {
        imageDownloader.cancelAllDownloads()
    }
    
    deinit {
        cancelDownloads()
    }
    
}
