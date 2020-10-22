//
//  UIViewController + Storyboard.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 01.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard.init(name: name, bundle: nil)
        
        if let viewController = storyboard.instantiateInitialViewController() as? T {
            return viewController
        } else {
            fatalError("No initial viewController in \(name) storyboard")
        }
    }
}
