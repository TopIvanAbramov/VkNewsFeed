//
//  NewsfeedTableViewCell.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 04.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit
import SkeletonView

protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String  { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    var photoAttachements: [FeedCellPhotoAttachementViewModel] { get }
    var linkAttachment: FeedCellLinkAttachmentViewModel? { get }
    var sizes: FeedCellSizes { get }
}

protocol FeedCellPhotoAttachementViewModel {
    var photoURLString: String? {  get }
    var width: Int {  get }
    var height: Int {  get }
}

protocol FeedCellSizes {
    var postLabelFrame:  CGRect { get }
    var showMoreTextButtonFrame:  CGRect {  get }
    var attachementFrame: CGRect {  get }
    var bottomViewFrame:  CGRect {  get }
    var totalHeight: CGFloat {  get }
}

protocol ShowMoreButtonDelegate {
    func showMoreTextTapped(for cell: NewsfeedTableViewCell)
}

class NewsfeedTableViewCell: UITableViewCell {

    static let cellId = "NewsfeedTableViewCell"
    var showMoreButtonDelegate: ShowMoreButtonDelegate?
    private var viewModel: FeedCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        iconImageView.clipsToBounds = true
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 3
        
        let cellNib = UINib(nibName: "GalleryCollectionViewCell", bundle: nil)
        self.galleryCollectionView.register(cellNib, forCellWithReuseIdentifier: "GalleryCollectionViewCell")
        
        galleryCollectionView.backgroundColor = .systemBackground
        
        setupTextView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UITextView!
    @IBOutlet weak var showMoreTextButton: UIButton!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var photoAttachement: WebImageView!
    @IBOutlet weak var linkAttachement: LinkAttachment!
    @IBOutlet weak var galleryCollectionView: GalleryCollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    func set(viewModel: FeedCellViewModel) {
        self.viewModel = viewModel
        
        self.iconImageView.set(imageUrl: viewModel.iconUrlString)
        self.nameLabel.text = viewModel.name
        self.dateLabel.text = viewModel.date
        self.postLabel?.text = viewModel.text
        self.likesLabel.text = viewModel.likes
        self.commentsLabel.text = viewModel.comments
        self.sharesLabel.text = viewModel.shares
        self.viewsLabel.text = viewModel.views
        
        if let firstPhoto = viewModel.photoAttachements.first, viewModel.photoAttachements.count == 1 {
            self.photoAttachement.set(imageUrl: firstPhoto.photoURLString)
            
            self.photoAttachement.isHidden = false
            self.galleryCollectionView.isHidden = true
            self.linkAttachement.isHidden = true
            
            
            
        } else if viewModel.photoAttachements.count > 1 {
            self.galleryCollectionView.frame = viewModel.sizes.attachementFrame
            
            self.galleryCollectionView.set(photos: viewModel.photoAttachements)
            
            self.photoAttachement.isHidden = true
            self.galleryCollectionView.isHidden = false
            self.linkAttachement.isHidden = true
            
            self.galleryCollectionView.delegate = self
            self.galleryCollectionView.dataSource = self
            self.galleryCollectionView.contentOffset = CGPoint(x: 5, y: 0)
            
            galleryCollectionView.reloadData()
            
        } else if let linkAttachmentViewModel = viewModel.linkAttachment {
            
            guard viewModel.photoAttachements.count == 0  else { print("Shit is going on"); return }
            self.linkAttachement.frame = viewModel.sizes.attachementFrame
            
            self.linkAttachement.isHidden = false
            self.photoAttachement.isHidden = true
            self.galleryCollectionView.isHidden = true
            
            self.linkAttachement.set(viewModel: linkAttachmentViewModel)
        } else {
            self.linkAttachement.isHidden = true
            self.photoAttachement.isHidden = true
            self.galleryCollectionView.isHidden = true
        }
        
        postLabel.frame = viewModel.sizes.postLabelFrame
        photoAttachement.frame = viewModel.sizes.attachementFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        showMoreTextButton.frame = viewModel.sizes.showMoreTextButtonFrame
        
//        self.galleryCollectionView.showAnimatedGradientSkeleton()
        
//        galleryCollectionView.reloadData()
    }
    
    override func prepareForReuse() {
        self.iconImageView.set(imageUrl: nil)
        self.photoAttachement.set(imageUrl: nil)
        self.linkAttachement.imageView.set(imageUrl: nil)
//        
        self.linkAttachement.isHidden = true
        self.galleryCollectionView.isHidden = true
        self.photoAttachement.isHidden = true
    }
    
    
    @IBAction func showMoreTextTapped(_ sender: Any) {
        showMoreButtonDelegate?.showMoreTextTapped(for: self)
    }
    
    func setupTextView() {
        postLabel.font = Constans.postLabelFont
        
        let padding = postLabel.textContainer.lineFragmentPadding
        postLabel.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
    }
}

//  MAKR:- UICollectionViewDelegate & UICollectionViewDataSource

extension NewsfeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.photoAttachements.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.galleryCollectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        
        guard let photo = viewModel?.photoAttachements[indexPath.row] else {
            print("No photos")
            return cell
        }
        
        cell.set(photo: photo)
        
//        cell.hideSkeleton()
//        cell.stopSkeletonAnimation()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard viewModel?.photoAttachements.count ?? 0 >= indexPath.row,
            let photo = viewModel?.photoAttachements[indexPath.row]
        else {
            return CGSize(width: 0, height: 0)
        }
        
        let ratio = CGFloat(photo.width) / CGFloat(photo.height)
        
        var height = viewModel!.sizes.attachementFrame.height
        
        let width = CGFloat(height) * ratio - Constans.photoAttachementlInsets.left - Constans.photoAttachementlInsets.right
        
        height = height - Constans.photoAttachementlInsets.top - Constans.photoAttachementlInsets.bottom
        
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension NewsfeedTableViewCell: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "GalleryCollectionViewCell"
    }
    
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
}
