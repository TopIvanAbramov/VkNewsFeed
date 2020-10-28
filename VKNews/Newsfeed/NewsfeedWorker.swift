//
//  NewsfeedWorker.swift
//  VkNewsFeed
//
//  Created by Иван Абрамов on 02.09.2020.
//  Copyright (c) 2020 Иван Абрамов. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class NewsfeedWorker {
    
    private var fetcher: DataFetcher
    
    private var revealedPostIds = [Int]()
    private var revealedSearchPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var feedSearchResponse: FeedResponse?
    private var newFromInProcess: String?
    private var isSearchResultVisible: Bool = false
    
    init() {
        let networking = NetworkService()
        self.fetcher = NetworkDataFetcher(networking: networking)
    }
    
    func getFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextFeedFrom: nil) { (feedResponse) in
            self.feedResponse = feedResponse
            
            guard let feedResponse = feedResponse else { return }
            
            completion(self.revealedPostIds, feedResponse)
        }
    }
    
    func getOldFeed(completion: @escaping ([Int], FeedResponse) -> Void) {
        self.newFromInProcess = self.feedResponse?.nextFrom
        
        fetcher.getFeed(nextFeedFrom: newFromInProcess) { (feed) in
            
            guard let feed = feed, self.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self.feedResponse == nil {
                self.feedResponse = feed
            } else {
                self.feedResponse?.items.append(contentsOf: feed.items)
                
                var profiles = feed.profiles
                if let oldProfiles = self.feedResponse?.profiles {
                    oldProfiles.forEach { (profile) in
                        if !profiles.contains(where: {$0.id == profile.id} ) {
                            profiles.append(profile)
                        }
                    }
                }
                
                var groups = feed.groups
                
                if let oldGroups = self.feedResponse?.groups {
                    oldGroups.forEach { (group) in
                        if !groups.contains(where: {$0.id == group.id} ) {
                            groups.append(group)
                        }
                    }
                }
                
                self.feedResponse?.groups = groups
                self.feedResponse?.profiles = profiles
            }
            
            self.feedResponse?.nextFrom = feed.nextFrom
            
            guard let feedResponse = self.feedResponse else { return }
            
            print("Get old posts")
            
            completion(self.revealedPostIds, feedResponse)
        }
    }
    
    func revealPost(id: Int, completion: @escaping (FeedResponse, [Int]) -> Void) {
        if isSearchResultVisible {
            self.revealedSearchPostIds.append(id)
            guard let feedResponse = self.feedSearchResponse else { return }
                
            completion(feedResponse, self.revealedSearchPostIds)
        } else {
            self.revealedPostIds.append(id)
            guard let feedResponse = self.feedResponse else { return }
            
            completion(feedResponse, self.revealedPostIds)
        }
    }
    
    func getUser(completion: @escaping (UserResponse) -> Void) {
        fetcher.getUser { (userResponse) in
            guard let userResponse = userResponse else { return }
            
            completion(userResponse)
        }
    }
    
    func performSearch(withText text: String, completion: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.search(text: text) { (feedResponse) in
//            self.feedResponse = feedResponse

            guard let feedResponse = feedResponse else { return }

            var convertedItems : [FeedItem] = []
            
            feedResponse.items.forEach { (searchItem) in
                convertedItems.append(FeedItem(sourceId: searchItem.sourceId,
                                               postId: searchItem.postId,
                                               text: searchItem.text,
                                               date: searchItem.date,
                                               comments: searchItem.comments,
                                               likes: searchItem.likes,
                                               reposts: searchItem.reposts,
                                               views: searchItem.views,
                                               attachments: searchItem.attachments))
            }
        
            let feedResponseConverted = FeedResponse(items: convertedItems,
                                                     groups: feedResponse.groups,
                                                     profiles: feedResponse.profiles,
                                                     nextFrom: feedResponse.nextFrom)
            
            self.feedSearchResponse = feedResponseConverted
            self.isSearchResultVisible = true
            
            completion(self.revealedPostIds, feedResponseConverted)
//            print("Worker: ", feedResponse)
        }
        
//        fetcher.getFeed(nextFeedFrom: nil) { (feedResponse) in
//            self.feedResponse = feedResponse
//
//            guard let feedResponse = feedResponse else { return }
//
//            completion(self.revealedPostIds, feedResponse)
//        }
    }
    
    func cancelSearchcompletion(completion: @escaping ([Int], FeedResponse) -> Void) {
        self.isSearchResultVisible = false
        guard let feedResponse = feedResponse else { return }
        
        completion(self.revealedPostIds, feedResponse)
    }
}
