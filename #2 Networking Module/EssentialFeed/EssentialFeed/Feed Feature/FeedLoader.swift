//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import Foundation

enum LoadFeedResult {
	case success([FeedItem])
	case error(Error)
}

protocol FeedLoader {
	func load(completion: @escaping (LoadFeedResult) -> Void)
}
