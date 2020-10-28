//
//  NewsFeedCellLayoutCalculator.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 15.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation
import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func size(postText: String?, photoAttachements: [FeedCellPhotoAttachementViewModel], linkAttachment: FeedCellLinkAttachmentViewModel?, isCellFullSize: Bool) -> FeedCellSizes
}

final class NewsFeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth : CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    struct Sizes: FeedCellSizes {
        var postLabelFrame: CGRect
        var attachementFrame: CGRect
        var bottomViewFrame: CGRect
        var totalHeight: CGFloat
        var showMoreTextButtonFrame: CGRect
    }
    
    func size(postText: String?, photoAttachements: [FeedCellPhotoAttachementViewModel], linkAttachment: FeedCellLinkAttachmentViewModel?, isCellFullSize: Bool) -> FeedCellSizes {
        
        var showMoreButtonIsVisible: Bool = false
        
        let cardViewWidth = screenWidth - Constans.cardInsets.left -  Constans.cardInsets.right
        
//        MARK: postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(
            x: Constans.postLabelInsets.left,
            y: Constans.postLabelInsets.top),
            size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constans.postLabelInsets.left -  Constans.postLabelInsets.right
            var height = text.height(width: width, font: Constans.postLabelFont)
            let limitHeight = ceil(Constans.maximalLinesLimit * Constans.postLabelFont.lineHeight)
            
            if !isCellFullSize && height > limitHeight {
                showMoreButtonIsVisible = true
                height = limitHeight
            }

            
            postLabelFrame.size = CGSize(width: width, height: height)
        }
  
//        MARK: showMoreTextButtonFrame
        
        var showMoreTextButtonFrame = CGRect(origin: CGPoint(
                                        x: Constans.showMoreTextButtonInsets.left,
                                        y: postLabelFrame.maxY),
                                        size: CGSize(width: 0, height: 0))
        
        if showMoreButtonIsVisible {
            showMoreTextButtonFrame.size = Constans.showMoreTextButtonSize
        }
        
//        MARK: attachementFrame
        
        let attachementTop = postLabelFrame.size ==  CGSize.zero ? Constans.postLabelInsets.top : showMoreTextButtonFrame.maxY + Constans.postLabelInsets.bottom
        
        var attachementFrame = CGRect(origin: CGPoint(
        x: 0,
        y: attachementTop),
        size: CGSize.zero)
        
        if let firstPhoto = photoAttachements.first, photoAttachements.count == 1 {
            let ratio = CGFloat(firstPhoto.height) / CGFloat(firstPhoto.width)
            let width: CGFloat = cardViewWidth
            let height =  ratio * width
            
            attachementFrame.size = CGSize(width: width, height: height)
            
        } else if photoAttachements.count > 1 {
            let width: CGFloat = cardViewWidth
            let height =  rowHeight(photos: photoAttachements, screenWidth: cardViewWidth)
            
            attachementFrame.size = CGSize(width: width, height: height)
        } else if linkAttachment != nil {
            let ratio: CGFloat = 1.5
            let width: CGFloat = cardViewWidth
            let height =  width / ratio
            
            attachementFrame.size = CGSize(width: width, height: height)
            attachementFrame.inset(by: Constans.photoAttachementlInsets)
        }
        
        
//        MARK: bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachementFrame.maxY)
        
        let bottomViewFrame = CGRect(x: 0,
                                     y: bottomViewTop,
                                     width: cardViewWidth,
                                     height: Constans.bottomViewHeight)
//        MARK: totalHeight
        
        let totalHeight = bottomViewFrame.maxY + Constans.cardInsets.bottom +  Constans.cardInsets.top
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachementFrame: attachementFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight,
                     showMoreTextButtonFrame: showMoreTextButtonFrame)
    }
    
    private func rowHeight(photos: [FeedCellPhotoAttachementViewModel], screenWidth: CGFloat) -> CGFloat {
        
        let minRationphoto = photos.min { (firstPhoto, secondPhoto) -> Bool in
            CGFloat(firstPhoto.height) / CGFloat(firstPhoto.width) < CGFloat(secondPhoto.height) / CGFloat(secondPhoto.width)
        }
        
        guard let myMinRationphoto = minRationphoto else {
            return 0
            
        }
        
        let difference = screenWidth / CGFloat(myMinRationphoto.width)
        let rowHeight = difference * CGFloat(myMinRationphoto.height)
        
        return rowHeight
    }
}
