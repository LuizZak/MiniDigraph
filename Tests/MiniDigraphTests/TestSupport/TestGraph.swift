import MiniDigraph

class TestGraph {
    typealias Edge = TestEdge<Node>

    var nodes: Set<Node> = []
    var edges: Set<Edge> = []

    required init() {

    }

    func addNode(_ value: Int) -> Node {
        let node = Node(value: value)
        nodes.insert(node)
        return node
    }

    func addNodes(values: some Sequence<Int>) -> [Node] {
        values.map(addNode)
    }

    @discardableResult
    func addMutualEdges(from start: Node, to end: Node) -> [Edge] {
        return [
            addEdge(from: start, to: end),
            addEdge(from: end, to: start),
        ]
    }

    class Node: Hashable, CustomDebugStringConvertible, CustomStringConvertible {
        var value: Int

        var debugDescription: String {
            "node #\(value)"
        }

        var description: String {
            value.description
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
}
