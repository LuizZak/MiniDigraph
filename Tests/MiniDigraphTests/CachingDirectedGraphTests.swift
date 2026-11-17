import XCTest

@testable import MiniDigraph

class CachingDirectedGraphTests: XCTestCase {
    func testBreadthFirstVisit_sequential() {
        let sut = makeSut()
        let start = 0

        sut.breadthFirstVisit(start: DirectedGraphVisitElement.start(start)) { visit in
            return true
        }
    }

    func testBreadthFirstVisit_recording_sequential() {
        let sut = makeSut()
        let start = 0

        sut.breadthFirstVisit(start: start) { visit in
            return true
        }
    }
}

// MARK: - Test internals

private func makeSut() -> CachingDirectedGraph<TestIntGraph> {
    return .init(graph: .init())
}
