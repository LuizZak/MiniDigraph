/// A protocol for representing directed graphs
public protocol DirectedGraphType {
    associatedtype Node: Hashable
    associatedtype Edge: DirectedGraphEdge

    /// Convenience typealias for a visit for visit methods in this directed graph.
    typealias VisitElement = DirectedGraphRecordingVisitElement<Edge, Node>

    /// Gets a set of all nodes in this directed graph.
    var nodes: Set<Node> { get }
    /// Gets a set of all edges in this directed graph.
    var edges: Set<Edge> { get }

    // MARK: Required conformances

    /// Returns the starting edge for a given node on this graph.
    ///
    /// - precondition: `edge` is a valid edge within this graph.
    func startNode(for edge: Edge) -> Node

    /// Returns the ending edge for a given node on this graph.
    ///
    /// - precondition: `edge` is a valid edge within this graph.
    func endNode(for edge: Edge) -> Node

    /// Returns all outgoing edges for a given directed graph node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func edges(from node: Node) -> Set<Edge>

    /// Returns all ingoing edges for a given directed graph node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func edges(towards node: Node) -> Set<Edge>

    /// Returns a set of existing edges between two nodes, or `nil`, if no edges
    /// between them currently exist.
    ///
    /// - precondition: `start` and `end` are valid nodes within this graph.
    func edges(from start: Node, to end: Node) -> Set<Edge>

    // MARK: Optional conformances

    /// Returns `true` if the given node is contained within this graph.
    func containsNode(_ node: Node) -> Bool

    /// Returns `true` if the given edge is contained within this graph.
    func containsEdge(_ edge: Edge) -> Bool

    /// Returns all ingoing and outgoing edges for a given directed graph node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func allEdges(for node: Node) -> Set<Edge>

    /// Returns `true` if the two given nodes are connected with an edge.
    ///
    /// - precondition: `start` and `end` are valid nodes within this graph.
    func areConnected(start: Node, end: Node) -> Bool

    /// Returns all graph nodes that are connected from a given directed graph
    /// node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func nodesConnected(from node: Node) -> Set<Node>

    /// Returns all graph nodes that are connected towards a given directed graph
    /// node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func nodesConnected(towards node: Node) -> Set<Node>

    /// Returns all graph nodes that are connected towards and from the given
    /// graph node.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func allNodesConnected(to node: Node) -> Set<Node>

    /// Returns the indegree of a given node, or the number of edges pointing
    /// towards that node.
    func indegree(of node: Node) -> Int

    /// Returns the outdegree of a given node, or the number of edges pointing
    /// from that node.
    func outdegree(of node: Node) -> Int

    /// Performs a depth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node.
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func depthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge

    /// Performs a breadth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge

    /// Performs a depth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node.
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func depthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool)

    /// Performs a breadth-first visiting of this directed graph, finishing once
    /// all nodes are visited, or when `visitor` returns false, starting at a
    /// given node
    ///
    /// In case a cycle is found, the previously-visited nodes are skipped.
    ///
    /// - precondition: `node` is a valid node within this graph.
    func breadthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool)

    /// Returns `true` if the directed graph has a path between the two given nodes.
    ///
    /// - precondition: `start` and `end` are valid nodes within this graph.
    func hasPath(from start: Node, to end: Node) -> Bool

    /// Returns the shortest number of edges that need to be traversed to get from
    /// the given start node to the given end node.
    ///
    /// If `start == end`, `0` is returned.
    ///
    /// In case the two nodes are not connected, or are connected in the opposite
    /// direction, `nil` is returned.
    ///
    /// - complexity: O(n), where _n_ is the number of nodes and edges in this
    /// graph.
    /// - precondition: `start` and `end` are valid nodes within this graph.
    @inlinable
    func shortestDistance(from start: Node, to end: Node) -> Int?

    /// Returns any of the shortest paths found between two nodes.
    ///
    /// If `start == end`, `[start]` is returned.
    ///
    /// In case the two nodes are not connected, or are connected in the opposite
    /// direction, `nil` is returned.
    ///
    /// - complexity: O(n), where _n_ is the number of nodes and edges in this
    /// graph.
    /// - precondition: `start` and `end` are valid nodes within this graph.
    @inlinable
    func shortestPath(from start: Node, to end: Node) -> [Node]?

    /// Computes and returns the strongly connected components of this directed
    /// graph.
    ///
    /// Each strongly connected component is returned as a set of nodes belonging
    /// to the component.
    ///
    /// A node in this graph only ever shows up once in one of the components.
    ///
    /// Nodes that are not strongly connected to any other node show up as a
    /// set containing that node only.
    ///
    /// The result is sorted in reverse topological order of the acyclic graph
    /// formed by the strongly connected components.
    ///
    /// - complexity: O(n), where _n_ is the number of nodes and edges in this
    /// graph.
    func stronglyConnectedComponents() -> [Set<Node>]

    /// Computes and returns the connected components of this directed graph.
    ///
    /// Each connected component is returned as a set of nodes belonging to the
    /// component, where for each node in a component, there exists an undirected
    /// path reaching every other node in the component.
    ///
    /// A node in this graph only ever shows up once in one of the components.
    ///
    /// Nodes that are not connected to any other node show up as a set containing
    /// that node only.
    ///
    /// - complexity: O(n), where _n_ is the number of nodes and edges in this
    /// graph.
    func connectedComponents() -> Set<Set<Node>>

    /// Returns cycles found within a this graph returned from a given start
    /// node.
    ///
    /// Returns an array of array of nodes that connects from `start` into a cycle,
    /// with the remaining nodes looping from the last index into an earlier index.
    ///
    /// - precondition: `start` is contained within this graph.
    func findCycles(from start: Node) -> [[Node]]

    /// Returns a list which represents the [topologically sorted] nodes of this
    /// graph. The order of the sorted elements is not guaranteed.
    ///
    /// Returns nil, in case it cannot be topologically sorted, when e.g. any
    /// cycles are found.
    ///
    /// - Returns: A list of the nodes from this graph, topologically sorted, or
    /// `nil`, in case it cannot be sorted.
    ///
    /// [topologically sorted]: https://en.wikipedia.org/wiki/Topological_sorting
    func topologicalSorted() -> [Node]?

    /// Returns a list which represents the [topologically sorted] nodes of this
    /// graph. If two or more nodes can be placed in the same position in the
    /// resulting array, an ordering callback `areInIncreasingOrder` is used to
    /// alter the order of the results.
    ///
    /// Returns nil, in case it cannot be topologically sorted, when e.g. any
    /// cycles are found.
    ///
    /// - Returns: A list of the nodes from this graph, topologically sorted, or
    /// `nil`, in case it cannot be sorted.
    ///
    /// [topologically sorted]: https://en.wikipedia.org/wiki/Topological_sorting
    func topologicalSorted(breakTiesWith areInIncreasingOrder: (Node, Node) -> Bool) -> [Node]?
}

public extension DirectedGraphType {
    @inlinable
    func containsNode(_ node: Node) -> Bool {
        nodes.contains(node)
    }

    @inlinable
    func containsEdge(_ edge: Edge) -> Bool {
        edges.contains(edge)
    }

    @inlinable
    func allEdges(for node: Node) -> Set<Edge> {
        edges(towards: node).union(edges(from: node))
    }

    @inlinable
    func areConnected(start: Node, end: Node) -> Bool {
        !edges(from: start, to: end).isEmpty
    }

    @inlinable
    func nodesConnected(from node: Node) -> Set<Node> {
        Set(edges(from: node).map(self.endNode(for:)))
    }

    @inlinable
    func nodesConnected(towards node: Node) -> Set<Node> {
        Set(edges(towards: node).map(self.startNode(for:)))
    }

    @inlinable
    func allNodesConnected(to node: Node) -> Set<Node> {
        nodesConnected(towards: node).union(nodesConnected(from: node))
    }

    @inlinable
    func indegree(of node: Node) -> Int {
        edges(towards: node).count
    }

    @inlinable
    func outdegree(of node: Node) -> Int {
        edges(from: node).count
    }

    func depthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge {
        var visited: Set<Node> = []
        var queue: [VisitElement] = []

        queue.append(start)

        while let next = queue.popLast() {
            visited.insert(next.node)

            if !visitor(next) {
                return
            }

            for nextEdge in edges(from: next.node).reversed() {
                let node = endNode(for: nextEdge)
                if visited.contains(node) {
                    continue
                }

                queue.append(next.appendingVisit(nextEdge, towards: node))
            }
        }
    }

    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement,
        _ visitor: (VisitElement) -> Bool
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge {
        var visited: Set<Node> = []
        var queue: [VisitElement] = []

        queue.append(start)

        while !queue.isEmpty {
            let next = queue.removeFirst()
            visited.insert(next.node)

            if !visitor(next) {
                return
            }

            for nextEdge in edges(from: next.node) {
                let node = endNode(for: nextEdge)
                if visited.contains(node) {
                    continue
                }

                queue.append(next.appendingVisit(nextEdge, towards: node))
            }
        }
    }

    @inlinable
    func depthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool) {
        depthFirstVisit(start: VisitElement.start(start), visitor)
    }

    @inlinable
    func breadthFirstVisit(start: Node, _ visitor: (VisitElement) -> Bool) {
        breadthFirstVisit(start: VisitElement.start(start), visitor)
    }

    @inlinable
    func hasPath(from start: Node, to end: Node) -> Bool {
        var found = false
        depthFirstVisit(start: DirectedGraphVisitElement.start(start)) { visit in
            if visit.node == end {
                found = true
                return false
            }

            return true
        }

        return found
    }

    @inlinable
    func shortestDistance(from start: Node, to end: Node) -> Int? {
        if let path = shortestPath(from: start, to: end) {
            return path.count - 1
        }

        return nil
    }

    @inlinable
    func shortestPath(from start: Node, to end: Node) -> [Node]? {
        var path: VisitElement?

        breadthFirstVisit(start: start) { visit in
            if visit.node == end {
                path = visit
                return false
            }

            return true
        }

        return path?.allNodes
    }

    @inlinable
    func stronglyConnectedComponents() -> [Set<Node>] {
        var result: [Set<Node>] = []

        var indices: [Node: Int] = [:]
        var stack: [Node] = []
        var index = 0

        func strongConnect(_ node: Node) -> Int {
            var lowLink = index
            indices[node] = index
            index += 1
            stack.append(node)

            for next in self.nodesConnected(from: node) {
                guard let nextIndex = indices[next] else {
                    // Not been visited
                    lowLink = min(lowLink, strongConnect(next))
                    continue
                }

                if stack.contains(next) {
                    lowLink = min(lowLink, nextIndex)
                }
            }

            if lowLink == indices[node], let idx = stack.lastIndex(of: node) {
                result.append(Set(stack[idx...]))
                stack.removeSubrange(idx...)
            }

            return lowLink
        }

        for node in nodes {
            if indices[node] == nil {
                _=strongConnect(node)
            }
        }

        return result
    }

    @inlinable
    func connectedComponents() -> Set<Set<Node>> {
        var result: Set<Set<Node>> = []
        var remaining = Set(self.nodes)

        while let start = remaining.popFirst() {
            var component: Set<Node> = []
            var nextNodes: [Node] = [start]

            while !nextNodes.isEmpty {
                let next = nextNodes.removeFirst()
                remaining.remove(next)
                guard component.insert(next).inserted else {
                    // Already visited
                    continue
                }

                let connected = allNodesConnected(to: next)
                nextNodes.append(contentsOf: connected)
            }

            result.insert(component)
        }

        return result
    }

    @inlinable
    func findCycles(from start: Node) -> [[Node]] {
        assert(nodes.contains(start), "!nodes.contains(start)")

        var result: [[Node]] = []

        func inner(node: Node, path: [Node]) {
            if path.contains(node) {
                result.append(path + [node])
                return
            }

            let path = path + [node]
            for next in nodesConnected(from: node) {
                inner(node: next, path: path)
            }
        }

        inner(node: start, path: [])

        return result
    }

    /// Returns a list which represents the [topologically sorted] nodes of this
    /// graph.
    ///
    /// Returns nil, in case it cannot be topologically sorted, when e.g. any
    /// cycles are found.
    ///
    /// - Returns: A list of the nodes from this graph, topologically sorted, or
    /// `nil`, in case it cannot be sorted.
    ///
    /// [topologically sorted]: https://en.wikipedia.org/wiki/Topological_sorting
    @inlinable
    func topologicalSorted() -> [Node]? {
        var permanentMark: Set<Node> = []
        var temporaryMark: Set<Node> = []

        var unmarkedNodes = nodes
        var list: [Node] = []

        func visit(_ node: Node) -> Bool {
            if permanentMark.contains(node) {
                return true
            }
            if temporaryMark.contains(node) {
                return false
            }
            temporaryMark.insert(node)
            for next in nodesConnected(from: node) {
                if !visit(next) {
                    return false
                }
            }
            permanentMark.insert(node)
            list.insert(node, at: 0)
            return true
        }

        while let node = unmarkedNodes.popFirst() {
            if !visit(node) {
                return nil
            }
        }

        return list
    }

    /// Returns a list which represents the [topologically sorted] nodes of this
    /// graph. If two or more nodes can be placed in the same position in the
    /// resulting array, an ordering callback `areInIncreasingOrder` is used to
    /// alter the order of the results.
    ///
    /// Returns nil, in case it cannot be topologically sorted, when e.g. any
    /// cycles are found.
    ///
    /// - Returns: A list of the nodes from this graph, topologically sorted, or
    /// `nil`, in case it cannot be sorted.
    ///
    /// [topologically sorted]: https://en.wikipedia.org/wiki/Topological_sorting
    @inlinable
    func topologicalSorted(breakTiesWith areInIncreasingOrder: (Node, Node) -> Bool) -> [Node]? {
        var result: [Node] = []
        var nodeEdgeLookup: [Node: Set<Edge>] = [:]
        var nextNodes: [Node] = []

        func queueNode(_ node: Node) {
            if nextNodes.isEmpty {
                nextNodes.append(node)
            } else {
                let index = nextNodes.firstIndex { current in
                    areInIncreasingOrder(node, current)
                }
                nextNodes.insert(node, at: index ?? nextNodes.endIndex)
            }
        }

        func innerEdgesFrom(_ node: Node) -> Set<Edge> {
            nodeEdgeLookup[node, default: []].filter({ startNode(for: $0) == node })
        }

        func innerIndegree(_ node: Node) -> Int {
            let towards = nodeEdgeLookup[node, default: []].filter({ endNode(for: $0) == node })
            return towards.count
        }

        func innerEraseEdge(_ edge: Edge) {
            let start = startNode(for: edge)
            let end = endNode(for: edge)

            nodeEdgeLookup[start]?.remove(edge)
            nodeEdgeLookup[end]?.remove(edge)
        }

        func checkNode(_ node: Node) {
            guard innerIndegree(node) == 0 else {
                return
            }

            queueNode(node)
        }

        // Populate edges
        for node in nodes {
            nodeEdgeLookup[node] = self.allEdges(for: node)
        }

        // Populate with all nodes with no incoming edges
        for node in nodes where innerIndegree(node) == 0 {
            nextNodes.append(node)
        }
        nextNodes.sort(by: areInIncreasingOrder)

        while !nextNodes.isEmpty {
            let node = nextNodes.removeFirst()
            result.append(node)

            for edge in innerEdgesFrom(node) {
                innerEraseEdge(edge)

                let end = endNode(for: edge)
                checkNode(end)
            }
        }

        if nodeEdgeLookup.contains(where: { !$0.value.isEmpty }) {
            // Cycle found
            return nil
        }

        return result
    }
}

public extension DirectedGraphType where Self.Edge: AbstractDirectedGraphEdge, Self.Edge.Node == Node {
    @inlinable
    func startNode(for edge: Edge) -> Node {
        edge.start
    }

    @inlinable
    func endNode(for edge: Edge) -> Node {
        edge.end
    }

    @inlinable
    func edges(from node: Node) -> Set<Edge> {
        self.edges.filter { $0.start == node }
    }

    @inlinable
    func edges(towards node: Node) -> Set<Edge> {
        self.edges.filter { $0.end == node }
    }

    @inlinable
    func edges(from start: Node, to end: Node) -> Set<Edge> {
        self.edges.filter { $0.start == start && $0.end == end }
    }

    @inlinable
    func indegree(of node: Node) -> Int {
        self.edges.count { $0.end == node }
    }

    @inlinable
    func outdegree(of node: Node) -> Int {
        self.edges.count { $0.start == node }
    }
}
