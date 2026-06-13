import ArgumentParser
import Foundation
import TootSDK

struct RevokeCollectionItem: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the collection.") var id: String
    @Option(help: "The ID of the item to revoke.") var itemId: String

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        try await client.revokeCollectionItem(id: id, itemId: itemId)
        print("Item \(itemId) revoked from collection \(id).")
    }
}
