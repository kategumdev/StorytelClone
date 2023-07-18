//
//  ImageDownloader.swift
//  StorytelClone
//
//  Created by Kateryna Gumenna on 11/7/23.
//

import Foundation

protocol ImageDownloader {
    
    /// Downloads and resizes images according to the passed subCategoryKind of the collection view.
    /// - Parameters:
    ///   - books: An array of Book objects for which images need to be downloaded.
    ///   - subCategoryKind: A kind of collection view which is used in this method to determine how to resize the downloaded image.
    ///   - completion: The only parameter is an array of Book objects.
    ///   Each object has its downloaded and resized image saved in a property.
    func downloadAndResizeImagesFor(
        books: [Book],
        subCategoryKind: SubCategoryKind,
        completion: @escaping (([Book]) -> Void)
    )
    
    func cancelDownloads()
}
