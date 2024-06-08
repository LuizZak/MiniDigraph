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

    class Node: DirectedGraphNode, CustomDebugStringConvertible {
        var value: Int

        var debugDescription: String {
            "node #\(value)"
        }

        init(value: Int) {
            self.value = value
        }
    }

    struct Edge: DirectedGraphEdge, CustomDebugStringConvertible {
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
