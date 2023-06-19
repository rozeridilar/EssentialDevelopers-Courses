//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 15.06.2023.
//

import Foundation

public protocol HTTPClient {
	func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public enum HTTPClientResult {
	case success(Data, HTTPURLResponse)
	case failure(Error)
}
