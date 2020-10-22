//
//  NetworkService.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 01.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {

    private let authService: AuthService
    
    init(authService: AuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], completion: @escaping (Data?, Error?) -> Void) {
        guard let accessToken = authService.accessToken else { return }

        var allParams = params
        allParams["v"] = API.version
        allParams["access_token"] = accessToken
        
        guard let newsUrl = self.url(from: path, params: allParams) else { return }
        
        let request = URLRequest(url: newsUrl)
        
        let task = createDataTask(from: request, completion: completion)
        
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, error)
        }
        
        return dataTask
    }
    
    private func url(from path: String, params: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        
        urlComponents.host = API.host
        urlComponents.scheme = API.scheme
        urlComponents.path = path
        urlComponents.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        
        return urlComponents.url
    }
}
