/// Element for a graph visiting operation.
///
/// - start: The item represents the start of a visit.
/// - edge: The item represents an edge, pointing to a node of the graph.
public enum DirectedGraphVisitElement<E: DirectedGraphEdge, N: Hashable>: Hashable {
    case start(N)
    indirect case edge(E, towards: N)

    /// Gets the node at the end of this visit element.
    public var node: N {
        switch self {
        case .start(let node),
             .edge(_, let node):
            return node
        }
    }

    /// Gets the last edge that is associated with the visit.
    ///
    /// If this visit is not an `.edge` case, `nil` is returned instead.
    public var edge: E? {
        switch self {
        case .start:
            return nil
        case .edge(let edge, _):
            return edge
        }
    }
}

extension DirectedGraphVisitElement: DirectedGraphVisitElementType {
    public typealias Node = N
    public typealias Edge = E

    @inlinable
    public func appendingVisit(
        _ edge: Edge,
        towards node: Node
    ) -> Self {
        .edge(edge, towards: node)
    }
}
