//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import XCTest

class RemoteFeedLoader {

}

class HTTPClient {
	var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {

	func test_init_doesNotRequestDataFromURL() {
		let client = HTTPClient()
		_ = RemoteFeedLoader()

		XCTAssertNil(client.requestedURL)
	}

}
