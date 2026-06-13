import Foundation

/// Rendering attributes attached to unsupported non-baseline notification types when the client sends `supported_types`.
public struct NotificationFallback: Codable, Hashable, Sendable {

    /// A short title describing the notification event.
    public var title: String?

    /// A brief summary of the notification event.
    public var summary: String?

    /// An extended description of the notification event.
    public var description: String?

    public init(title: String? = nil, summary: String? = nil, description: String? = nil) {
        self.title = title
        self.summary = summary
        self.description = description
    }
}
