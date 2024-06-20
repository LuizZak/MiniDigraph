/// An edge of an `AbstractDirectedGraph`, that always exposes the start/end node
/// of the edge as properties, but may have other differentiating properties.
public protocol AbstractDirectedGraphEdge: DirectedGraphEdge {
    associatedtype Node: Hashable

    /// The starting node of this edge.
    var start: Node { get }

    /// The ending node of this edge.
    var end: Node { get }
}
