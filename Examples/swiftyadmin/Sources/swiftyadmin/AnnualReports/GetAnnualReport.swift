import ArgumentParser
import Foundation
import TootSDK

struct GetAnnualReport: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions

    @Option(name: .long, help: "The four-digit year of the report.")
    var year: Int

    func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose {
            client.debugOn()
        }
        let result = try await client.getAnnualReport(year: year)
        print(result)
    }
}
