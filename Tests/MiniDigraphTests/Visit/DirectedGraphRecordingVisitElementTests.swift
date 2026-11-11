import XCTest

@testable import MiniDigraph

class DirectedGraphRecordingVisitElementTests: XCTestCase {
    typealias Sut = DirectedGraphRecordingVisitElement<DirectedGraph<Int>.Edge, Int>

    func testNode() {
        let sut = makeSut(count: 3)

        XCTAssertEqual(sut.node, 3)
    }

    func testEdge() {
        let sut = makeSut(count: 3)

        XCTAssertEqual(sut.edge, 2 => 3)
    }

    func testAllEdges() {
        let sut = makeSut(count: 3)

        XCTAssertEqual(sut.allEdges, [
            1 => 2,
            2 => 3,
        ])
    }

    func testAllNodes() {
        let sut = makeSut(count: 3)

        XCTAssertEqual(sut.allNodes, [
            1, 2, 3
        ])
    }

    func testLength_start() {
        let sut = Sut.start(1)

        XCTAssertEqual(sut.length, 1)
    }

    func testLength_edge() {
        let sut = Sut.edge(1 => 2, from: .start(1), towards: 2).appendingVisit(2 => 3, towards: 3)

        XCTAssertEqual(sut.length, 3)
    }

    func testContainsNode() {
        let sut = Sut.edge(1 => 2, from: .start(1), towards: 2).appendingVisit(2 => 3, towards: 3)

        XCTAssertTrue(sut.containsNode(1))
        XCTAssertTrue(sut.containsNode(2))
        XCTAssertTrue(sut.containsNode(3))
        XCTAssertFalse(sut.containsNode(0))
        XCTAssertFalse(sut.containsNode(4))
    }

    func testContainsEdge() {
        let sut = Sut.edge(1 => 2, from: .start(1), towards: 2).appendingVisit(2 => 3, towards: 3)

        XCTAssertTrue(sut.containsEdge(1 => 2))
        XCTAssertTrue(sut.containsEdge(2 => 3))
        XCTAssertFalse(sut.containsEdge(0 => 1))
        XCTAssertFalse(sut.containsEdge(3 => 2))
    }

    func testAppendingVisit() {
        let sut1 = Sut.edge(1 => 2, from: .start(1), towards: 2).appendingVisit(2 => 3, towards: 3)
        let sut2 = Sut.edge(2 => 3, from: .edge(1 => 2, from: .start(1), towards: 2), towards: 3)

        XCTAssertEqual(sut1, sut2)
    }

    // MARK: - Test internals

    func testMakeSut() {
        var graph = DirectedGraph<Int>()
        graph.addNodes(1...4)
        graph.addEdge(from: 1, to: 2)
        graph.addEdge(from: 2, to: 3)
        graph.addEdge(from: 3, to: 4)

        var lastVisit = Sut.start(0)
        graph.breadthFirstVisit(start: 1) { visit in
            lastVisit = visit
            return true
        }

        XCTAssertEqual(lastVisit, makeSut(count: 4))
    }

    private func makeSut(count: Int = 10) -> Sut {
        var result = Sut.start(1)

        for i in 1..<count {
            result = result.appendingVisit(i => (i + 1), towards: i + 1)
        }

        return result
    }
}
