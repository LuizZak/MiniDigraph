/// A directed graph edge that only contains information about the start/end
/// nodes of the edge, and no other differentiating property.
///
/// A set of default implementations of the `Hashable`/`Equatable` conformances
/// use the start and end nodes as equality/hashing points.
public protocol SimpleDirectedGraphEdge<Node>: AbstractDirectedGraphEdge {
    /// Creates a new instance of this simple edge with the provided start/end
    /// nodes.
    init(start: Node, end: Node)
}

extension SimpleDirectedGraphEdge {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(end)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.start == rhs.start && lhs.end == rhs.end
    }
}
