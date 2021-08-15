//
//  AlbumViewCell.swift
//  AlbumSearcher
//
//  Created by Arina on 06.08.2021.
//

import UIKit
import Kingfisher

class AlbumViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    
    func setAlbumCell() {
        coverImageView.contentMode = .scaleAspectFill
        authorNameLabel.textColor = .systemGray
    }
    
    func setAlbumCover(for url: String) {
        let placeholderImage = UIImage(named: "white-square")
        let processor = DownsamplingImageProcessor(size: self.coverImageView.bounds.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        coverImageView.kf.indicatorType = .activity
        
        let url = URL(string: url)
        
        coverImageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
        ])
    }
    
    func setAlbumData(for album: Album) {
        albumNameLabel.text = album.collectionName
        authorNameLabel.text = album.artistName
    }
    
}
