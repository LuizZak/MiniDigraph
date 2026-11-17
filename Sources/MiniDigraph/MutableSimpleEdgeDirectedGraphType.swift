/// A refinement of `MutableDirectedGraphType` for graphs that use simple edge
/// structures that are differentiated only by their start/end node information.
public protocol MutableSimpleEdgeDirectedGraphType: MutableDirectedGraphType where Edge: SimpleDirectedGraphEdge, Edge.Node == Node {
}

public extension MutableSimpleEdgeDirectedGraphType {
}
