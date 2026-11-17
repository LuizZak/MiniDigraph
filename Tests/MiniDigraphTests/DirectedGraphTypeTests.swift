import XCTest

import MiniDigraph

class CachingDirectedGraphTests: XCTestCase {
    func testBreadthFirstVisit_sequential() {
        let sut = CachingDirectedGraph<TestIntGraph>()
        let start = 0

        sut.breadthFirstVisit(start: DirectedGraphVisitElement.start(start))
    }

    func testBreadthFirstVisit_recording_sequential_crasher() {
        let sut = CachingDirectedGraph<TestIntGraph>()
        let start = 0

        sut.breadthFirstVisit(start: start) { visit in
            return true
        }
    }
}

struct TestIntGraph: DirectedGraphType {
    typealias NodeCollection = Set<Int>
    typealias EdgeCollection = Set<TestEdge<Int>>
}
struct TestEdge<Node: Hashable>: AbstractDirectedGraphEdge {
}
