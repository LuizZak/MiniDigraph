import XCTest

@testable import MiniDigraph

class CachingDirectedGraphTests: XCTestCase {
    func testAddNode() {
        var sut = makeSut()

        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(1)

        XCTAssertEqual(sut.nodes, [
            1, 2,
        ])
    }

    func testAddNode_copyOnWrite() {
        var sut = makeSut()
        let copy = sut

        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(1)

        XCTAssertEqual(sut.nodes, [
            1, 2,
        ])
        XCTAssertEqual(copy.nodes, [])
    }

    func testRemoveNode() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)

        sut.removeNode(1)

        XCTAssertEqual(sut.nodes, [
            2,
        ])
    }

    func testRemoveNode_copyOnWrite() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        let copy = sut

        sut.removeNode(1)

        XCTAssertEqual(sut.nodes, [
            2,
        ])
        XCTAssertEqual(copy.nodes, [
            1, 2,
        ])
    }

    func testRemoveNode_removesReferences() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addEdge(1 => 2)
        sut.addEdge(2 => 3)

        sut.removeNode(2)

        XCTAssertEqual(sut.nodes, [
            1, 3,
        ])
        XCTAssertEqual(sut.edges, [])
        XCTAssertEqual(sut.edges(from: 1), [])
        XCTAssertEqual(sut.edges(towards: 2), [])
        XCTAssertEqual(sut.edges(from: 2), [])
        XCTAssertEqual(sut.edges(towards: 3), [])
    }

    func testRemoveNodes() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addNode(4)

        sut.removeNodes([2, 3])

        XCTAssertEqual(sut.nodes, [
            1, 4,
        ])
    }

    func testRemoveNodes_copyOnWrite() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addNode(4)
        let copy = sut

        sut.removeNodes([2, 3])

        XCTAssertEqual(sut.nodes, [
            1, 4,
        ])
        XCTAssertEqual(copy.nodes, [
            1, 2, 3, 4,
        ])
    }

    func testRemoveNodes_removesReferences() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addNode(4)
        sut.addEdge(1 => 2)
        sut.addEdge(2 => 3)
        sut.addEdge(3 => 4)

        sut.removeNodes([2, 3])

        XCTAssertEqual(sut.nodes, [
            1, 4,
        ])
        XCTAssertEqual(sut.edges, [])
        XCTAssertEqual(sut.edges(from: 1), [])
        XCTAssertEqual(sut.edges(towards: 1), [])
        XCTAssertEqual(sut.edges(from: 4), [])
        XCTAssertEqual(sut.edges(towards: 4), [])
    }

    func testAddEdge() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)

        sut.addEdge(1 => 2)

        XCTAssertEqual(sut.edges, [1 => 2])
        XCTAssertEqual(sut.edges(from: 1), [1 => 2])
        XCTAssertEqual(sut.edges(towards: 2), [1 => 2])
    }

    func testAddEdge_copyOnWrite() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        let copy = sut

        sut.addEdge(1 => 2)

        XCTAssertEqual(sut.edges, [1 => 2])
        XCTAssertEqual(sut.edges(from: 1), [1 => 2])
        XCTAssertEqual(sut.edges(towards: 2), [1 => 2])
        XCTAssertEqual(copy.edges, [])
    }

    func testAddEdge_repeated() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addEdge(1 => 2)
        sut.addEdge(2 => 3)

        sut.addEdge(1 => 2)

        XCTAssertEqual(sut.edges, [1 => 2, 2 => 3])
        XCTAssertEqual(sut.edges(from: 1), [1 => 2])
        XCTAssertEqual(sut.edges(towards: 2), [1 => 2])
        XCTAssertEqual(sut.edges(from: 2), [2 => 3])
        XCTAssertEqual(sut.edges(towards: 3), [2 => 3])
    }

    func testRemoveEdge() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addEdge(1 => 2)

        sut.removeEdge(1 => 2)

        XCTAssertEqual(sut.edges, [])
        XCTAssertEqual(sut.edges(from: 1), [])
        XCTAssertEqual(sut.edges(towards: 2), [])
    }

    func testRemoveEdge_copyOnWrite() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addEdge(1 => 2)
        let copy = sut

        sut.removeEdge(1 => 2)

        XCTAssertEqual(sut.edges, [])
        XCTAssertEqual(sut.edges(from: 1), [])
        XCTAssertEqual(sut.edges(towards: 2), [])
        XCTAssertEqual(copy.edges, [1 => 2])
    }

    // MARK: Performance tests

    func testPerformance_breadthFirstVisit_sequential() {
        let nodeCount = 10_000
        var sut = makeSut()
        let start = 0
        for n in 0..<nodeCount {
            sut.addNode(n)
        }
        for n in 0..<(nodeCount - 1) {
            sut.addEdge(from: n, to: n + 1)
        }

        sut.breadthFirstVisit(start: DirectedGraphVisitElement.start(start)) { visit in
            return true
        }
    }

    func testPerformance_depthFirstVisit_sequential() {
        let nodeCount = 10_000
        var sut = makeSut()
        let start = 0
        for n in 0..<nodeCount {
            sut.addNode(n)
        }
        for n in 0..<(nodeCount - 1) {
            sut.addEdge(from: n, to: n + 1)
        }

        sut.depthFirstVisit(start: DirectedGraphVisitElement.start(start)) { visit in
            return true
        }
    }

    func testPerformance_removeNodes_sequential() {
        let nodeCount = 10_000
        var sut = makeSut()
        for n in 0..<nodeCount {
            sut.addNode(n)
        }
        for n in 0..<(nodeCount - 1) {
            sut.addEdge(from: n, to: n + 1)
        }
        let nodesToRemove = stride(from: 0, to: nodeCount, by: 2)

        sut.removeNodes(nodesToRemove)

        XCTAssertEqual(sut.edges, [])
        XCTAssertTrue(sut._object.edgesFromNode.allSatisfy({ $0.value.isEmpty }))
        XCTAssertTrue(sut._object.edgesTowardsNode.allSatisfy({ $0.value.isEmpty }))
    }

    func testPerformance_removeNodes_parallel() {
        let nodeCount = 10_000
        var sut = makeSut()
        for n in 0..<nodeCount {
            sut.addNode(n)
        }
        let pivot = nodeCount / 2
        for n in 0..<pivot {
            sut.addEdge(from: n, to: pivot)
        }
        for n in (pivot + 1)..<nodeCount {
            sut.addEdge(from: pivot, to: n)
        }
        let nodesToRemove = [pivot]

        sut.removeNodes(nodesToRemove)

        XCTAssertEqual(sut.edges, [])
        XCTAssertTrue(sut._object.edgesFromNode.allSatisfy({ $0.value.isEmpty }))
        XCTAssertTrue(sut._object.edgesTowardsNode.allSatisfy({ $0.value.isEmpty }))
    }
}

// MARK: - Test internals

private func makeSut() -> CachingDirectedGraph<Int, TestEdge<Int>> {
    return .init()
}
