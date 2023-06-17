//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Rozeri Dağtekin on 16.06.2023.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
	private let session: URLSession

	init(session: URLSession = .shared) {
		self.session = session
	}

	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
		session.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
			}
		}.resume()
	}
}

class URLSessionHTTPClientTests: XCTestCase {

	override func setUp() {
		super.setUp()

		URLProtocolStub.startInterceptingRequests()
	}

	override func tearDown() {
		URLProtocolStub.stopInterceptingRequests()

		super.tearDown()
	}

	func test_getFromURL_performsGETRequestWithURL() {
		let url = URL(string: "http://any-url.com")!
		let exp = expectation(description: #function)

		makeSUT().get(from: url, completion: { _ in })

		URLProtocolStub.observeRequests { request in
			XCTAssertEqual(request.url, url)
			XCTAssertEqual(request.httpMethod, "GET")
			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}

	func test_getFromURL_failsOnRequestError() {
		let url = URL(string: "http://any-url.com")!
		let error = NSError(domain: "any error", code: 1)
		URLProtocolStub.stub(data: nil, response: nil, error: error)

		let exp = expectation(description: #function)

		makeSUT().get(from: url) { result in
			switch result {
			case let .failure(receivedError as NSError):
				XCTAssertEqual(receivedError.domain, error.domain)
				XCTAssertEqual(receivedError.code, error.code)
			default:
				XCTFail("Expected failure with error \(error), got \(result) instead")
			}

			exp.fulfill()
		}

		wait(for: [exp], timeout: 1.0)
	}

	// MARK: - Helpers

	private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> URLSessionHTTPClient {
		let sut = URLSessionHTTPClient()
		trackForMemoryLeaks(sut, file: file, line: line)
		return sut
	}

	private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
		addTeardownBlock { [weak instance] in
			XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
		}
	}

	private class URLProtocolStub: URLProtocol {
		private static var stub: Stub?
		private static var requestObserver: ((URLRequest) -> Void)?

		private struct Stub {
			let data: Data?
			let response: URLResponse?
			let error: Error?
		}

		static func stub(data: Data?, response: URLResponse?, error: Error?) {
			stub = Stub(data: data, response: response, error: error)
		}

		static func observeRequests(observer: @escaping (URLRequest) -> Void) {
			requestObserver = observer
		}

		static func startInterceptingRequests() {
			URLProtocol.registerClass(URLProtocolStub.self)
		}

		static func stopInterceptingRequests() {
			URLProtocol.unregisterClass(URLProtocolStub.self)
			stub = nil
			requestObserver = nil
		}

		override class func canInit(with request: URLRequest) -> Bool {
			requestObserver?(request)
			return true
		}

		override class func canonicalRequest(for request: URLRequest) -> URLRequest {
			return request
		}

		override func startLoading() {
			guard let stub = URLProtocolStub.stub else { return }

			if let data = stub.data {
				client?.urlProtocol(self, didLoad: data)
			}

			if let response = stub.response {
				client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			}

			if let error = stub.error {
				client?.urlProtocol(self, didFailWithError: error)
			}

			client?.urlProtocolDidFinishLoading(self)
		}

		override func stopLoading() { }
	}
}
