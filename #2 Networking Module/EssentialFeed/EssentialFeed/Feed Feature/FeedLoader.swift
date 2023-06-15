//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import Foundation

public enum LoadFeedResult {
	case success([FeedItem])
	case failure(Error)
}

protocol FeedLoader {
	func load(completion: @escaping (LoadFeedResult) -> Void)
}
