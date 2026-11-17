import MiniDigraph

struct TestIntGraph {
    typealias NodeCollection = Set<Int>
    typealias EdgeCollection = Set<TestEdge<Int>>
}

extension TestIntGraph: DirectedGraphType {
}

/// A basic test edge type.
struct TestEdge<Node: Hashable>: SimpleDirectedGraphEdge, CustomStringConvertible {
    var start: Node
    var end: Node

    var debugDescription: String {
        "\(start) => \(end)"
    }

    var description: String {
        "\(start) => \(end)"
    }

    init(start: Node, end: Node) {
        self.start = start
        self.end = end
    }
}
