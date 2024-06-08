import XCTest

/// Used as a stub for code paths that indicate success.
func success() {}

/// Fails a test with a given message.
func fail(_ message: String, file: StaticString = #file, line: UInt = #line) {
    XCTFail(message, file: file, line: line)
}

/// Asserts that two collection of items contains the same set of `T` values the
/// same number of times.
func assertEqualUnordered<T>(
    _ lhs: some Collection<T>,
    _ rhs: some Collection<T>,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) where T: Equatable {

    assertEqualUnordered(
        lhs,
        rhs,
        compare: ==,
        message: message(),
        file: file,
        line: line
    )
}

/// Asserts that two collection of items contains the same set of `T` values the
/// same number of times.
func assertEqualUnordered<T>(
    _ lhs: some Collection<T>,
    _ rhs: some Collection<T>,
    compare: (T, T) -> Bool,
    message: @autoclosure () -> String = "",
    file: StaticString = #file,
    line: UInt = #line
) {

    if lhs.count != rhs.count {
        fail(
            "lhs.count != rhs.count (\(lhs.count) != \(rhs.count)) lhs: \(lhs) rhs: \(rhs) \(message())",
            file: file,
            line: line
        )
        return
    }

    let signal: (String) -> Void = {
        fail(
            "lhs != rhs (\(lhs) != \(rhs)) \($0)",
            file: file,
            line: line
        )
    }

    var remaining = Array(lhs)
    for item in rhs {
        if let nextIndex = remaining.firstIndex(where: { compare($0, item) }) {
            remaining.remove(at: nextIndex)
        } else {
            return signal(message())
        }
    }

    if !remaining.isEmpty {
        signal(message())
    }
}
