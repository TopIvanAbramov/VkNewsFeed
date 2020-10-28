//
//  WebImageView.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 13.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import UIKit

class WebImageView: UIImageView {
    
    private var imageUrl: String?
    
    func set(imageUrl: String?) {
        self.imageUrl = imageUrl
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            DispatchQueue.main.async {
                self.image = nil
            }
            return
        }
        
        if let cachedReponse = URLCache.shared.cachedResponse(for: URLRequest(url: url))  {
            DispatchQueue.main.async {
                self.image = UIImage(data:  cachedReponse.data)
            }
            return
        }
        
        
        let dataTask = URLSession.shared.dataTask(with: url) {
            [weak  self]  (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(image: data, response: response)
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func handleLoadedImage(image data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        
        let cachedReponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedReponse, for: URLRequest(url: url))
        
        if url.absoluteString == self.imageUrl {
            self.image =  UIImage(data: data)
        }
    }

}
