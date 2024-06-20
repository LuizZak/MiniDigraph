/// Protocol for directed graph visit elements.
public protocol DirectedGraphVisitElementType: Hashable {
    associatedtype Node
    associatedtype Edge

    /// Gets the node associated with this visit element.
    var node: Node { get }

    /// Returns the result of appending a given visit to this visit element.
    func appendingVisit(_ edge: Edge, towards node: Node) -> Self
}
