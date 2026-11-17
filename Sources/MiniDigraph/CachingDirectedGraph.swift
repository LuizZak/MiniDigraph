/// A copy-on-write backing directed graph cache that performs internal caching
/// of expensing lookups to improve performance of edge lookups and related
/// operations.
///
/// - note: Using reference-types as inputs for caching may result in incorrect
/// behavior when copies of `CachingDirectedGraph` are created from the graph
/// type.
/// - note: Not thread-safe.
public struct CachingDirectedGraph<Graph: DirectedGraphType>
    where
        Graph.Edge: AbstractDirectedGraphEdge,
        Graph.Edge.Node == Graph.NodeCollection.Element
{
    public typealias NodeCollection = Graph.NodeCollection
    public typealias EdgeCollection = Graph.EdgeCollection

    @usableFromInline
    var cache: Cache

    @usableFromInline
    var graph: Graph {
        cache.graph
    }

    /// Initializes this caching graph with a given input graph type.
    public init(graph: Graph) {
        self.cache = .init(graph: graph)
    }

    /// Initializes this caching graph with a given input graph type.
    public init(graph: CachingDirectedGraph<Graph>) {
        self.cache = graph.cache.copy()
    }

    mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&cache) {
            cache = cache.copy()
        }
    }

    @usableFromInline
    class Cache {
        typealias Node = Graph.Node
        typealias Edge = Graph.Edge

        @usableFromInline
        var graph: Graph

        var edgesTowardsNode: [Node: Set<Edge>]
        var edgesFromNode: [Node: Set<Edge>]

        init(
            graph: Graph,
            edgesTowardsNode: [Node: Set<Edge>] = [:],
            edgesFromNode: [Node: Set<Edge>] = [:]
        ) {
            self.graph = graph
            self.edgesTowardsNode = edgesTowardsNode
            self.edgesFromNode = edgesFromNode
        }

        func copy() -> Cache {
            return .init(
                graph: graph,
                edgesTowardsNode: edgesTowardsNode,
                edgesFromNode: edgesFromNode
            )
        }
    }
}

extension CachingDirectedGraph.Cache where Graph: MutableDirectedGraphType {
}

extension CachingDirectedGraph: DirectedGraphType {
    public func startNode(for edge: Edge) -> Node {
        edge.start
    }

    public func endNode(for edge: Edge) -> Node {
        edge.end
    }

    public func edges(from node: Node) -> [Edge] {
        Array(cache.edgesFromNode[node, default: []])
    }

    public func edges(towards node: Node) -> [Edge] {
        Array(cache.edgesTowardsNode[node, default: []])
    }

    public func edges(from start: Node, to end: Node) -> [Edge] {
        cache.edgesFromNode[start]?.filter({ $0.end == end }) ?? []
    }
}
