import XCTest

@testable import MiniDigraph

class DirectedGraphTests: XCTestCase {
    func testAllEdgesForNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        let e1 = sut.addEdge(n1 => n2)
        let e2 = sut.addEdge(n1 => n3)

        let result = sut.allEdges(for: n1)

        XCTAssertEqual(result, [e1, e2])
    }

    func testNodesConnectedFromNode() {
        let sut = makeSut()
        let n1 = sut.addNode(0)
        let n2 = sut.addNode(1)
        let n3 = sut.addNode(2)
        sut.addEdge(n1 => n2)
        sut.addEdge(n1 => n3)

        let result = sut.nodesConnected(from: n1)

        XCTAssertEqual(result, [n2, n3])
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

        XCTAssertEqual(result, [n1, n3])
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
}

extension TestGraph: DirectedGraphType {
    func startNode(for edge: Edge) -> Node {
        edge.start
    }

    func endNode(for edge: Edge) -> Node {
        edge.end
    }

    func edges(from node: Node) -> Set<Edge> {
        edges.filter { $0.start == node }
    }

    func edges(towards node: Node) -> Set<Edge> {
        edges.filter { $0.end == node }
    }

    func edge(from start: Node, to end: Node) -> Edge? {
        edges.first { $0.start == start && $0.end == end }
    }
}
