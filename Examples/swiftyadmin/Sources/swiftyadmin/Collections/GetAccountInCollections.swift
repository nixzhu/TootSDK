import ArgumentParser
import Foundation
import TootSDK

struct GetAccountInCollections: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option(help: "The ID of the account.") var accountId: String
    @Option(help: "Maximum number of results to return.") var limit: Int?

    mutating func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose { client.debugOn() }

        var pagedInfo: PagedInfo? = nil
        var hasMore = true

        while hasMore {
            let page = try await client.getAccountInCollections(accountId: accountId, pagedInfo, limit: limit)
            for collection in page.result {
                print(collection)
            }
            hasMore = page.hasPrevious
            pagedInfo = page.previousPage
        }
    }
}
