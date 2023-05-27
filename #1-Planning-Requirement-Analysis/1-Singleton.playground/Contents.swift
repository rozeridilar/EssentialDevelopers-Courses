import UIKit

// MARK: - Main Module

extension APIClient {
    func login(completion: (LoggedInUser) -> Void) {}
}

extension APIClient {
    func loadFeed(completion: ([FeedItem]) -> Void) {}
}

// MARK: - API Module

class APIClient {
    static let instance = APIClient()

    private init () {}

    func execute(_ : URLRequest, completion: (Data) -> Void) {}
}

// MARK: - Login Module

struct LoggedInUser {}

class LoginService {
    let login: (((LoggedInUser) -> Void) -> Void)?

    func didTapLoginButton() {
        login? { user in
            // show feed screen
        }
    }
}

// MARK: - Feed Module

struct FeedItem {}

class FeedService {
    let loadFeed: ((([FeedItem]) -> Void) -> Void)?

    func load() {
        loadFeed? { feedItem in
            // update UI
        }
    }
}
