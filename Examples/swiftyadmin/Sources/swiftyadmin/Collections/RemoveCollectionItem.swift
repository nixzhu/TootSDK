import ArgumentParser
import Foundation
import TootSDK

struct RemoveCollectionItem: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the collection.") var id: String
    @Option(help: "The ID of the item to remove.") var itemId: String

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        try await client.removeCollectionItem(id: id, itemId: itemId)
        print("Item \(itemId) removed from collection \(id).")
    }
}
