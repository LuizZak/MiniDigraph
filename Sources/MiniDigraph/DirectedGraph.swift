/// A generic implementation of a directed graph for arbitrary hashable `Node`
/// types, with a default `Edge` type implementation provided.
public struct DirectedGraph<Node> where Node: Hashable {
    public var nodes: Set<Node>
    public var edges: Set<Edge>

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

    /// A default edge implementation.
    public struct Edge: DirectedGraphEdge {
        public var start: Node
        public var end: Node

        public init(start: Node, end: Node) {
            self.start = start
            self.end = end
        }
    }
}

extension DirectedGraph: Equatable { }
extension DirectedGraph.Edge: CustomStringConvertible where DirectedGraph.Node: CustomStringConvertible {
    public var description: String {
        "\(start.description) -> \(end.description)"
    }
}

// MARK: - Required conformances

extension DirectedGraph: DirectedGraphType {
    @inlinable
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    @inlinable
    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    @inlinable
    public func edges(from node: Node) -> Set<Edge> {
        edges.filter { $0.start == node }
    }

    @inlinable
    public func edges(towards node: Node) -> Set<Edge> {
        edges.filter { $0.end == node }
    }

    @inlinable
    public func edge(from start: Node, to end: Node) -> Edge? {
        edges.first { $0.start == start && $0.end == end }
    }
}

extension DirectedGraph: MutableDirectedGraphType {
    /// Returns a new graph where each node is a strongly connected component
    /// within `self`, compacting the nodes and their connections to a single
    /// element of type `Element`.
    ///
    /// The result of this operation is always a directed acyclic graph.
    public func stronglyConnectedSubgraph<Element>(
        _ transform: (Set<Node>) -> Element
    ) -> DirectedGraph<Element> {

        var subgraph = DirectedGraph<Element>()
        let components = self.stronglyConnectedComponents()
        var componentMap: [Node: Element] = [:]

        for component in components {
            let newNode = transform(component)
            for node in component {
                componentMap[node] = newNode
            }

            subgraph.addNode(newNode)
        }

        // Map edges
        for edge in edges {
            guard let start = componentMap[edge.start], let end = componentMap[edge.end] else {
                // Found edge pointing to node not part of any components?
                continue
            }
            // Avoid cycles pointing back to the original node
            guard start != end else {
                continue
            }

            subgraph.addEdge(from: start, to: end)
        }

        return subgraph
    }

    public mutating func addNode(_ node: Node) {
        nodes.insert(node)
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        return edges.insert(edge).memberAfterInsert
    }

    public mutating func removeNode(_ node: Node) {
        nodes.remove(node)
        edges = edges.filter {
            startNode(for: $0) == node || endNode(for: $0) == node
        }
    }

    public mutating func removeEdge(_ edge: Edge) {
        edges.remove(edge)
    }

    @discardableResult
    public mutating func addEdge(from start: Node, to end: Node) -> Edge {
        return addEdge(Edge(start: start, end: end))
    }
}

// MARK: - Optimized conformances

public extension DirectedGraph {
    @inlinable
    func allEdges(for node: Node) -> Set<Edge> {
        edges.filter { $0.start == node && $0.end == node }
    }

    @inlinable
    func nodesConnected(from node: Node) -> Set<Node> {
        let nodes = edges.compactMap { edge in
            if edge.start == node {
                edge.end
            } else {
                nil
            }
        }
        return Set(nodes)
    }

    @inlinable
    func nodesConnected(towards node: Node) -> Set<Node> {
        let nodes = edges.compactMap { edge in
            if edge.end == node {
                edge.start
            } else {
                nil
            }
        }
        return Set(nodes)
    }

    @inlinable
    func allNodesConnected(to node: Node) -> Set<Node> {
        let nodes = edges.compactMap { edge in
            if edge.end == node {
                edge.start
            } else if edge.start == node {
                edge.end
            } else {
                nil
            }
        }
        return Set(nodes)
    }
}
