import XCTest

@testable import MiniDigraph

class MutableSimpleEdgeDirectedGraphTypeTests: XCTestCase {
    func testRedirectEntries() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(n1 => n2)
        sut.addEdge(n1 => n3)
        sut.addEdge(n2 => n3)
        sut.addEdge(n3 => n4)

        let result = sut.redirectEntries(for: n3, to: n5)

        assertEqualUnordered(result, [
            n1 => n5,
            n2 => n5,
        ])
        assertEqualUnordered(sut.nodes, [
            n1, n2, n3, n4, n5,
        ])
        assertEqualUnordered(sut.edges, [
            n1 => n2,
            n1 => n5,
            n2 => n5,
            n3 => n4,
        ])
    }

    func testRedirectExits() {
        var sut = TestGraph()
        let n0 = sut.addNode(0)
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n4)

        let result = sut.redirectExits(for: n2, to: n0)

        assertEqualUnordered(result, [
            n0 => n3,
            n0 => n4,
        ])
        assertEqualUnordered(sut.nodes, [
            n0, n1, n2, n3, n4,
        ])
        assertEqualUnordered(sut.edges, [
            n0 => n3,
            n0 => n4,
            n1 => n2,
            n3 => n4,
        ])
    }

    func testPrependNode_existingNode() {
        var sut = TestGraph()
        let n0 = sut.addNode(0)
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n0 => n2)
        sut.addEdge(n1 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n3)
        sut.addEdge(n3 => n4)

        sut.prepend(n2, before: n3)

        XCTAssertEqual(sut.nodes, [
            n0, n1, n2, n3, n4,
        ])
        XCTAssertEqual(sut.edges, [
            n0 => n2,
            n1 => n2,
            n2 => n3,
            n3 => n2,
            n3 => n4,
        ])
    }

    func testPrependNode_newNode() {
        var sut = TestGraph()
        let n0 = sut.addNode(0)
        let n1 = sut.addNode(1)
        let n2 = TestGraph.Node(value: 2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n0 => n3)
        sut.addEdge(n1 => n3)
        sut.addEdge(n3 => n3)
        sut.addEdge(n3 => n4)

        sut.prepend(n2, before: n3)

        XCTAssertEqual(sut.nodes, [
            n0, n1, n2, n3, n4,
        ])
        XCTAssertEqual(sut.edges, [
            n0 => n2,
            n1 => n2,
            n2 => n3,
            n3 => n2,
            n3 => n4,
        ])
    }
}

extension TestGraph: MutableSimpleEdgeDirectedGraphType {

}
