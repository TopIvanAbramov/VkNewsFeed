//
//  Constants.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 18.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation
import UIKit

struct Constans {
    static let cardInsets = UIEdgeInsets(top: 9, left: 8, bottom: 8, right: 9)
    static let topViewHeight : CGFloat = 46
    static let postLabelInsets = UIEdgeInsets(top: 8 + topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let showMoreTextButtonInsets =  UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0)
    
    static let bottomViewHeight : CGFloat = 44
    
    static let maximalLinesLimit: CGFloat = 8
    static let showMoreButtonFont = UIFont.systemFont(ofSize: 16)
    static let showMoreTextButtonSize: CGSize = CGSize(width: 175, height: 30)
    
    static let photoAttachementlInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    static let linkAttachementInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
}
