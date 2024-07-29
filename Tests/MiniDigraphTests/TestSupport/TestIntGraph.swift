import MiniDigraph

struct TestIntGraph {
    typealias Node = Int
    typealias Edge = TestEdge<Node>

    var nodes: Set<Node> = []
    var edges: Set<Edge> = []

    init() {

    }

    @discardableResult
    mutating func addMutualEdges(from start: Node, to end: Node) -> [Edge] {
        return [
            addEdge(from: start, to: end),
            addEdge(from: end, to: start),
        ]
    }
}

extension TestIntGraph: MutableDirectedGraphType {
    mutating func addNode(_ node: Node) {
        nodes.insert(node)
    }

    mutating func removeNode(_ node: Node) {
        nodes.remove(node)
    }

    mutating func removeEdge(_ edge: Edge) {
        edges.remove(edge)
    }

    @discardableResult
    mutating func addEdge(_ edge: Edge) -> Edge {
        edges.insert(edge)
        return edge
    }

    @discardableResult
    mutating func addEdge(from start: Node, to end: Node) -> Edge {
        addEdge(Edge(start: start, end: end))
    }
}

extension TestIntGraph: MutableSimpleEdgeDirectedGraphType {

}
