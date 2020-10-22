//
//  UserResponse.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 18.10.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    var photo100: String?
    var screenName: String?
}
