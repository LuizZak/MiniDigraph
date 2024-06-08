import XCTest

@testable import MiniDigraph

class MutableDirectedGraphTypeTests: XCTestCase {
    func testClear() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        sut.addEdge(n1 => n2)

        sut.clear()

        XCTAssertTrue(sut.nodes.isEmpty)
        XCTAssertTrue(sut.edges.isEmpty)
    }

    func testSubgraph() {
        let sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(n1 => n1)
        sut.addEdge(n1 => n2)
        sut.addEdge(n1 => n3)
        sut.addEdge(n2 => n3)

        let result = sut.subgraph(of: [n1, n3])

        XCTAssertEqual(result.nodes, [n1, n3])
        XCTAssertEqual(result.edges, [
            n1 => n1,
            n1 => n3,
        ])
    }

    func testAddNodes() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n4 = sut.addNode(4)
        let nodes: [TestGraph.Node] = [
            n1, .init(value: 2), .init(value: 3),
        ]

        sut.addNodes(nodes)

        XCTAssertEqual(sut.nodes, Set(nodes + [n4]))
    }

    func testRemoveNodes() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = TestGraph.Node(value: 4)

        sut.removeNodes([n1, n3, n4])

        XCTAssertEqual(sut.nodes, [
            n2
        ])
    }

    func testRemoveNodes_removesEdges() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n3 => n4)
        sut.addEdge(n4 => n1)

        sut.removeNodes([n3])

        XCTAssertEqual(sut.nodes, [
            n1, n2, n4
        ])
        XCTAssertEqual(sut.edges, [
            n1 => n2,
            n4 => n1,
        ])
    }

    func testRemoveEntryEdges() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n1 => n2)
        sut.addEdge(n1 => n3)
        sut.addEdge(n2 => n3)
        sut.addEdge(n3 => n4)

        sut.removeEntryEdges(towards: n3)

        XCTAssertEqual(sut.nodes, [
            n1, n2, n3, n4,
        ])
        XCTAssertEqual(sut.edges, [
            n1 => n2,
            n3 => n4,
        ])
    }

    func testRemoveExitEdges() {
        var sut = TestGraph()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n4)

        sut.removeExitEdges(from: n2)

        XCTAssertEqual(sut.nodes, [
            n1, n2, n3, n4,
        ])
        XCTAssertEqual(sut.edges, [
            n1 => n2,
            n3 => n4,
        ])
    }

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

        XCTAssertEqual(result, [
            n1 => n5,
            n2 => n5,
        ])
        XCTAssertEqual(sut.nodes, [
            n1, n2, n3, n4, n5,
        ])
        XCTAssertEqual(sut.edges, [
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

        XCTAssertEqual(result, [
            n0 => n3,
            n0 => n4,
        ])
        XCTAssertEqual(sut.nodes, [
            n0, n1, n2, n3, n4,
        ])
        XCTAssertEqual(sut.edges, [
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

extension TestGraph: MutableDirectedGraphType {
    func addNode(_ node: Node) {
        nodes.insert(node)
    }

    func removeNode(_ node: Node) {
        nodes.remove(node)
    }

    func removeEdge(_ edge: Edge) {
        edges.remove(edge)
    }

    @discardableResult
    func addEdge(_ edge: Edge) -> Edge {
        edges.insert(edge)
        return edge
    }

    @discardableResult
    func addEdge(from start: Node, to end: Node) -> Edge {
        addEdge(Edge(start: start, end: end))
    }
}
