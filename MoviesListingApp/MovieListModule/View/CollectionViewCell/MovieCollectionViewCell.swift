//
//  MovieCollectionViewCell.swift
//  MoviesListingApp
//
//  Created by tanuj on 12/10/19.
//  Copyright © 2019 Tanuj Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    func configUIWithData (searchdataSource: Search)
    {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: searchdataSource.poster))
        movieTitle.text = searchdataSource.title
    }
}
