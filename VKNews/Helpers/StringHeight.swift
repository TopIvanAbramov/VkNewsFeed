//
//  StringHeight.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 15.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation
import  UIKit

extension  String {
    
    func height(width: CGFloat, font: UIFont) -> CGFloat {
        let textSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let size = self.boundingRect(with: textSize,
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font : font],
                                     context: nil)
        
        return ceil(size.height)
    }
}
