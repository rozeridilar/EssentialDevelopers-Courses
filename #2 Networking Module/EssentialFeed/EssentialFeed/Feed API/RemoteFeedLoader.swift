//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import Foundation

public enum HTTPClientResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public final class RemoteFeedLoader {

	private let client: HTTPClient
	private let url: URL

	public enum Error: Swift.Error {
		case connectivity
		case invalidData
	}

	public init(url: URL, client: HTTPClient) {
		self.client = client
		self.url = url
	}

	public func load(completion: @escaping (Error) -> Void) {
		client.get(from: url) { result in
			switch result {
			case .success(let response):
				completion(.invalidData)
			case .failure:
				completion(.connectivity)
			}
		}
	}
}
