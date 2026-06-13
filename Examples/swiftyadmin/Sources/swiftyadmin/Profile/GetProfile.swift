import ArgumentParser
import Foundation
import TootSDK

struct GetProfile: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions

    func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose {
            client.debugOn()
        }
        print(try await client.getProfile())
    }
}
