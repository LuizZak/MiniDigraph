# MiniDigraph

A teeny-tiny-weeny directed graph library written in Swift available as a Swift Package.

Mostly used as a dependency by my other OSS projects.

Sample usage:

```swift
var graph = DirectedGraph<String>()
graph.addNodes(["start", "node 1", "node 2", "node 3", "node 4"])

graph.addEdge(from: "start", to: "node 1")
graph.addEdge(from: "node 1", to: "node 2")
graph.addEdge(from: "node 2", to: "node 3")
graph.addEdge(from: "node 2", to: "node 4")
graph.addEdge(from: "node 4", to: "node 2")

let result = graph.stronglyConnectedComponents()

print(result)
```

prints:

```dot
[Set(["node 3"]), Set(["node 4", "node 2"]), Set(["node 1"]), Set(["start"])]
```
