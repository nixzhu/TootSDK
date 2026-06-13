import ArgumentParser
import Foundation
import TootSDK

struct GetCollection: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the collection.") var id: String

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        print(try await client.getCollection(id: id))
    }
}
