// TODO: Refactor DirectedGraphType to DirectedGraphType or other name so we can use
// TODO: 'DirectedGraphType' as the name of this class instead of this awkward name
public final class GenericDirectedGraph<T>: DirectedGraphBase<GenericDirectedGraph<T>.Node, GenericDirectedGraph<T>.Edge> {
    @discardableResult
    public func addNode(_ value: T) -> Node {
        let node = Node(value: value)
        addNode(node)

        return node
    }

    @discardableResult
    public func addNodes(_ values: some Sequence<T>) -> [Node] {
        values.map(addNode)
    }

    @discardableResult
    public func addEdge(from startRule: T, to endRule: T) -> Edge where T: Equatable {
        guard let start = nodes.first(where: { $0.value == startRule }) else {
            fatalError("Node with value '\(startRule)' doesn't exist in this graph.")
        }
        guard let end = nodes.first(where: { $0.value == endRule }) else {
            fatalError("Node with value '\(endRule)' doesn't exist in this graph.")
        }

        return addEdge(from: start, to: end)
    }

    @discardableResult
    public override func addEdge(from start: Node, to end: Node) -> Edge {
        let edge = Edge(start: start, end: end)

        edges.append(edge)

        return edge
    }

    public final class Node: DirectedGraphNode, CustomStringConvertible {
        public let value: T

        public var description: String {
            "\(type(of: self))(value: \(value))"
        }

        public init(value: T) {
            self.value = value
        }
    }

    public final class Edge: DirectedGraphBaseEdgeType {
        public let start: Node
        public let end: Node

        internal init(start: Node, end: Node) {
            self.start = start
            self.end = end
        }

        public func copy() -> Self {
            return .init(start: start, end: end)
        }
    }
}
