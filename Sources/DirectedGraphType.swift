public protocol AbstractDirectedGraphEdge: Hashable {
    associatedtype Node: Hashable
}

public protocol DirectedGraphType {
    associatedtype NodeCollection: Collection
        where NodeCollection.Element: Hashable

    associatedtype EdgeCollection: Collection
        where EdgeCollection.Element: Hashable

    typealias Node = NodeCollection.Element
    typealias Edge = EdgeCollection.Element

    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge

    func breadthFirstVisit(start: Node, _ visitor: (DirectedGraphRecordingVisitElement<Edge, Node>) -> Bool)
}

public extension DirectedGraphType {
    func breadthFirstVisit<VisitElement: DirectedGraphVisitElementType>(
        start: VisitElement
    ) where VisitElement.Node == Node, VisitElement.Edge == Edge {
        let visited: Set<Node> = []
        _=visited
    }

    @inlinable
    func breadthFirstVisit(start: Node, _ visitor: (DirectedGraphRecordingVisitElement<Edge, Node>) -> Bool) {
        breadthFirstVisit(start: DirectedGraphRecordingVisitElement<Edge, Node>.start(start))
    }
}

public protocol DirectedGraphVisitElementType: Hashable {
    associatedtype Node
    associatedtype Edge
}

public enum DirectedGraphVisitElement<Edge: Hashable, Node: Hashable>: DirectedGraphVisitElementType {
    case start(Node)
}

public enum DirectedGraphRecordingVisitElement<Edge: Hashable, Node: Hashable>: DirectedGraphVisitElementType {
    case start(Node)
}

//

public struct CachingDirectedGraph<Graph: DirectedGraphType>
    where
        Graph.Edge: AbstractDirectedGraphEdge,
        Graph.Edge.Node == Graph.NodeCollection.Element
{
    public init() {
    }
}

extension CachingDirectedGraph: DirectedGraphType {
    public typealias NodeCollection = Graph.NodeCollection
    public typealias EdgeCollection = Graph.EdgeCollection
}
