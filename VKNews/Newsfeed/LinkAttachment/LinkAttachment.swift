//
//  LinkAttachment.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 21.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit

protocol FeedCellLinkAttachmentViewModel {
    var photoURLString: String? { get }
    var linkTitle: String { get }
    var url: String { get }
}

class LinkAttachment: UIView {

    private var viewModel: FeedCellLinkAttachmentViewModel?
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageView: WebImageView!
    @IBOutlet weak var linkDescription: UILabel!
    @IBOutlet weak var linkLabel: UILabel!
    
    func set(viewModel: FeedCellLinkAttachmentViewModel) {
        self.viewModel = viewModel
        
        self.linkDescription.text = self.viewModel?.linkTitle
        self.linkLabel.text = getUrlDomain(fromLink: self.viewModel!.url)
        self.imageView.set(imageUrl: self.viewModel?.photoURLString)
    }
        
    override init(frame: CGRect) {
       super.init(frame: frame)
       commonInit()
    }
   
    required init?(coder: NSCoder) {
       super.init(coder: coder)
       commonInit()
    }
   
    private func commonInit() {
        Bundle.main.loadNibNamed("LinkAttachment", owner: self, options: nil)
        contentView.frame =  self.bounds
       
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        addTouchAction()
        
        self.cardView.layer.cornerRadius = 15
        self.cardView.clipsToBounds = true
        
//        self.
        
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOpacity = 0.3
//        contentView.layer.shadowOffset = CGSize(width: 2, height: 2)
        contentView.layer.shadowRadius = 3
    }
    
    func addTouchAction() {
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(followTheLink))
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(followTheLink))
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(followTheLink))
        
        self.imageView.isUserInteractionEnabled = true
        self.imageView.addGestureRecognizer(tapGestureRecognizer1)
        self.linkLabel.isUserInteractionEnabled = true
        self.linkLabel.addGestureRecognizer(tapGestureRecognizer2)
        self.linkDescription.isUserInteractionEnabled = true
        self.linkDescription.addGestureRecognizer(tapGestureRecognizer3)
    }

    @objc func followTheLink() {
        guard let urlString =  self.viewModel?.url, let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func getUrlDomain(fromLink link: String) -> String {
        let linkArr = link.split{$0 == "/"}.map(String.init)
        
        if linkArr.count >= 2 {
            return linkArr[1]
        } else {
            return link
        }
    }
}
