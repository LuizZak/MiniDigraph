import XCTest

@testable import MiniDigraph

class CachingDirectedGraphTests: XCTestCase {
    func testIndegree() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addEdge(1 => 2)
        sut.addEdge(2 => 3)

        XCTAssertEqual(sut.indegree(of: 1), 0)
        XCTAssertEqual(sut.indegree(of: 2), 1)
        XCTAssertEqual(sut.indegree(of: 3), 1)

        // Test that removal is appropriately cached
        sut.removeNode(2)

        XCTAssertEqual(sut.indegree(of: 1), 0)
        XCTAssertEqual(sut.indegree(of: 3), 0)
    }

    func testOutdegree() {
        var sut = makeSut()
        sut.addNode(1)
        sut.addNode(2)
        sut.addNode(3)
        sut.addEdge(1 => 2)
        sut.addEdge(2 => 3)

        XCTAssertEqual(sut.outdegree(of: 1), 1)
        XCTAssertEqual(sut.outdegree(of: 2), 1)
        XCTAssertEqual(sut.outdegree(of: 3), 0)

        // Test that removal is appropriately cached
        sut.removeNode(2)

        XCTAssertEqual(sut.outdegree(of: 1), 0)
        XCTAssertEqual(sut.outdegree(of: 3), 0)
    }

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

    func testStability_repeatedInsertions() {
        let ops = makeOperations([
            0,
            1,
            2,
            0 ==> 1,
            0,
            2 ==> 1,
            2,
            !0, !1, !2,
        ])

        assertOperations(ops)
    }

    func testStability_removal_nodesWithEdges() {
        let ops = makeOperations([
            0, 1, 2, 3, 4, 5,
            0 ==> 1,
            0 ==> 2,
            0 ==> 1,
            0,
            2 ==> 5,
            2,
            5 ==> 4,
            !2, !0, !1, !3, !4, !5,
        ])

        assertOperations(ops)
    }

    func testStability_randomOperations() {
        var random = SystemRandomNumberGenerator()
        let ops = makeRandomOperations(count: 5000, with: &random)

        let result = assertOperations(ops)

        // Assert contents are as expected
        for node in ops.nodes() {
            XCTAssertTrue(result.containsNode(node))
        }
        for edge in ops.edges() {
            XCTAssertTrue(result.containsEdge(edge))
        }
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
        XCTAssertTrue(sut.cache.edgesFromNode.allSatisfy({ $0.value.isEmpty }))
        XCTAssertTrue(sut.cache.edgesTowardsNode.allSatisfy({ $0.value.isEmpty }))
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
        XCTAssertTrue(sut.cache.edgesFromNode.allSatisfy({ $0.value.isEmpty }))
        XCTAssertTrue(sut.cache.edgesTowardsNode.allSatisfy({ $0.value.isEmpty }))
    }
}

// MARK: - Test internals

private func makeSut() -> CachingDirectedGraph<TestIntGraph> {
    return .init()
}

/// Helper for generating examinable sequences of graph operations.
///
/// `123`: Creates node with value '123'
///
/// `123 ==> 456`: Creates edge between nodes '123' and '456'
///
/// `!123`: Deletes node '123'
///
/// `!(123 ==> 456)`: Deletes edge between nodes '123' and '456'
private func makeOperations(_ ops: [GraphOperation]) -> [GraphOperation] {
    ops
}

private func makeRandomOperations(
    count: Int,
    with random: inout some RandomNumberGenerator
) -> [GraphOperation] {
    let nodeRange = 0...40
    var nodes: Set<Int> = []
    var edges: Set<TestIntGraph.Edge> = []

    var result: [GraphOperation] = []

    for _ in 0..<count {
        switch Int.random(in: 0...3, using: &random) {
        case 0: // Create node
            break // Leave to default fallback to create nodes

        case 1: // Create edge
            guard let start = nodes.randomElement(using: &random) else {
                break
            }
            guard let end = nodes.randomElement(using: &random) else {
                break
            }

            edges.insert(start => end)
            result.append(start ==> end)

            continue

        case 2: // Delete node
            guard let node = nodes.randomElement(using: &random) else {
                break
            }

            nodes.remove(node)
            edges = edges.filter { edge in
                edge.start != node && edge.end != node
            }
            result.append(.deleteNode(node))

            continue

        case 3: // Delete edge
            guard let edge = edges.randomElement(using: &random) else {
                break
            }

            edges.remove(edge)
            result.append(.deleteEdges(edge.start, edge.end))

            continue

        default:
            break
        }

        // Default fallback: Create random node

        let node = Int.random(in: nodeRange, using: &random)
        result.append(.createNode(node))

        nodes.insert(node)
    }

    return result
}

@discardableResult
private func assertOperations(
    _ ops: [GraphOperation],
    to graph: CachingDirectedGraph<TestIntGraph> = .init()
) -> CachingDirectedGraph<TestIntGraph> {
    var graph = graph
    var remaining = ops

    while !remaining.isEmpty {
        let next = remaining.removeFirst()

        next.apply(to: &graph)
    }

    return graph
}

private enum GraphOperation: ExpressibleByIntegerLiteral {
    case createNode(Int)
    case createEdge(Int, Int)
    case deleteNode(Int)
    case deleteEdges(Int, Int)

    init(integerLiteral value: Int) {
        self = .createNode(value)
    }

    func apply<Graph: MutableSimpleEdgeDirectedGraphType>(
        to graph: inout Graph
    ) where Graph.Node == Int {
        switch self {
        case .createNode(let value):
            graph.addNode(value)

        case .deleteNode(let value):
            graph.removeNode(value)

        case .createEdge(let start, let end):
            graph.addEdge(from: start, to: end)

        case .deleteEdges(let start, let end):
            graph.removeEdges(from: start, to: end)
        }
    }

    static prefix func ! (value: Self) -> Self {
        switch value {
        case .createNode(let value):
            return .deleteNode(value)

        case .deleteNode(let value):
            return .createNode(value)

        case .createEdge(let start, let end):
            return .deleteEdges(start, end)

        case .deleteEdges(let start, let end):
            return .createEdge(start, end)
        }
    }
}

infix operator ==>
private func ==> (lhs: Int, rhs: Int) -> GraphOperation {
    .createEdge(lhs, rhs)
}

private extension Sequence where Element == GraphOperation {
    /// Returns the nodes that where created and not removed by subsequent operations
    /// within this sequence of operations.
    func nodes() -> Set<Int> {
        var result: Set<Int> = []

        for op in self {
            switch op {
            case .createNode(let node):
                result.insert(node)

            case .deleteNode(let node):
                result.remove(node)

            default:
                break
            }
        }

        return result
    }

    /// Returns the edges that where created and not removed by subsequent operations
    /// within this sequence of operations.
    func edges() -> Set<TestEdge<Int>> {
        var result: Set<TestEdge<Int>> = []

        for op in self {
            switch op {
            case .createEdge(let start, let end):
                result.insert(
                    .init(start: start, end: end)
                )

            case .deleteNode(let node):
                result = result.filter { edge in
                    edge.start != node && edge.end != node
                }

            case .deleteEdges(let start, let end):
                result.remove(.init(start: start, end: end))

            default:
                break
            }
        }

        return result
    }
}
