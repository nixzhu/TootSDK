import Foundation

/// Represents a membership item within a collection.
public struct CollectionItem: Codable, Hashable, Identifiable, Sendable {

    /// The lifecycle state of an account's membership in a collection.
    public enum State: String, Codable, Hashable, Sendable {
        /// The membership is pending approval.
        case pending
        /// The membership has been accepted.
        case accepted
        /// The membership has been rejected.
        case rejected
        /// The membership has been revoked.
        case revoked
    }

    /// The internal database ID of the collection item.
    public var id: String

    /// The current state of this membership.
    public var state: OpenEnum<State>

    /// The ID of the account associated with this item.
    public var accountId: String?

    /// When the item was created.
    public var createdAt: Date?

    public init(
        id: String,
        state: OpenEnum<State>,
        accountId: String? = nil,
        createdAt: Date? = nil
    ) {
        self.id = id
        self.state = state
        self.accountId = accountId
        self.createdAt = createdAt
    }

    private enum CodingKeys: String, CodingKey {
        case id, state
        case accountId
        case createdAt
    }
}
