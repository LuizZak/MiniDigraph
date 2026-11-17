/// A protocol for representing directed graphs
public protocol DirectedGraphType {
    /// The type of collection containing the nodes of this graph.
    associatedtype NodeCollection: Collection
        where NodeCollection.Element: Hashable

    /// The type of collection containing the edges of this graph.
    associatedtype EdgeCollection: Collection
        where EdgeCollection.Element: DirectedGraphEdge

    /// Convenience for `Self.NodeCollection.Element`
    typealias Node = NodeCollection.Element

    /// Convenience for `Self.EdgeCollection.Element`
    typealias Edge = EdgeCollection.Element

    /// Convenience typealias for a visit for visit methods in this directed graph.
    typealias VisitElement = DirectedGraphRecordingVisitElement<Edge, Node>

    /*
    /// Gets a set of all nodes in this directed graph.
    var nodes: NodeCollection { get }
    /// Gets a set of all edges in this directed graph.
    var edges: EdgeCollection { get }
    */

    /// Performs a breadth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge

    /// Performs a breadth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func breadthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool)
}

public extension DirectedGraphType {
    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge {
        let visited: Set<Node> = []

        _use(visited)
    }

    @inlinable
    func breadthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool) {
        breadthFirstVisit(start: VisitElement.start(start), visitor)
    }
}

func _use<T>(_ value: T) { }
