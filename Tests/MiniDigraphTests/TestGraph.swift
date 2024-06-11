import MiniDigraph

class TestGraph {
    var nodes: Set<Node> = []
    var edges: Set<Edge> = []

    required init() {

    }

    func addNode(_ value: Int) -> Node {
        let node = Node(value: value)
        nodes.insert(node)
        return node
    }

    @discardableResult
    func addMutualEdges(from start: Node, to end: Node) -> [Edge] {
        return [
            addEdge(from: start, to: end),
            addEdge(from: end, to: start),
        ]
    }

    class Node: Hashable, CustomDebugStringConvertible {
        var value: Int

        var debugDescription: String {
            "node #\(value)"
        }

        init(value: Int) {
            self.value = value
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
        }

        static func == (lhs: Node, rhs: Node) -> Bool {
            lhs === rhs
        }
    }

    struct Edge: SimpleDirectedGraphEdge, CustomDebugStringConvertible {
        var start: Node
        var end: Node

        var debugDescription: String {
            "\(start.value) => \(end.value)"
        }

        init(start: TestGraph.Node, end: TestGraph.Node) {
            self.start = start
            self.end = end
        }
    }
}
