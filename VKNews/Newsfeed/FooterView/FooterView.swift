//
//  FooterView.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 19.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit

class FooterView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)
        contentView.frame =  self.bounds
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        activityIndicator.hidesWhenStopped = true
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
    }
    
    func stopAndSet(title: String) {
        self.activityIndicator.stopAnimating()
        self.label.text = title
    }

}
