//
//  FeedResponse.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 01.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation

struct FeedReponseWrapped: Decodable {
    let response: FeedResponse
}

struct FeedResponse: Decodable {
    var items: [FeedItem]
    var groups: [Group]
    var profiles: [Profile]
    var nextFrom: String?
}

protocol FeedItemProtocol {
    var sourceId: Int { get }
    var postId: Int { get }
    var text: String? { get }
    var date: Double { get }
    var comments: CountableItems? { get }
    var likes: CountableItems? { get }
    var reposts: CountableItems? { get }
    var views: CountableItems? { get }
    var attachments: [Attachment]? { get }
}

struct FeedItem: FeedItemProtocol, Decodable {
    let sourceId: Int
    let postId: Int
    let text: String?
    let date: Double
    let comments: CountableItems?
    let likes: CountableItems?
    let reposts: CountableItems?
    let views: CountableItems?
    var attachments: [Attachment]?
}

struct CountableItems: Decodable {
    let count: Int
}

protocol ProfileRepresentable {
    var id: Int { get }
    var photo: String { get }
    var name: String { get }
}

struct Profile: Decodable, ProfileRepresentable {
    let id: Int
    var photo: String { return photo100}
    var name: String { return firstName + " " + lastName}
    
    
    let firstName: String
    let lastName: String
    let photo100: String
    
}

struct Group: Decodable, ProfileRepresentable {
    var photo: String { return photo100 }
    
    let id: Int
    let name: String
    let photo100: String
}

struct Attachment: Decodable {
    let photo: Photo?
    let link: Link?
}

struct Link: Decodable {
    let url: String
    let title: String
    let photo: Photo?
    let previewUrl: String?
}

struct Photo: Decodable {
    
    var width: Int {
        return getSize().width
    }
    
    var height: Int {
        return getSize().height
        
    }
    
    var url: String {
        return getSize().url
    }
    
    
    let sizes: [PhotoSize]
    
    private func getSize() -> PhotoSize{
        if let sizeX = sizes.first(where: { $0.type == "x"}) {
            return sizeX
        } else if let lastSize = sizes.last  {
            return lastSize
        } else {
            return PhotoSize(type: "wrong type", width: 0, height: 0, url: "")
        }
    }
}

struct PhotoSize: Decodable {
    let type: String
    let width: Int
    let height: Int
    let url: String
}

