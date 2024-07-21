/// A copy-on-write backed directed graph that performs internal caching of edges
/// across nodes to improve performance of edge lookups and related operations.
///
/// - note: Not thread-safe.
public struct CachingDirectedGraph<Node: Hashable, Edge: AbstractDirectedGraphEdge>: DirectedGraphType where Edge.Node == Node {
    @usableFromInline
    internal var _object: _Cache

    public var nodes: Set<Node> {
        _object.nodes
    }

    public var edges: Set<Edge> {
        _object.allEdges
    }

    public init() {
        _object = _Cache()
    }

    mutating func ensuringUnique() -> _Cache {
        if !isKnownUniquelyReferenced(&_object) {
            _object = _object.copy()
        }

        return _object
    }

    mutating func ensureUnique() {
        _=ensuringUnique()
    }

    public func edges(from node: Node) -> Set<Edge> {
        _object.edgesFromNode[node, default: []]
    }

    public func edges(towards node: Node) -> Set<Edge> {
        _object.edgesTowardsNode[node, default: []]
    }

    public func edge(from start: Node, to end: Node) -> Edge? {
        _object.edgesFromNode[start]?.first(where: { $0.end == end })
    }

    public func indegree(of node: Node) -> Int {
        _object.edgesTowardsNode[node]?.count ?? 0
    }

    public func outdegree(of node: Node) -> Int {
        _object.edgesFromNode[node]?.count ?? 0
    }

    @usableFromInline
    internal final class _Cache {
        private(set) var nodes: Set<Node>
        private(set) var allEdges: Set<Edge>
        private(set) var edgesFromNode: [Node: Set<Edge>]
        private(set) var edgesTowardsNode: [Node: Set<Edge>]

        @usableFromInline
        convenience init() {
            self.init(
                nodes: [],
                allEdges: [],
                edgesFromNode: [:],
                edgesTowardsNode: [:]
            )
        }

        @usableFromInline
        init(
            nodes: Set<Node>,
            allEdges: Set<Edge>,
            edgesFromNode: [Node: Set<Edge>],
            edgesTowardsNode: [Node: Set<Edge>]
        ) {
            self.nodes = nodes
            self.allEdges = allEdges
            self.edgesFromNode = edgesFromNode
            self.edgesTowardsNode = edgesTowardsNode
        }

        @usableFromInline
        func copy() -> _Cache {
            return _Cache(
                nodes: nodes,
                allEdges: allEdges,
                edgesFromNode: edgesFromNode,
                edgesTowardsNode: edgesTowardsNode
            )
        }

        func _addFromEdge(_ node: Node, _ edge: Edge) {
            precondition(nodes.contains(node))
            edgesFromNode[node, default: []].insert(edge)
        }

        func _removeFromEdge(_ node: Node, _ edge: Edge) {
            precondition(nodes.contains(node))
            edgesFromNode[node, default: []].remove(edge)
        }

        func _addTowardsEdge(_ node: Node, _ edge: Edge) {
            precondition(nodes.contains(node))
            edgesTowardsNode[node, default: []].insert(edge)
        }

        func _removeTowardsEdge(_ node: Node, _ edge: Edge) {
            precondition(nodes.contains(node))
            edgesTowardsNode[node, default: []].remove(edge)
        }

        func _addNode(_ node: Node) {
            if nodes.insert(node).inserted {
                edgesFromNode[node] = []
                edgesTowardsNode[node] = []
            }
        }

        func _removeNode(_ node: Node) {
            guard nodes.contains(node) else {
                preconditionFailure("Attempted to remove a node that was not part of this graph: \(node)")
            }

            for edge in edgesFromNode[node, default: []] {
                _removeEdge(edge)
            }
            for edge in edgesTowardsNode[node, default: []] {
                _removeEdge(edge)
            }

            edgesFromNode.removeValue(forKey: node)
            edgesTowardsNode.removeValue(forKey: node)
            nodes.remove(node)
        }

        func _removeNodes(_ nodesToRemove: some Collection<Node>) {
            guard nodesToRemove.allSatisfy(nodes.contains(_:)) else {
                preconditionFailure("Attempted to remove one or more nodes that were not part of this graph: \(nodesToRemove)")
            }

            for node in nodesToRemove {
                let edgesFrom = edgesFromNode[node, default: []]
                let edgesTo = edgesTowardsNode[node, default: []]

                allEdges.subtract(edgesFrom)
                allEdges.subtract(edgesTo)

                edgesFromNode.removeValue(forKey: node)
                edgesTowardsNode.removeValue(forKey: node)

                for edgeFrom in edgesFrom {
                    edgesTowardsNode[edgeFrom.end]?.remove(edgeFrom)
                }
                for edgeTo in edgesTo {
                    edgesFromNode[edgeTo.start]?.remove(edgeTo)
                }
            }

            nodes.subtract(nodesToRemove)
        }

        func _addEdge(_ edge: Edge) -> Edge {
            let (inserted, existing) = allEdges.insert(edge)
            guard inserted else {
                return existing
            }

            _addFromEdge(edge.start, edge)
            _addTowardsEdge(edge.end, edge)

            return edge
        }

        func _removeEdge(_ edge: Edge) {
            guard allEdges.remove(edge) != nil else {
                preconditionFailure("Attempted to remove an edge that was not part of this graph: \(edge)")
            }

            _removeFromEdge(edge.start, edge)
            _removeTowardsEdge(edge.end, edge)
        }
    }
}

extension CachingDirectedGraph: MutableDirectedGraphType {
    public mutating func addNode(_ node: Node) {
        ensuringUnique()._addNode(node)
    }

    public mutating func removeNode(_ node: Node) {
        ensuringUnique()._removeNode(node)
    }

    public mutating func removeNodes(_ nodesToRemove: some Sequence<Node>) {
        ensuringUnique()._removeNodes(Array(nodesToRemove))
    }

    @discardableResult
    public mutating func addEdge(_ edge: Edge) -> Edge {
        ensuringUnique()._addEdge(edge)
    }

    public mutating func removeEdge(_ edge: Edge) {
        ensuringUnique()._removeEdge(edge)
    }
}

extension CachingDirectedGraph: MutableSimpleEdgeDirectedGraphType
    where Edge: SimpleDirectedGraphEdge {
}
