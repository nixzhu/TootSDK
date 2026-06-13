import ArgumentParser
import Foundation
import TootSDK

struct GenerateAnnualReport: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions

    @Option(name: .long, help: "The four-digit year of the report.")
    var year: Int

    func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose {
            client.debugOn()
        }
        let hint = try await client.generateAnnualReport(year: year)
        if let hint {
            print(hint)
        } else {
            print("Generation requested for \(year). Report may already exist or is not available for that year.")
        }
    }
}
