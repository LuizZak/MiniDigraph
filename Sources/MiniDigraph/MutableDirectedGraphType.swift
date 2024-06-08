/// Protocol for directed graphs that can be mutated.
public protocol MutableDirectedGraphType: DirectedGraphType {
    /// Initializes an empty graph.
    init()

    // MARK: - Required conformances

    /// Adds a given node to this graph.
    mutating func addNode(_ node: Node)

    /// Removes a given node from this graph.
    mutating func removeNode(_ node: Node)

    /// Removes a given edge from this graph.
    mutating func removeEdge(_ edge: Edge)

    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    mutating func addEdge(from start: Node, to end: Node) -> Edge

    // MARK: - Optional conformances

    /// Removes all nodes and edges from this graph.
    mutating func clear()

    /// Returns a subset of this directed graph containing only the nodes from
    /// a given sequence, and all edges present that match start/end nodes within
    /// the sequence.
    func subgraph(of nodes: some Sequence<Node>) -> Self

    /// Adds a sequence of nodes to this graph.
    mutating func addNodes(_ nodes: some Sequence<Node>)

    /// Removes a given sequence of nodes from this graph.
    mutating func removeNodes(_ nodesToRemove: some Sequence<Node>)

    /// Removes an edge between two nodes from this graph.
    mutating func removeEdge(from start: Node, to end: Node)

    /// Removes a given sequence of edges from this graph.
    mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>)

    /// Removes the entry edges from a given node.
    /// Returns the set of edges that where removed.
    @discardableResult
    mutating func removeEntryEdges(towards node: Node) -> Set<Edge>

    /// Removes the exit edges from a given node.
    /// Returns the set of edges that where removed.
    @discardableResult
    mutating func removeExitEdges(from node: Node) -> Set<Edge>

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
    mutating func prepend(_ node: Node, before next: Node)
}

extension MutableDirectedGraphType {
    public func subgraph(of nodes: some Sequence<Node>) -> Self {
        let nodeSet = Set(nodes)
        let connectedEdges = self.edges.filter {
            nodeSet.contains(startNode(for: $0)) && nodeSet.contains(endNode(for: $0))
        }

        var graph = Self()
        graph.addNodes(nodeSet)

        for edge in connectedEdges {
            graph.addEdge(from: startNode(for: edge), to: endNode(for: edge))
        }

        return graph
    }

    public mutating func clear() {
        removeEdges(self.edges)
        removeNodes(self.nodes)
    }

    public mutating func addNodes(_ nodes: some Sequence<Node>) {
        for node in nodes {
            addNode(node)
        }
    }

    public mutating func removeNodes(_ nodesToRemove: some Sequence<Node>) {
        for node in nodesToRemove {
            removeEdges(allEdges(for: node))
            removeNode(node)
        }
    }

    public mutating func removeEdge(from start: Node, to end: Node) {
        if let edge = edge(from: start, to: end) {
            removeEdge(edge)
        }
    }

    public mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>) {
        for edge in edgesToRemove {
            removeEdge(edge)
        }
    }

    @discardableResult
    public mutating func removeEntryEdges(towards node: Node) -> Set<Edge> {
        let connections = edges(towards: node)
        removeEdges(connections)
        return connections
    }

    @discardableResult
    public mutating func removeExitEdges(from node: Node) -> Set<Edge> {
        let connections = edges(from: node)
        removeEdges(connections)
        return connections
    }

    @discardableResult
    public mutating func redirectEntries(for node: Node, to other: Node) -> Set<Edge> {
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

    @discardableResult
    public mutating func redirectExits(for node: Node, to other: Node) -> Set<Edge> {
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

    public mutating func prepend(_ node: Node, before next: Node) {
        if !containsNode(node) {
            addNode(node)
        } else {
            let fromEdges = edges(from: node)
            removeEdges(fromEdges)
        }

        redirectEntries(for: next, to: node)
        addEdge(from: node, to: next)
    }
}
