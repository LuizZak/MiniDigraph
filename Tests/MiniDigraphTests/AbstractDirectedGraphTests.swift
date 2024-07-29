import XCTest

@testable import MiniDigraph

class AbstractDirectedGraphTests: XCTestCase {
    func testAllEdgesForNode() {
        var sut = makeSut()
        sut.addNode(0)
        sut.addNode(1)
        sut.addNode(2)
        sut.addEdge(.init(start: 0, end: 1))
        sut.addEdge(.init(start: 1, end: 2))

        let result = sut.allEdges(for: 1)

        assertEqualUnordered(result, [
            .init(start: 0, end: 1),
            .init(start: 1, end: 2),
        ])
    }
}

// MARK: - Test internals

private func makeSut() -> AbstractDirectedGraph<Int, TestAbstractEdge> {
    return AbstractDirectedGraph()
}

private struct TestAbstractEdge: AbstractDirectedGraphEdge {
    var start: Int
    var end: Int
}
