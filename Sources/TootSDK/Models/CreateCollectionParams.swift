import Foundation

/// Parameters for creating a new collection.
public struct CreateCollectionParams: Codable, Sendable {

    /// The user-defined title of the collection.
    public var name: String

    /// A description of the collection.
    public var description: String?

    /// The default language for the collection, as a BCP 47 language tag.
    public var language: String?

    /// Whether the collection is marked as sensitive.
    public var sensitive: Bool?

    /// Whether the collection is discoverable.
    public var discoverable: Bool?

    /// The name of a tag to associate with the collection.
    public var tagName: String?

    /// The IDs of accounts to add as initial members.
    public var accountIds: [String]?

    public init(
        name: String,
        description: String? = nil,
        language: String? = nil,
        sensitive: Bool? = nil,
        discoverable: Bool? = nil,
        tagName: String? = nil,
        accountIds: [String]? = nil
    ) {
        self.name = name
        self.description = description
        self.language = language
        self.sensitive = sensitive
        self.discoverable = discoverable
        self.tagName = tagName
        self.accountIds = accountIds
    }

    private enum CodingKeys: String, CodingKey {
        case name, description, language, sensitive, discoverable
        case tagName
        case accountIds
    }
}
