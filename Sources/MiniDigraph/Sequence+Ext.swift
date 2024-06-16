extension Sequence {
    @inlinable
    func count(where predicate: (Element) -> Bool) -> Int {
        var result = 0
        for element in self {
            if predicate(element) {
                result += 1
            }
        }
        return result
    }
}
