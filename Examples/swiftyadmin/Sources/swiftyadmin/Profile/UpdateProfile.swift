import ArgumentParser
import Foundation
import TootSDK

struct UpdateProfile: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions

    @Option(help: "Display name for the profile.")
    var displayName: String?

    @Option(help: "Account bio text.")
    var note: String?

    @Option(help: "File path to the avatar image.")
    var avatar: String?

    @Option(help: "Alternative text for the avatar image.")
    var avatarDescription: String?

    @Option(help: "File path to the header image.")
    var header: String?

    @Option(help: "Alternative text for the header image.")
    var headerDescription: String?

    @Option(help: "Whether manual approval of follow requests is required.")
    var locked: Bool?

    @Option(help: "Whether the account has a bot flag.")
    var bot: Bool?

    @Option(help: "Whether the account should be shown in the profile directory.")
    var discoverable: Bool?

    @Option(help: "Whether to hide followers and followed accounts.")
    var hideCollections: Bool?

    @Option(help: "Whether public posts should be searchable to anyone.")
    var indexable: Bool?

    @Option(help: "Whether media attachments are shown by default.")
    var showMedia: Bool?

    @Option(help: "Whether media attachments in replies are shown by default.")
    var showMediaReplies: Bool?

    @Option(help: "Whether featured posts are shown on the profile.")
    var showFeatured: Bool?

    @Option(help: "Domain allowed to credit the account in link preview cards. Repeat for multiple.")
    var attributionDomain: [String] = []

    @Option(help: "Profile field in name=value format. Repeat for multiple.")
    var field: [String] = []

    func run() async throws {
        let client = try await TootClient(connect: auth.url, accessToken: auth.token)
        if auth.verbose {
            client.debugOn()
        }

        var avatarData: Data?
        var avatarMimeType: String?
        if let avatarPath = avatar {
            avatarData = try Data(contentsOf: URL(fileURLWithPath: avatarPath))
            avatarMimeType = mimeType(forPath: avatarPath)
        }

        var headerData: Data?
        var headerMimeType: String?
        if let headerPath = header {
            headerData = try Data(contentsOf: URL(fileURLWithPath: headerPath))
            headerMimeType = mimeType(forPath: headerPath)
        }

        var fieldDict: [String: UpdateProfileParams.Field] = [:]
        for (index, entry) in field.enumerated() {
            guard let separatorIndex = entry.firstIndex(of: "=") else {
                throw ValidationError("Field must be in name=value format")
            }
            let name = String(entry[entry.startIndex..<separatorIndex])
            let value = String(entry[entry.index(after: separatorIndex)...])
            fieldDict[String(index)] = UpdateProfileParams.Field(name: name, value: value)
        }

        let params = UpdateProfileParams(
            displayName: displayName,
            note: note,
            avatar: avatarData,
            avatarMimeType: avatarMimeType,
            avatarDescription: avatarDescription,
            header: headerData,
            headerMimeType: headerMimeType,
            headerDescription: headerDescription,
            locked: locked,
            bot: bot,
            discoverable: discoverable,
            hideCollections: hideCollections,
            indexable: indexable,
            showMedia: showMedia,
            showMediaReplies: showMediaReplies,
            showFeatured: showFeatured,
            attributionDomains: attributionDomain.isEmpty ? nil : attributionDomain,
            fieldsAttributes: fieldDict.isEmpty ? nil : fieldDict
        )

        let updated = try await client.updateProfile(params: params)
        print(updated)
    }
}

private func mimeType(forPath path: String) -> String {
    switch URL(fileURLWithPath: path).pathExtension.lowercased() {
    case "png": return "image/png"
    case "jpg", "jpeg": return "image/jpeg"
    case "gif": return "image/gif"
    default: return "application/octet-stream"
    }
}
