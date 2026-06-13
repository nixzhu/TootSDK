import Foundation

extension TootClient {

    /// Fetch all collections owned by the authenticated user.
    /// - Returns: a PagedResult with an array of collections if successful, throws an error if not
    public func getCollections(_ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<[Collection]> {
        let response = try await getCollectionsRaw(pageInfo, limit: limit)
        return response.data
    }

    /// Fetch all collections owned by the authenticated user with HTTP response metadata.
    /// - Returns: TootResponse containing paginated collections and HTTP metadata
    public func getCollectionsRaw(_ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> TootResponse<PagedResult<[Collection]>> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }
        return try await fetchPagedResultRaw(req)
    }

    /// Fetch all collections that a given account is a member of.
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: a PagedResult with an array of collections if successful, throws an error if not
    public func getAccountCollections(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<[Collection]> {
        let response = try await getAccountCollectionsRaw(accountId: accountId, pageInfo, limit: limit)
        return response.data
    }

    /// Fetch all collections that a given account is a member of with HTTP response metadata.
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: TootResponse containing paginated collections and HTTP metadata
    public func getAccountCollectionsRaw(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> TootResponse<PagedResult<[Collection]>> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", accountId, "collections"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }
        return try await fetchPagedResultRaw(req)
    }

    /// Fetch all collections an account appears in (as seen by the authenticated user).
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: a PagedResult with an array of collections if successful, throws an error if not
    public func getAccountInCollections(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<[Collection]> {
        let response = try await getAccountInCollectionsRaw(accountId: accountId, pageInfo, limit: limit)
        return response.data
    }

    /// Fetch all collections an account appears in (as seen by the authenticated user) with HTTP response metadata.
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: TootResponse containing paginated collections and HTTP metadata
    public func getAccountInCollectionsRaw(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> TootResponse<PagedResult<[Collection]>> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", accountId, "in_collections"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }
        return try await fetchPagedResultRaw(req)
    }

    /// Fetch a collection by ID, including its member accounts.
    /// - Parameters:
    ///   - id: The ID of the collection.
    /// - Returns: CollectionWithAccounts if successful, throws an error if not
    public func getCollection(id: String) async throws -> CollectionWithAccounts {
        let response = try await getCollectionRaw(id: id)
        return response.data
    }

    /// Fetch a collection by ID, including its member accounts, with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection.
    /// - Returns: TootResponse containing the collection with accounts and HTTP metadata
    public func getCollectionRaw(id: String) async throws -> TootResponse<CollectionWithAccounts> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id])
            $0.method = .get
        }
        return try await fetchRaw(CollectionWithAccounts.self, req)
    }

    /// Create a new collection.
    /// - Parameters:
    ///   - params: The parameters for the new collection.
    /// - Returns: the created Collection if successful, throws an error if not
    public func createCollection(params: CreateCollectionParams) async throws -> Collection {
        let response = try await createCollectionRaw(params: params)
        return response.data
    }

    /// Create a new collection with HTTP response metadata.
    /// - Parameters:
    ///   - params: The parameters for the new collection.
    /// - Returns: TootResponse containing the created collection and HTTP metadata
    public func createCollectionRaw(params: CreateCollectionParams) async throws -> TootResponse<Collection> {
        try requireFeature(.collections)
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections"])
            $0.method = .post
            $0.body = try .json(params, encoder: self.encoder)
        }
        return try await fetchRaw(Collection.self, req)
    }

    /// Update an existing collection.
    /// - Parameters:
    ///   - id: The ID of the collection to update.
    ///   - params: The parameters to update.
    /// - Returns: the updated Collection if successful, throws an error if not
    public func updateCollection(id: String, params: UpdateCollectionParams) async throws -> Collection {
        let response = try await updateCollectionRaw(id: id, params: params)
        return response.data
    }

    /// Update an existing collection with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection to update.
    ///   - params: The parameters to update.
    /// - Returns: TootResponse containing the updated collection and HTTP metadata
    public func updateCollectionRaw(id: String, params: UpdateCollectionParams) async throws -> TootResponse<Collection> {
        try requireFeature(.collections)
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id])
            $0.method = .patch
            $0.body = try .json(params, encoder: self.encoder)
        }
        return try await fetchRaw(Collection.self, req)
    }

    /// Delete a collection.
    /// - Parameters:
    ///   - id: The ID of the collection to delete.
    public func deleteCollection(id: String) async throws {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id])
            $0.method = .delete
        }
        _ = try await fetch(req: req)
    }

    /// Add an account to a collection.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - accountId: The ID of the account to add.
    /// - Returns: the created CollectionItem if successful, throws an error if not
    public func addAccountToCollection(id: String, accountId: String) async throws -> CollectionItem {
        let response = try await addAccountToCollectionRaw(id: id, accountId: accountId)
        return response.data
    }

    /// Add an account to a collection with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - accountId: The ID of the account to add.
    /// - Returns: TootResponse containing the created collection item and HTTP metadata
    public func addAccountToCollectionRaw(id: String, accountId: String) async throws -> TootResponse<CollectionItem> {
        try requireFeature(.collections)
        let body = ["account_id": accountId]
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id, "items"])
            $0.method = .post
            $0.body = try .json(body, encoder: self.encoder)
        }
        return try await fetchRaw(CollectionItem.self, req)
    }

    /// Remove an item from a collection.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - itemId: The ID of the collection item to remove.
    public func removeCollectionItem(id: String, itemId: String) async throws {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id, "items", itemId])
            $0.method = .delete
        }
        _ = try await fetch(req: req)
    }

    /// Revoke an account's membership in a collection.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - itemId: The ID of the collection item to revoke.
    public func revokeCollectionItem(id: String, itemId: String) async throws {
        let _ = try await revokeCollectionItemRaw(id: id, itemId: itemId)
    }

    /// Revoke an account's membership in a collection with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - itemId: The ID of the collection item to revoke.
    /// - Returns: TootResponse containing the updated collection item and HTTP metadata
    public func revokeCollectionItemRaw(id: String, itemId: String) async throws -> TootResponse<CollectionItem> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id, "items", itemId, "revoke"])
            $0.method = .post
        }
        return try await fetchRaw(CollectionItem.self, req)
    }
}

extension TootFeature {

    /// Ability to create and manage collections.
    public static let collections = TootFeature(requirements: [
        .from(.mastodon, version: 10, fallbackDisplayVersion: "4.6.0")
    ])
}
