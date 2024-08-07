/// Protocol for directed graphs that can be mutated.
public protocol MutableDirectedGraphType: DirectedGraphType {
    /// Initializes an empty graph.
    init()

    // MARK: - Required conformances

    /// Adds a given node to this graph.
    mutating func addNode(_ node: Node)

    /// Removes a given node from this graph.
    mutating func removeNode(_ node: Node)

    /// Adds a given edge to this graph.
    ///
    /// Returns the edge that was inserted, or in case an edge connecting the
    /// associated nodes already existed within this graph, the original edge
    /// instance.
    ///
    /// - precondition: `edge` refers to nodes that are already contained within
    /// this graph.
    @discardableResult
    mutating func addEdge(_ edge: Edge) -> Edge

    /// Removes a given edge from this graph.
    ///
    /// - precondition: `edge` refers to an edge that is contained within this
    /// graph.
    mutating func removeEdge(_ edge: Edge)

    // MARK: - Optional conformances

    /// Removes all nodes and edges from this graph.
    mutating func clear()

    /// Returns a subset of this directed graph containing only the nodes from
    /// a given sequence, and all edges present that match start/end nodes within
    /// the sequence.
    func subgraph(of nodes: some Sequence<Node>) -> Self

    /// Adds a sequence of nodes to this graph.
    mutating func addNodes(_ nodes: some Sequence<Node>)

    /// Adds a sequence of edges to this graph.
    mutating func addEdges(_ edges: some Sequence<Edge>)

    /// Removes a given sequence of nodes from this graph.
    mutating func removeNodes(_ nodesToRemove: some Sequence<Node>)

    /// Removes all edges between two nodes from this graph.
    mutating func removeEdges(from start: Node, to end: Node)

    /// Removes a given sequence of edges from this graph.
    mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>)

    /// Removes the entry edges from a given node.
    /// Returns the set of edges that where removed.
    @discardableResult
    mutating func removeEntryEdges(towards node: Node) -> [Edge]

    /// Removes the exit edges from a given node.
    /// Returns the set of edges that where removed.
    @discardableResult
    mutating func removeExitEdges(from node: Node) -> [Edge]
}

extension MutableDirectedGraphType {
    @inlinable
    public func subgraph(of nodes: some Sequence<Node>) -> Self {
        let nodeSet = Set(nodes)
        let connectedEdges = self.edges.filter {
            nodeSet.contains(startNode(for: $0)) && nodeSet.contains(endNode(for: $0))
        }

        var graph = Self()
        graph.addNodes(nodeSet)

        for edge in connectedEdges {
            graph.addEdge(edge)
        }

        return graph
    }

    @inlinable
    public mutating func clear() {
        removeEdges(self.edges)
        removeNodes(self.nodes)
    }

    @inlinable
    public mutating func addNodes(_ nodes: some Sequence<Node>) {
        for node in nodes {
            addNode(node)
        }
    }

    @inlinable
    public mutating func addEdges(_ edges: some Sequence<Edge>) {
        for edge in edges {
            addEdge(edge)
        }
    }

    @inlinable
    public mutating func removeNodes(_ nodesToRemove: some Sequence<Node>) {
        for node in nodesToRemove {
            removeEdges(allEdges(for: node))
            removeNode(node)
        }
    }

    @inlinable
    public mutating func removeEdges(from start: Node, to end: Node) {
        for edge in edges(from: start, to: end) {
            removeEdge(edge)
        }
    }

    @inlinable
    public mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>) {
        for edge in edgesToRemove {
            removeEdge(edge)
        }
    }

    @inlinable
    @discardableResult
    public mutating func removeEntryEdges(towards node: Node) -> [Edge] {
        let connections = edges(towards: node)
        removeEdges(connections)
        return connections
    }

    @inlinable
    @discardableResult
    public mutating func removeExitEdges(from node: Node) -> [Edge] {
        let connections = edges(from: node)
        removeEdges(connections)
        return connections
    }
}
