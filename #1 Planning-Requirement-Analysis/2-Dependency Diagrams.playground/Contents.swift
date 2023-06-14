import UIKit

protocol FeedLoader {
    func loadFeed(completion: @escaping ([String]) -> Void)
}

class FeedViewController: UIViewController {
    var loader: FeedLoader!


    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loader.loadFeed { feedItems in
            // update UI
        }
    }
}

class RemoteFeedLoader: FeedLoader {

    func loadFeed(completion: @escaping ([String]) -> Void) {
        // load feed from external API - URLSession
    }
}

class LocalFeedLoader: FeedLoader {

    func loadFeed(completion: @escaping ([String]) -> Void) {
        // fetch some data from cache or even predefined local JSON file
        // Persistence store/cache mechanism or JSON file
    }
}

struct Reachability {

    static let networkAvailable = false
}

class RemoteWithLocalFallbackFeedLoader: FeedLoader {

    let remote: RemoteFeedLoader
    let local: LocalFeedLoader

    init(remote: RemoteFeedLoader, local: LocalFeedLoader) {
        self.local = local
        self.remote = remote
    }

    func loadFeed(completion: @escaping ([String]) -> Void) {
        let load = Reachability.networkAvailable ? remote.loadFeed : local.loadFeed
        load(completion)
    }

}

let remoteVC = FeedViewController(loader: RemoteFeedLoader())
let localVC = FeedViewController(loader: LocalFeedLoader())
let remoteWithLocalFallbackVC = FeedViewController(loader: RemoteWithLocalFallbackFeedLoader(remote: RemoteFeedLoader(),
                                                                                             local: LocalFeedLoader()))

