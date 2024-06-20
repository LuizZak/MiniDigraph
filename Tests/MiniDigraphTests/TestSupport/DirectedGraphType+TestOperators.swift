import MiniDigraph

// Convenience operator for generating edges
infix operator => : MultiplicationPrecedence

// Convenience operator for generating edges
infix operator <=> : MultiplicationPrecedence

// Convenience operator for generating visit elements
infix operator ~~> : MultiplicationPrecedence

// Creates a visit from `lhs` to `rhs.node` through `rhs.edge`.
func ~~> <E, N>(lhs: DirectedGraphRecordingVisitElement<E, N>, rhs: (edge: E, node: N)) -> DirectedGraphRecordingVisitElement<E, N> {
    .edge(rhs.edge, from: lhs, towards: rhs.node)
}

// Creates a visit from `.root(lhs)` to `rhs.node` through `rhs.edge`.
func ~~> <E, N>(lhs: N, rhs: (edge: E, node: N)) -> DirectedGraphRecordingVisitElement<E, N> {
    .edge(rhs.edge, from: .start(lhs), towards: rhs.node)
}

/// Creates edge from `lhs` to `rhs`.
///
/// Convenience for `TestEdge<Node>(start: lhs, end: rhs)`
func => <Node> (lhs: Node, rhs: Node) -> TestEdge<Node> {
    .init(start: lhs, end: rhs)
}

/// Creates a pair of edges from `lhs` to `rhs`.
///
/// Convenience for `[TestGraph.Edge(start: rhs, end: lhs), TestGraph.Edge(start: lhs, end: rhs)]`
func <=> (lhs: TestGraph.Node, rhs: TestGraph.Node) -> [TestGraph.Edge] {
    [lhs => rhs, rhs => lhs]
}

/// Creates edge from `lhs` to `rhs`.
///
/// Convenience for `TestGraph.Edge(start: lhs, end: rhs)`
func => <T>(lhs: DirectedGraph<T>.Node, rhs: DirectedGraph<T>.Node) -> DirectedGraph<T>.Edge {
    .init(start: lhs, end: rhs)
}
