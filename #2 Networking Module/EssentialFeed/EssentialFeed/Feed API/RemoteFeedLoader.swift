//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import Foundation

public protocol HTTPClient {
	func get(from url: URL)
}

public final class RemoteFeedLoader {
	private let client: HTTPClient
	private let url: URL

	public init(url: URL, client: HTTPClient) {
		self.client = client
		self.url = url
	}

	public func load() {
		client.get(from: url)
	}
}
