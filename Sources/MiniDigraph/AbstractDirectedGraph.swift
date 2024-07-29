/// A generic implementation of a directed graph for arbitrary hashable `Node`
/// types, with an `Edge` type that conforms to a basic edge protocol.
public struct AbstractDirectedGraph<Node, Edge>
    where Node: Hashable, Edge: AbstractDirectedGraphEdge, Edge.Node == Node
{
    public typealias NodeCollection = Set<Node>
    public typealias EdgeCollection = Set<Edge>

    internal(set) public var nodes: NodeCollection
    internal(set) public var edges: EdgeCollection

    public init() {
        nodes = []
        edges = []
    }

    public init(nodes: some Sequence<Node>) {
        self.nodes = Set(nodes)
        edges = []
    }

    public init(nodes: some Sequence<Node>, edges: some Sequence<Edge>) {
        self.nodes = Set(nodes)
        self.edges = Set(edges)
    }
}

extension AbstractDirectedGraph: Equatable { }

// MARK: - Required conformances

extension AbstractDirectedGraph: DirectedGraphType {
    @inlinable
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    @inlinable
    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    @inlinable
    public func edges(from node: Node) -> [Edge] {
        edges.filter { $0.start == node }
    }

    @inlinable
    public func edges(towards node: Node) -> [Edge] {
        edges.filter { $0.end == node }
    }

    @inlinable
    public func edges(from start: Node, to end: Node) -> [Edge] {
        edges.filter { $0.start == start && $0.end == end }
    }
}

extension AbstractDirectedGraph: MutableDirectedGraphType {
    public mutating func addNode(_ node: Node) {
        nodes.insert(node)
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        assert(nodes.contains(edge.start), "!nodes.contains(edge.start): \(edge.start)")
        assert(nodes.contains(edge.end), "!nodes.contains(edge.end): \(edge.end)")

        return edges.insert(edge).memberAfterInsert
    }

    public mutating func removeNode(_ node: Node) {
        nodes.remove(node)
        edges = edges.filter {
            startNode(for: $0) == node || endNode(for: $0) == node
        }
    }

    public mutating func removeEdge(_ edge: Edge) {
        let result = edges.remove(edge)
        assert(result != nil, "edges.remove(edge) != nil: \(edge)")
    }
}

extension AbstractDirectedGraph: MutableSimpleEdgeDirectedGraphType where Edge: SimpleDirectedGraphEdge {

}

// MARK: - Optimized conformances

public extension AbstractDirectedGraph {
    @inlinable
    func allEdges(for node: Node) -> [Edge] {
        assert(nodes.contains(node), "nodes.contains(node)")
        return edges.filter { $0.start == node || $0.end == node }
    }

    @inlinable
    func nodesConnected(from node: Node) -> [Node] {
        assert(nodes.contains(node), "nodes.contains(node)")
        let nodes = edges.compactMap { edge in
            if edge.start == node {
                edge.end
            } else {
                nil
            }
        }
        return nodes
    }

    @inlinable
    func nodesConnected(towards node: Node) -> [Node] {
        assert(nodes.contains(node), "nodes.contains(node)")
        let nodes = edges.compactMap { edge in
            if edge.end == node {
                edge.start
            } else {
                nil
            }
        }
        return nodes
    }

    @inlinable
    func allNodesConnected(to node: Node) -> [Node] {
        assert(nodes.contains(node), "nodes.contains(node)")
        let nodes = edges.compactMap { edge in
            if edge.end == node {
                edge.start
            } else if edge.start == node {
                edge.end
            } else {
                nil
            }
        }
        return nodes
    }

    @inlinable
    func indegree(of node: Node) -> Int {
        edges.count { $0.end == node }
    }

    @inlinable
    func outdegree(of node: Node) -> Int {
        edges.count { $0.start == node }
    }
}
