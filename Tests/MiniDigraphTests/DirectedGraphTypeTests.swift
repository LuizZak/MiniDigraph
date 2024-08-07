import XCTest

@testable import MiniDigraph

class DirectedGraphTypeTests: XCTestCase {
    func testAllEdgesForNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        let e1 = sut.addEdge(n1 => n2)
        let e2 = sut.addEdge(n1 => n3)

        let result = sut.allEdges(for: n1)

        assertEqualUnordered(result, [e1, e2])
    }

    func testNodesConnectedFromNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(n1 => n2)
        sut.addEdge(n1 => n3)

        let result = sut.nodesConnected(from: n1)

        assertEqualUnordered(result, [n2, n3])
    }

    func testNodesConnectedTowardsNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)

        let result = sut.nodesConnected(towards: n2)

        XCTAssertEqual(result, [n1])
    }

    func testAllNodesConnectedToNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)

        let result = sut.allNodesConnected(to: n2)

        assertEqualUnordered(result, [n1, n3])
    }

    func testIndegree() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n1 => n3)

        XCTAssertEqual(sut.indegree(of: n1), 0)
        XCTAssertEqual(sut.indegree(of: n2), 1)
        XCTAssertEqual(sut.indegree(of: n3), 2)
    }

    func testOutdegree() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n1 => n3)

        XCTAssertEqual(sut.outdegree(of: n1), 2)
        XCTAssertEqual(sut.outdegree(of: n2), 1)
        XCTAssertEqual(sut.outdegree(of: n3), 0)
    }

    func testDepthFirstVisit() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        let n6 = sut.addNode(6)
        let e0 = sut.addEdge(n1 => n2)
        let e1 = sut.addEdge(n2 => n3)
        let e2 = sut.addEdge(n2 => n4)
        let e3 = sut.addEdge(n4 => n5)
        let e4 = sut.addEdge(n1 => n6)

        assertVisit(
            sut,
            start: n1,
            visitMethod: sut.depthFirstVisit,
            expected: [
                .start(n1),
                n1 ~~> (e0, n2),
                n1 ~~> (e0, n2) ~~> (e1, n3),
                n1 ~~> (e0, n2) ~~> (e2, n4),
                n1 ~~> (e0, n2) ~~> (e2, n4) ~~> (e3, n5),
                n1 ~~> (e4, n6),
            ]
        )
    }

    func testBreadthFirstVisit() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        let n6 = sut.addNode(6)
        let e0 = sut.addEdge(n1 => n2)
        let e1 = sut.addEdge(n2 => n3)
        let e2 = sut.addEdge(n2 => n4)
        let e3 = sut.addEdge(n4 => n5)
        let e4 = sut.addEdge(n1 => n6)

        assertVisit(
            sut,
            start: n1,
            visitMethod: sut.breadthFirstVisit,
            expected: [
                .start(n1),
                n1 ~~> (e0, n2),
                n1 ~~> (e4, n6),
                n1 ~~> (e0, n2) ~~> (e1, n3),
                n1 ~~> (e0, n2) ~~> (e2, n4),
                n1 ~~> (e0, n2) ~~> (e2, n4) ~~> (e3, n5),
            ]
        )
    }

    func testHasPath() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n3)
        sut.addEdge(n3 => n4)
        sut.addEdge(n4 => n5)

        XCTAssertTrue(sut.hasPath(from: n1, to: n2))
        XCTAssertTrue(sut.hasPath(from: n1, to: n5))
        XCTAssertTrue(sut.hasPath(from: n3, to: n3))
        XCTAssertTrue(sut.hasPath(from: n3, to: n5))
        XCTAssertFalse(sut.hasPath(from: n5, to: n1))
        XCTAssertFalse(sut.hasPath(from: n5, to: n3))
    }

    func testShortestPath() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n3)
        sut.addEdge(n3 => n4)
        sut.addEdge(n4 => n5)

        let result = sut.shortestPath(from: n1, to: n5)

        XCTAssertEqual(result, [
            n1, n2, n4, n5,
        ])
    }

    func testShortestDistance() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n3)
        sut.addEdge(n3 => n4)
        sut.addEdge(n4 => n5)

        let result = sut.shortestDistance(from: n1, to: n5)

        XCTAssertEqual(result, 3)
    }

    func testStronglyConnectedComponents_emptyGraph() {
        let sut = makeSut()

        let result = sut.stronglyConnectedComponents()

        XCTAssertEqual(result.count, 0)
    }

    func testStronglyConnectedComponents_singleNode() {
        let sut = makeSut()
        let node = sut.addNode(1)

        let result = sut.stronglyConnectedComponents()

        XCTAssertEqual(result, [[node]])
    }

    func testStronglyConnectedComponents_twoNodes_notConnected() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)

        let result = sut.stronglyConnectedComponents()

        assertEqualUnordered(result, [[node1], [node2]])
    }

    func testStronglyConnectedComponents_twoNodes_connectedWeakly() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        sut.addEdge(node1 => node2)

        let result = sut.stronglyConnectedComponents()

        assertEqualUnordered(result, [[node1], [node2]])
    }

    func testStronglyConnectedComponents_twoNodes_connectedStrongly() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        sut.addMutualEdges(from: node1, to: node2)

        let result = sut.stronglyConnectedComponents()

        XCTAssertEqual(result, [[node1, node2]])
    }

    func testStronglyConnectedComponents_fourNodes() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        let node3 = sut.addNode(3)
        let node4 = sut.addNode(4)
        sut.addMutualEdges(from: node1, to: node2)
        sut.addEdge(node1 => node3)
        sut.addMutualEdges(from: node3, to: node4)

        let result = sut.stronglyConnectedComponents()

        XCTAssertEqual(result, [[node3, node4], [node1, node2]])
    }

    func testConnectedComponents() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        let node3 = sut.addNode(3)
        let node4 = sut.addNode(4)
        sut.addEdge(node1 => node2)
        sut.addEdge(node3 => node1)

        let result = sut.connectedComponents()

        XCTAssertEqual(result, [
            [node1, node2, node3],
            [node4],
        ])
    }

    func testConnectedComponents_withCycle() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let node2 = sut.addNode(2)
        let node3 = sut.addNode(3)
        let node4 = sut.addNode(4)
        sut.addEdge(node1 => node2)
        sut.addEdge(node2 => node3)
        sut.addEdge(node3 => node2)

        let result = sut.connectedComponents()

        XCTAssertEqual(result, [
            [node1, node2, node3],
            [node4],
        ])
    }

    func testConnectedComponents_withLargeCycle() {
        let sut = makeSut()
        let node1 = sut.addNode(1)
        let nodes = (2...100).map(sut.addNode)
        sut.addEdge(from: node1, to: nodes[0])
        _=zip(nodes, nodes.dropFirst()).map(sut.addEdge)
        sut.addEdge(from: nodes.last!, to: nodes[0])

        let result = sut.connectedComponents()

        XCTAssertEqual(result, [
            Set(nodes).union([node1]),
        ])
    }

    func testTopologicalSorted() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        let n4 = sut.addNode(4)
        let n5 = sut.addNode(5)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n2 => n4)
        sut.addEdge(n3 => n4)
        sut.addEdge(n4 => n5)

        let result = sut.topologicalSorted()

        XCTAssertEqual(result, [
            n1, n2, n3, n4, n5
        ])
    }

    func testTopologicalSorted_returnsNilForCyclicGraph() {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n3 => n1)

        let result = sut.topologicalSorted()

        XCTAssertNil(result)
    }

    func testTopologicalSortedBreakTiesWith() throws {
        let sut = makeSut()
        let range = (1..<100)
        _=range.map(sut.addNode)
        let node100 = sut.addNode(100)
        let node101 = sut.addNode(101)
        for node in sut.nodes where node.value < 100 {
            sut.addEdge(from: node, to: node100)
        }
        sut.addEdge(from: node100, to: node101)

        let result = try XCTUnwrap(sut.topologicalSorted(breakTiesWith: {
            $0.value < $1.value
        }))

        XCTAssertEqual(result.map(\.value), range + [100, 101])
    }

    func testTopologicalSortedBreakTiesWith_lexicographicalInteger() throws {
        // 5     7     3
        // |    /|    /|
        // v   / v   / |
        // 11 <  8 <   |
        // |\----|-    |
        // v \   | \   v
        // 2   > 9   > 10
        var sut = DirectedGraph<Int>()
        sut.addNodes([5, 7, 3, 11, 8, 2, 9, 10])
        sut.addEdge(5 => 11)
        sut.addEdge(7 => 8)
        sut.addEdge(7 => 11)
        sut.addEdge(3 => 8)
        sut.addEdge(3 => 10)
        sut.addEdge(11 => 2)
        sut.addEdge(11 => 9)
        sut.addEdge(11 => 10)
        sut.addEdge(8 => 9)

        let sorted = sut.topologicalSorted(breakTiesWith: <)

        XCTAssertEqual(sorted, [
            3, 5, 7, 8, 11, 2, 9, 10,
        ])
    }

    func testTopologicalSortedBreakTiesWith_graphWithCycles_returnsNil() throws {
        let sut = makeSut()
        let n1 = sut.addNode(1)
        let n2 = sut.addNode(2)
        let n3 = sut.addNode(3)
        sut.addEdge(n1 => n2)
        sut.addEdge(n2 => n3)
        sut.addEdge(n3 => n1)

        let result = sut.topologicalSorted(breakTiesWith: { $0.value < $1.value })

        XCTAssertNil(result)
    }

    func testTopologicalSortedBreakTiesWith_largeEdgeGraph() throws {
        typealias Node = TestGraph.Node

        // Arrange

        let sut = makeSut()
        // Make node columns
        let perColumn = 50
        let columns: [[Node]] = [
            sut.addNodes(values: (perColumn * 0)..<(perColumn * 1)),
            sut.addNodes(values: (perColumn * 1)..<(perColumn * 2)),
            sut.addNodes(values: (perColumn * 2)..<(perColumn * 3)),
        ]
        // Join columns
        for row0 in 0..<perColumn {
            let r0c0 = columns[0][row0]
            let r0c1 = columns[1][row0]

            for row1 in 0..<perColumn {
                let r1c1 = columns[1][row1]
                let r1c2 = columns[2][row1]

                sut.addEdge(from: r0c0, to: r1c1)
                sut.addEdge(from: r0c1, to: r1c2)
            }
        }

        // Act

        let result = try XCTUnwrap(sut.topologicalSorted(breakTiesWith: {
            $0.value < $1.value
        }))

        // Assert

        XCTAssertEqual(result.map(\.value), columns.flatMap({ $0 }).map(\.value))
    }
}

// MARK: - Test internals

private func makeSut() -> TestGraph {
    return TestGraph()
}

private func assertVisit(
    _ sut: TestGraph,
    start: TestGraph.Node,
    visitMethod: (TestGraph.Node, (TestGraph.VisitElement) -> Bool) -> Void,
    expected: [TestGraph.VisitElement],
    line: UInt = #line
) {
    var visits: [TestGraph.VisitElement] = []
    let _visit: (TestGraph.VisitElement) -> Bool = {
        visits.append($0)
        return true
    }

    visitMethod(start, _visit)

    func _formatNode(_ node: TestGraph.Node) -> String {
        "node #\(node.value.description)"
    }

    func _formatVisit(_ visit: TestGraph.VisitElement) -> String {
        switch visit {
        case .start(let node):
            return _formatNode(node)
        case .edge(_, let from, let towards):
            return "\(_formatVisit(from)) -> \(_formatNode(towards))"
        }
    }

    func _formatVisits(_ visits: [TestGraph.VisitElement]) -> String {
        if visits.isEmpty {
            return ""
        }

        return """
        [
            \(visits.enumerated().map { "\($0): \(_formatVisit($1))" }.joined(separator: "\n  "))
        ]
        """
    }

    assertEqualUnordered(
        expected,
        visits,
        file: #file,
        line: line
    )
}

extension TestGraph: DirectedGraphType {
    func startNode(for edge: Edge) -> Node {
        edge.start
    }

    func endNode(for edge: Edge) -> Node {
        edge.end
    }

    func edges(from node: Node) -> [Edge] {
        edges.filter { $0.start == node }
    }

    func edges(towards node: Node) -> [Edge] {
        edges.filter { $0.end == node }
    }

    func edges(from start: Node, to end: Node) -> [Edge] {
        edges.filter { $0.start == start && $0.end == end }
    }
}
