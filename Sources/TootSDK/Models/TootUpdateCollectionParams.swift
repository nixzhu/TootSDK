import Foundation

/// Parameters for updating an existing collection.
public struct TootUpdateCollectionParams: Codable, Sendable {

    /// The user-defined title of the collection.
    public var name: String?

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

    public init(
        name: String? = nil,
        description: String? = nil,
        language: String? = nil,
        sensitive: Bool? = nil,
        discoverable: Bool? = nil,
        tagName: String? = nil
    ) {
        self.name = name
        self.description = description
        self.language = language
        self.sensitive = sensitive
        self.discoverable = discoverable
        self.tagName = tagName
    }

    private enum CodingKeys: String, CodingKey {
        case name, description, language, sensitive, discoverable
        case tagName
    }
}
