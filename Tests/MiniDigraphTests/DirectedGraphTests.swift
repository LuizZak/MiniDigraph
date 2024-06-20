import XCTest

@testable import MiniDigraph

class DirectedGraphTests: XCTestCase {
    func testAllEdgesForNode() {
        var sut = makeSut()
        sut.addNode(0)
        sut.addNode(1)
        sut.addNode(2)
        sut.addEdge(0 => 1)
        sut.addEdge(1 => 2)

        let result = sut.allEdges(for: 1)

        XCTAssertEqual(result, [0 => 1, 1 => 2])
    }

    func testStronglyConnectedSubgraph() {
        // 1 --> 2 --> 3 <-> 4
        // ^  _/ v     v    ^ v
        // 5 --> 6 <-> 7 <-- 8 -> 9
        var sut = makeSut()
        sut.addNodes([1, 2, 3, 4, 5, 6, 7, 8, 9])
        sut.addEdges([
            1 => 2,
            2 => 3, 2 => 5,
            3 => 4, 3 => 7,
            4 => 3, 4 => 8,
            5 => 1, 5 => 6,
            6 => 7,
            7 => 6,
            8 => 4, 8 => 7, 8 => 9
        ])

        let result = sut.stronglyConnectedSubgraph { component in
            component.sorted().map(\.description).joined(separator: ", ")
        }
        let group1 = "1, 2, 5"
        let group2 = "6, 7"
        let group3 = "3, 4, 8"
        let group4 = "9"

        XCTAssertEqual(result.nodes, [
            group1,
            group2,
            group3,
            group4,
        ])
        XCTAssertEqual(result.edges, [
            group1 => group2,
            group1 => group3,
            group3 => group2,
            group3 => group4,
        ])
    }
}

// MARK: - Test internals

private func makeSut() -> DirectedGraph<Int> {
    return DirectedGraph()
}
