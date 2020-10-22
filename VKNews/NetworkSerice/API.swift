//
//  API.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 01.09.2020.
//  Copyright © 2020 Иван Абрамов. All rights reserved.
//

import Foundation

struct API {
    static let host = "api.vk.com"
    static let scheme = "https"
    static let version = "5.122"
    static let newsFeed = "/method/newsfeed.get"
    static let getUser = "/method/users.get"
    static let search = "/method/newsfeed.search" //"/method/newsfeed.search"
}
