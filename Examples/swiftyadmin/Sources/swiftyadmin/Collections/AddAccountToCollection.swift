import ArgumentParser
import Foundation
import TootSDK

struct AddAccountToCollection: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the collection.") var id: String
    @Option(help: "The ID of the account to add.") var accountId: String

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }
        print(try await client.addAccountToCollection(id: id, accountId: accountId))
    }
}
