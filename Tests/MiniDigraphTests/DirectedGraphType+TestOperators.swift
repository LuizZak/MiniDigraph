import MiniDigraph

// Convenience operator for generating edges
infix operator => : MultiplicationPrecedence

// Convenience operator for generating visit elements
infix operator ~~> : MultiplicationPrecedence

// Creates a visit from `lhs` to `rhs.node` through `rhs.edge`.
func ~~> <E, N>(lhs: DirectedGraphVisitElement<E, N>, rhs: (edge: E, node: N)) -> DirectedGraphVisitElement<E, N> {
    .edge(rhs.edge, from: lhs, towards: rhs.node)
}

// Creates a visit from `.root(lhs)` to `rhs.node` through `rhs.edge`.
func ~~> <E, N>(lhs: N, rhs: (edge: E, node: N)) -> DirectedGraphVisitElement<E, N> {
    .edge(rhs.edge, from: .start(lhs), towards: rhs.node)
}

/// Creates edge from `lhs` to `rhs`.
///
/// Convenience for `TestGraph.Edge(start: lhs, end: rhs)`
func => (lhs: TestGraph.Node, rhs: TestGraph.Node) -> TestGraph.Edge {
    .init(start: lhs, end: rhs)
}
