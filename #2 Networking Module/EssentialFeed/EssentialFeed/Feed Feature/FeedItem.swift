//
//  FeedItem.swift
//  EssentialFeed
//
//  Created by Rozeri Dağtekin on 13.06.2023.
//

import Foundation

public struct FeedItem: Equatable {
	let id: UUID
	let description: String?
	let location: String?
	let imageURL: URL
}
