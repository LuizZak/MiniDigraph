/// Protocol for directed graphs that can be mutated.
public protocol MutableDirectedGraphType: DirectedGraphType {
    /// Initializes an empty graph.
    init()

    /// Returns a subset of this directed graph containing only the nodes from
    /// a given sequence, and all edges present that match start/end nodes within
    /// the sequence.
    func subgraph(of nodes: some Sequence<Node>) -> Self

    /// Removes all nodes and edges from this graph.
    mutating func clear()

    /// Adds a given node to this graph.
    mutating func addNode(_ node: Node)

    /// Adds a sequence of nodes to this graph.
    mutating func addNodes(_ nodes: some Sequence<Node>)

    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    mutating func addEdge(from start: Node, to end: Node) -> Edge

    /// Removes a given node from this graph.
    mutating func removeNode(_ node: Node)

    /// Removes a given sequence of nodes from this graph.
    mutating func removeNodes(_ nodesToRemove: some Sequence<Node>)

    /// Removes a given edge from this graph.
    mutating func removeEdge(_ edge: Edge)

    /// Removes an edge between two nodes from this graph.
    mutating func removeEdge(from start: Node, to end: Node)

    /// Removes a given sequence of edges from this graph.
    mutating func removeEdges(_ edgesToRemove: some Sequence<Edge>)
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
}
