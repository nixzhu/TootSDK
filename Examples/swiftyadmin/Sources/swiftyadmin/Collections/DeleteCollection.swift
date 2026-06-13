import ArgumentParser
import Foundation
import TootSDK

struct DeleteCollection: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the collection to delete.") var id: String

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        try await client.deleteCollection(id: id)
        print("Collection \(id) deleted.")
    }
}
