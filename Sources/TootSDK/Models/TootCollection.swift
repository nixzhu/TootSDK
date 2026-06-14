import Foundation

/// Represents a collection of accounts on the server.
public struct TootCollection: Codable, Hashable, Identifiable, Sendable {

    /// The internal database ID of the collection.
    public var id: String

    /// The ActivityPub URI of the collection.
    public var uri: String?

    /// The URL of the collection.
    public var url: String?

    /// The user-defined title of the collection.
    public var name: String

    /// The user-defined description of the collection.
    public var description: String?

    /// The default language of the collection, as a BCP 47 language tag.
    public var language: String?

    /// The ID of the account that owns this collection.
    public var accountId: String

    /// Whether the collection is local to the instance.
    public var local: Bool?

    /// Whether the collection is marked as sensitive.
    public var sensitive: Bool?

    /// Whether the collection is discoverable.
    public var discoverable: Bool?

    /// The number of items in the collection.
    public var itemCount: Int?

    /// When the collection was created.
    public var createdAt: Date?

    /// When the collection was last updated.
    public var updatedAt: Date?

    /// An associated tag for the collection.
    public var tag: Tag?

    /// The items currently in the collection.
    public var items: [TootCollectionItem]?

    public init(
        id: String,
        uri: String? = nil,
        url: String? = nil,
        name: String,
        description: String? = nil,
        language: String? = nil,
        accountId: String,
        local: Bool? = nil,
        sensitive: Bool? = nil,
        discoverable: Bool? = nil,
        itemCount: Int? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        tag: Tag? = nil,
        items: [TootCollectionItem]? = nil
    ) {
        self.id = id
        self.uri = uri
        self.url = url
        self.name = name
        self.description = description
        self.language = language
        self.accountId = accountId
        self.local = local
        self.sensitive = sensitive
        self.discoverable = discoverable
        self.itemCount = itemCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tag = tag
        self.items = items
    }

    private enum CodingKeys: String, CodingKey {
        case id, uri, url, name, description, language
        case accountId
        case local, sensitive, discoverable
        case itemCount
        case createdAt
        case updatedAt
        case tag, items
    }
}
