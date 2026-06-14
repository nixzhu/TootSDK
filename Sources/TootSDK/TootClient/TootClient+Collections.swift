import Foundation

extension TootClient {

    /// Fetch all collections that a given account owns.
    ///
    /// Paginated via offset-based Link headers (`?offset=N&limit=M`).
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: a PagedResult with an array of collections if successful, throws an error if not
    public func getAccountCollections(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<
        [TootCollection]
    > {
        let response = try await getAccountCollectionsRaw(accountId: accountId, pageInfo, limit: limit)
        return response.data
    }

    /// Fetch all collections that a given account owns, with HTTP response metadata.
    ///
    /// Paginated via offset-based Link headers (`?offset=N&limit=M`).
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: TootResponse containing paginated collections and HTTP metadata
    public func getAccountCollectionsRaw(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> TootResponse<
        PagedResult<[TootCollection]>
    > {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", accountId, "collections"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }
        return try await fetchPagedCollectionsRaw(req)
    }

    /// Fetch all collections an account appears in (as seen by the authenticated user).
    ///
    /// Paginated via offset-based Link headers (`?offset=N&limit=M`).
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: a PagedResult with an array of collections if successful, throws an error if not
    public func getAccountInCollections(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> PagedResult<
        [TootCollection]
    > {
        let response = try await getAccountInCollectionsRaw(accountId: accountId, pageInfo, limit: limit)
        return response.data
    }

    /// Fetch all collections an account appears in (as seen by the authenticated user), with HTTP response metadata.
    ///
    /// Paginated via offset-based Link headers (`?offset=N&limit=M`).
    /// - Parameters:
    ///   - accountId: The ID of the account.
    /// - Returns: TootResponse containing paginated collections and HTTP metadata
    public func getAccountInCollectionsRaw(accountId: String, _ pageInfo: PagedInfo? = nil, limit: Int? = nil) async throws -> TootResponse<
        PagedResult<[TootCollection]>
    > {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "accounts", accountId, "in_collections"])
            $0.method = .get
            $0.query = getQueryParams(pageInfo, limit: limit)
        }
        return try await fetchPagedCollectionsRaw(req)
    }

    /// Fetch a collection by ID, including its member accounts.
    /// - Parameters:
    ///   - id: The ID of the collection.
    /// - Returns: TootCollectionWithAccounts if successful, throws an error if not
    public func getCollection(id: String) async throws -> TootCollectionWithAccounts {
        let response = try await getCollectionRaw(id: id)
        return response.data
    }

    /// Fetch a collection by ID, including its member accounts, with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection.
    /// - Returns: TootResponse containing the collection with accounts and HTTP metadata
    public func getCollectionRaw(id: String) async throws -> TootResponse<TootCollectionWithAccounts> {
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id])
            $0.method = .get
        }
        return try await fetchRaw(TootCollectionWithAccounts.self, req)
    }

    /// Create a new collection.
    /// - Parameters:
    ///   - params: The parameters for the new collection.
    /// - Returns: the created TootCollection if successful, throws an error if not
    public func createCollection(params: TootCreateCollectionParams) async throws -> TootCollection {
        let response = try await createCollectionRaw(params: params)
        return response.data
    }

    /// Create a new collection with HTTP response metadata.
    /// - Parameters:
    ///   - params: The parameters for the new collection.
    /// - Returns: TootResponse containing the created collection and HTTP metadata
    public func createCollectionRaw(params: TootCreateCollectionParams) async throws -> TootResponse<TootCollection> {
        try requireFeature(.collections)
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections"])
            $0.method = .post
            $0.body = try .json(params, encoder: self.encoder)
        }
        let wrapped = try await fetchRaw(CollectionContainer.self, req)
        return TootResponse(
            data: wrapped.data.collection, headers: wrapped.headers, statusCode: wrapped.statusCode, url: wrapped.url, rawBody: wrapped.rawBody)
    }

    /// Update an existing collection.
    /// - Parameters:
    ///   - id: The ID of the collection to update.
    ///   - params: The parameters to update.
    /// - Returns: the updated TootCollection if successful, throws an error if not
    public func updateCollection(id: String, params: TootUpdateCollectionParams) async throws -> TootCollection {
        let response = try await updateCollectionRaw(id: id, params: params)
        return response.data
    }

    /// Update an existing collection with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection to update.
    ///   - params: The parameters to update.
    /// - Returns: TootResponse containing the updated collection and HTTP metadata
    public func updateCollectionRaw(id: String, params: TootUpdateCollectionParams) async throws -> TootResponse<TootCollection> {
        try requireFeature(.collections)
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id])
            $0.method = .patch
            $0.body = try .json(params, encoder: self.encoder)
        }
        let wrapped = try await fetchRaw(CollectionContainer.self, req)
        return TootResponse(
            data: wrapped.data.collection, headers: wrapped.headers, statusCode: wrapped.statusCode, url: wrapped.url, rawBody: wrapped.rawBody)
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
    /// - Returns: the created TootCollectionItem if successful, throws an error if not
    public func addAccountToCollection(id: String, accountId: String) async throws -> TootCollectionItem {
        let response = try await addAccountToCollectionRaw(id: id, accountId: accountId)
        return response.data
    }

    /// Add an account to a collection with HTTP response metadata.
    /// - Parameters:
    ///   - id: The ID of the collection.
    ///   - accountId: The ID of the account to add.
    /// - Returns: TootResponse containing the created collection item and HTTP metadata
    public func addAccountToCollectionRaw(id: String, accountId: String) async throws -> TootResponse<TootCollectionItem> {
        try requireFeature(.collections)
        let body = ["account_id": accountId]
        let req = try HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id, "items"])
            $0.method = .post
            $0.body = try .json(body, encoder: self.encoder)
        }
        let wrapped = try await fetchRaw(CollectionItemContainer.self, req)
        return TootResponse(
            data: wrapped.data.collectionItem, headers: wrapped.headers, statusCode: wrapped.statusCode, url: wrapped.url, rawBody: wrapped.rawBody)
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
        try requireFeature(.collections)
        let req = HTTPRequestBuilder {
            $0.url = getURL(["api", "v1", "collections", id, "items", itemId, "revoke"])
            $0.method = .post
        }
        _ = try await fetch(req: req)
    }
}

// MARK: - Private helpers

extension TootClient {

    /// Fetches a request whose body is `{"collections":[...]}` and assembles a PagedResult
    /// using the offset-based Link header pagination.
    private func fetchPagedCollectionsRaw(_ req: HTTPRequestBuilder) async throws -> TootResponse<PagedResult<[TootCollection]>> {
        let (data, response) = try await fetch(req: req)
        let container = try decode(CollectionsListContainer.self, from: data)
        return makePagedResultResponse(decoded: container.collections, response: response, data: data)
    }
}

// MARK: - Response wrapper types

/// Decodes `{"collections": [...]}` list responses.
struct CollectionsListContainer: Decodable {
    let collections: [TootCollection]
}

/// Decodes `{"collection": {...}}` single-object responses (create / update).
struct CollectionContainer: Decodable {
    let collection: TootCollection
}

/// Decodes `{"collection_item": {...}}` responses (add account to collection).
struct CollectionItemContainer: Decodable {
    let collectionItem: TootCollectionItem
}

extension TootFeature {

    /// Ability to create and manage collections.
    public static let collections = TootFeature(requirements: [
        .from(.mastodon, version: 10, fallbackDisplayVersion: "4.6.0")
    ])
}
