/// A refinement of `MutableDirectedGraphType` for graphs that use simple edge
/// structures that are differentiated only by their start/end node information.
public protocol MutableSimpleEdgeDirectedGraphType: MutableDirectedGraphType where Edge: SimpleDirectedGraphEdge, Edge.Node == Node {
    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    mutating func addEdge(from start: Node, to end: Node) -> Edge

    /// Moves the entry edges from a given node to a target node.
    ///
    /// The existing entry edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    mutating func redirectEntries(for node: Node, to other: Node) -> Set<Edge>

    /// Moves the exit edges from a given node to a target node.
    ///
    /// The existing exit edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    mutating func redirectExits(for node: Node, to other: Node) -> Set<Edge>

    /// Prepends a node before a suffix node, redirecting the entries to the
    /// suffix node to the prefix node, and adding an edge from the prefix to the
    /// suffix node.
    ///
    /// Returns the edge that was created from `node` to `next`.
    @discardableResult
    mutating func prepend(_ node: Node, before next: Node) -> Edge
}

public extension MutableSimpleEdgeDirectedGraphType {
    @inlinable
    @discardableResult
    mutating func addEdge(from start: Node, to end: Node) -> Edge {
        self.addEdge(Edge(start: start, end: end))
    }

    @inlinable
    @discardableResult
    mutating func redirectEntries(for node: Node, to other: Node) -> Set<Edge> {
        var result: Set<Edge> = []

        for connection in removeEntryEdges(towards: node) {
            guard !areConnected(start: startNode(for: connection), end: other) else {
                continue
            }

            let edge = addEdge(from: startNode(for: connection), to: other)

            result.insert(edge)
        }

        return result
    }

    @inlinable
    @discardableResult
    mutating func redirectExits(for node: Node, to other: Node) -> Set<Edge> {
        var result: Set<Edge> = []

        for connection in removeExitEdges(from: node) {
            guard !areConnected(start: other, end: endNode(for: connection)) else {
                continue
            }

            let edge = addEdge(from: other, to: endNode(for: connection))

            result.insert(edge)
        }

        return result
    }

    @inlinable
    @discardableResult
    mutating func prepend(_ node: Node, before next: Node) -> Edge {
        if !containsNode(node) {
            addNode(node)
        } else {
            let fromEdges = edges(from: node)
            removeEdges(fromEdges)
        }

        redirectEntries(for: next, to: node)
        return addEdge(from: node, to: next)
    }
}
