//
//  TitleView.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 18.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation
import UIKit

protocol TitleViewViewModel {
    var photoURL: String?  { get}
    var screenName: String? { get }
}

protocol TitleViewDelegate {
    func perfomrNewsearch(withText text: String)
    func cancelSearch()
}

class TitleView: UIView {
    
    var searchDelegate: TitleViewDelegate?
    @IBOutlet weak var searchTextField: ImageUITextField!
    @IBOutlet weak var avatarImageView: WebImageView!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func canccelButtonTapped(_ sender: Any) {
        self.cancelButton.isHidden = true
        self.avatarImageView.isHidden = false
        self.searchTextField.text = ""
        searchDelegate?.cancelSearch()
    }
    
    @IBOutlet var contentView: UIView!
    
    var viewModel: UserViewModel?
    
    func set(user: UserViewModel) {
        self.avatarImageView.set(imageUrl: user.photoURL)
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
        Bundle.main.loadNibNamed("TitleView", owner: self, options: nil)
        contentView.frame =  self.bounds
        
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(contentView)
        setupSearchView()
        
        self.cancelButton.isHidden = true
        self.avatarImageView.isHidden = false
    }
    
    func setupSearchView() {
        searchTextField.addTarget(self, action: #selector(showCancelButton), for: .touchDown)
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
    }
    
    @objc func showCancelButton() {
        self.cancelButton.isHidden = false
        self.avatarImageView.isHidden = true
        self.searchTextField.text = ""
    }
    
    override func layoutSubviews() {
        self.avatarImageView.clipsToBounds = true
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.width / 2
    }
}

extension TitleView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text, !searchText.isEmpty {
            textField.resignFirstResponder()
            searchDelegate?.perfomrNewsearch(withText: searchText)
        }
        
        return true
    }
}
