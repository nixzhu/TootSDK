import ArgumentParser
import Foundation
import TootSDK

struct GetAnnualReports: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions

    func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose {
            client.debugOn()
        }
        let reports = try await client.getAnnualReports()
        print(reports)
    }
}
