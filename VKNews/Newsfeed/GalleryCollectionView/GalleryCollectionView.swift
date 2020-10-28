//
//  GalleryCollectionView.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 17.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit
import Foundation
import SkeletonView

class GalleryCollectionView: UICollectionView {
    private var photos : [FeedCellPhotoAttachementViewModel] = []
    
    func set(photos: [FeedCellPhotoAttachementViewModel]) {
        self.photos = photos
    }
    
//    init(frame: CGRect) {
//        let layout = UICollectionViewLayout()
//        super.init(frame: frame, collectionViewLayout: layout)
//
//        delegate = self
//        dataSource = self
//    }
//
//    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
////        super.init(frame: frame, collectionViewLayout: layout)
////        super.init()
//
//        delegate = self
//        dataSource = self
//    }
    
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    required init?(frame: CGRect, layout: UICollectionViewLayout) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override class func awakeFromNib() {
//        self.register(UINib(nibName: String(describing: GalleryCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: GalleryCollectionViewCell.self))
//        self.delegate
        
//        self.registe
        
        print("Awake from nib")

    }
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print("Count")
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCollectionViewCell.self), for: indexPath) as! GalleryCollectionViewCell
        
        print("This func")
//        cell.set(photo: photos[indexPath.row])
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        return CGSize(width: 200, height: se);
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: 200, height: 200);
//    }
}

//extension GalleryCollectionView: SkeletonCollectionViewDataSource {
//
//  func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> //ReusableCellIdentifier {
 //       return "GalleryCollectionViewCell"
//    }
//
 //   func numSections(in collectionSkeletonView: UICollectionView) -> Int {
 //       return 1
 //   }

 //   func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
 //       return 5
//    }
//}
