//
//  NetworkDataFetcher.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 01.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(nextFeedFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
    func search(text: String, response: @escaping (SearchResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    let networking : Networking
    private let authService: AuthService
    
    init(networking : Networking, authService: AuthService = AppDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(nextFeedFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters": "post,photo"]
         
        if let nextFeedFrom = nextFeedFrom {
            params["start_from"] = nextFeedFrom
        }
          networking.request(path: API.newsFeed, params: params) { (data, error) in
              if let error = error {
                  print("Error: \(error.localizedDescription)")
              } else {
                
                let result = self.decodeJSON(type: FeedReponseWrapped.self, data: data)
                  
                response(result?.response)
                
              }
          }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields": "photo_100,screen_name"]
        networking.request(path: API.getUser, params: params) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
              let result = self.decodeJSON(type: UserResponseWrapped.self, data: data)
                
                response(result?.response.first)
              
            }
        }
    }
    
    func search(text: String, response: @escaping (SearchResponse?) -> Void) {
        let params = ["q": text, "extended" : "1"]

          networking.request(path: API.search, params: params) { (data, error) in
              if let error = error {
                  print("Error: \(error.localizedDescription)")
              } else {
                
                let result = self.decodeJSON(type: SearchResponseWrapped.self, data: data)
                
                response(result?.response)
                
              }
          }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        guard let data = data, let result = try? decoder.decode(T.self, from: data) else {
            return nil
        }
        
        return result
    }
}
