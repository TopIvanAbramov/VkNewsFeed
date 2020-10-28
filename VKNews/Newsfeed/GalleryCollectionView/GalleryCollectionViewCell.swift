//
//  GalleryCollectionViewCell.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 17.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: WebImageView!
    
    override func awakeFromNib() {
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func set(photo: FeedCellPhotoAttachementViewModel) {
        self.imageView.set(imageUrl: photo.photoURLString)
    }
    
    override func prepareForReuse() {
        self.imageView.set(imageUrl: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.cornerRadius = 10
        self.imageView.clipsToBounds = true
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5
    }
}
