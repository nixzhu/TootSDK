import Foundation

/// The response shape returned when fetching a single collection.
///
/// Contains the collection's metadata together with the accounts that are members of it.
public struct TootCollectionWithAccounts: Codable, Hashable, Sendable {

    /// The collection.
    public var collection: TootCollection

    /// The accounts that are members of the collection.
    public var accounts: [Account]

    public init(collection: TootCollection, accounts: [Account]) {
        self.collection = collection
        self.accounts = accounts
    }
}
