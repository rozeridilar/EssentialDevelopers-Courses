//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import XCTest

class RemoteFeedLoader {
	let client: HTTPClient

	init(client: HTTPClient) {
		self.client = client
	}

	func load() {
		client.get(from: URL(string: "https://a-url.com")!)
	}
}

protocol HTTPClient {
	func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {

	var requestedURL: URL?

	func get(from url: URL) {
		requestedURL = url
	}
}

final class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let client = HTTPClientSpy()
		_ = RemoteFeedLoader(client: client)

		XCTAssertNil(client.requestedURL)
	}

	func test_load_requestDataFromURL() {
		let client = HTTPClientSpy()
		let sut = RemoteFeedLoader(client: client)

		sut.load()

		XCTAssertNotNil(client.requestedURL)
	}
}
