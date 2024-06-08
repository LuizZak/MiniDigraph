/// A base class for directed graph class implementations in this module.
public class DirectedGraphBase<Node, Edge: DirectedGraphBaseEdgeType>: MutableDirectedGraphType where Edge.Node == Node {
    /// A list of all nodes contained in this graph
    internal(set) public var nodes: [Node] = []
    /// A list of all edges contained in this graph
    internal(set) public var edges: [Edge] = []

    /// Initializes an empty directed graph.
    public required convenience init() {
        self.init(nodes: [], edges: [])
    }

    public init(nodes: [Node], edges: [Edge]) {
        self.nodes = nodes
        self.edges = edges
    }

    @inlinable
    public func subgraph(of nodes: some Sequence<Node>) -> Self {
        let nodeSet = Set(nodes)
        let connectedEdges = self.edges.filter {
            nodeSet.contains($0.start) && nodeSet.contains($0.end)
        }

        let graph = Self()
        graph.addNodes(nodeSet)

        for edge in connectedEdges {
            graph.addEdge(from: edge.start, to: edge.end)
        }

        return graph
    }

    /// Returns `true` iff two node references represent the same underlying node
    /// in this graph.
    @inlinable
    public func areNodesEqual(_ node1: Node, _ node2: Node) -> Bool {
        node1 === node2
    }

    /// Returns whether a given graph node exists in this graph.
    ///
    /// A reference equality test (===) is used to determine syntax node equality.
    @inlinable
    public func containsNode(_ node: Node) -> Bool {
        nodes.contains { $0 === node }
    }

    @inlinable
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    @inlinable
    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    /// Returns all outgoing edges for a given graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(from node: Node) -> [Edge] {
        edges.filter { $0.start === node }
    }

    /// Returns all ingoing edges for a given graph node.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edges(towards node: Node) -> [Edge] {
        edges.filter { $0.end === node }
    }

    /// Returns an existing edge between two nodes, or `nil`, if no edges between
    /// them currently exist.
    ///
    /// A reference equality test (===) is used to determine graph node equality.
    public func edge(from start: Node, to end: Node) -> Edge? {
        edges.first { $0.start === start && $0.end === end }
    }

    public func nodesConnected(towards node: Node) -> [Node] {
        edges.compactMap { edge in
            if edge.end == node {
                edge.start
            } else {
                nil
            }
        }
    }

    public func nodesConnected(from node: Node) -> [Node] {
        edges.compactMap { edge in
            if edge.start == node {
                edge.end
            } else {
                nil
            }
        }
    }

    public func allNodesConnected(to node: Node) -> [Node] {
        edges.compactMap { edge in
            if edge.start == node {
                edge.end
            } else if edge.end == node {
                edge.start
            } else {
                nil
            }
        }
    }

    // MARK: - Internals

    /// Removes all nodes and edges from this graph.
    public func clear() {
        nodes.removeAll()
        edges.removeAll()
    }

    /// Adds a given node to this graph.
    public func addNode(_ node: Node) {
        assert(
            !self.containsNode(node),
            "Node \(node) already exists in this graph"
        )

        nodes.append(node)
    }

    /// Adds a sequence of nodes to this graph.
    public func addNodes<S: Sequence>(_ nodes: S) where S.Element == Node {
        nodes.forEach(addNode)
    }

    /// Adds an edge `start -> end` to this graph, if one doesn't already exists.
    @discardableResult
    public func ensureEdge(from start: Node, to end: Node) -> Edge {
        if let existing = edge(from: start, to: end) {
            return existing
        }

        return addEdge(from: start, to: end)
    }

    /// Adds an edge `start -> end` to this graph.
    @discardableResult
    public func addEdge(from start: Node, to end: Node) -> Edge {
        fatalError("Must be implemented by subclasses")
    }

    /// Adds a given edge to this graph.
    func addEdge(_ edge: Edge) {
        edges.append(edge)
    }

    @discardableResult
    private func _uncheckedRemoveNode(_ node: Node) -> Bool {
        if let index = nodes.firstIndex(where: { areNodesEqual($0, node) }) {
            nodes.remove(at: index)
            return true
        }
        return false
    }

    @discardableResult
    private func _uncheckedRemoveEdge(_ edge: Edge) -> Bool {
        if let index = edges.firstIndex(where: { areEdgesEqual($0, edge) }) {
            edges.remove(at: index)
            return true
        }
        return false
    }

    /// Removes a given edge from this graph.
    public func removeEdge(_ edge: Edge) {
        if !_uncheckedRemoveEdge(edge) {
            assertionFailure("Attempted to remove edge \(edge) that is not a member of this graph.")
        }
    }

    /// Removes an edge between two nodes from this graph.
    public func removeEdge(from start: Node, to end: Node) {
        func predicate(_ edge: Edge) -> Bool {
            areNodesEqual(edge.start, start) && self.areNodesEqual(edge.end, end)
        }

        var found = false
        for edge in edges.filter(predicate) {
            _uncheckedRemoveEdge(edge)
            found = true
        }

        assert(
            found,
            "Attempted to remove edge from nodes \(start) -> \(end) that do not exist in this graph."
        )
    }

    /// Removes a given node from this graph.
    public func removeNode(_ node: Node) {
        if _uncheckedRemoveNode(node) {
            removeEdges(allEdges(for: node))
        } else {
            assertionFailure(
                "Attempted to remove a node that is not present in this graph: \(node)."
            )
        }
    }

    /// Removes a given sequence of edges from this graph.
    public func removeEdges<S: Sequence>(_ edgesToRemove: S) where S.Element == Edge {
        for edge in edgesToRemove {
            _uncheckedRemoveEdge(edge)
        }
    }

    /// Removes a given sequence of nodes from this graph.
    public func removeNodes<S: Sequence>(_ nodesToRemove: S) where S.Element == Node {
        for node in nodesToRemove {
            removeEdges(allEdges(for: node))
            removeNode(node)
        }
    }

    /// Removes the entry edges from a given node.
    @discardableResult
    func removeEntryEdges(towards node: Node) -> [Edge] {
        let connections = edges(towards: node)
        removeEdges(connections)
        return connections
    }

    /// Removes the exit edges from a given node.
    @discardableResult
    func removeExitEdges(from node: Node) -> [Edge] {
        let connections = edges(from: node)
        removeEdges(connections)
        return connections
    }

    /// Moves the entry edges from a given node to a target node.
    ///
    /// The existing entry edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    func redirectEntries(for node: Node, to other: Node) -> [Edge] {
        var result: [Edge] = []

        for connection in removeEntryEdges(towards: node) {
            guard !areConnected(start: connection.start, end: other) else {
                continue
            }

            let edge = addEdge(from: connection.start, to: other)

            result.append(edge)
        }

        return result
    }

    /// Moves the exit edges from a given node to a target node.
    ///
    /// The existing exit edges for `other` are kept as is.
    ///
    /// The return list contains the new edges that where created.
    @discardableResult
    func redirectExits(for node: Node, to other: Node) -> [Edge] {
        var result: [Edge] = []

        for connection in removeExitEdges(from: node) {
            guard !areConnected(start: other, end: connection.end) else {
                continue
            }

            let edge = addEdge(from: other, to: connection.end)

            result.append(edge)
        }

        return result
    }

    /// Prepends a node before a suffix node, redirecting the entries to the
    /// suffix node to the prefix node, and adding an edge from the prefix to the
    /// suffix node.
    func prepend(_ node: Node, before next: Node) {
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

public protocol DirectedGraphBaseEdgeType: AnyObject, DirectedGraphEdge {
    associatedtype Node: AnyObject & DirectedGraphNode

    var start: Node { get }
    var end: Node { get }
}
