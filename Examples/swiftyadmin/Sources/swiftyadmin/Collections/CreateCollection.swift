import ArgumentParser
import Foundation
import TootSDK

struct CreateCollection: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The title of the collection.") var name: String
    @Option(help: "A description of the collection.") var description: String?
    @Option(help: "Default language for the collection (BCP 47 tag).") var language: String?
    @Option(help: "Whether the collection is marked as sensitive.") var sensitive: Bool?
    @Option(help: "Whether the collection is discoverable.") var discoverable: Bool?
    @Option(help: "The name of a tag to associate with the collection.") var tagName: String?
    @Option(help: "Account IDs to add to the collection.") var accountId: [String] = []

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        let params = CreateCollectionParams(
            name: name,
            description: description,
            language: language,
            sensitive: sensitive,
            discoverable: discoverable,
            tagName: tagName,
            accountIds: accountId.isEmpty ? nil : accountId
        )
        print(try await client.createCollection(params: params))
    }
}
