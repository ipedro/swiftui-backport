import enum SwiftUI._VariadicView
import protocol SwiftUI.View

/// A collection of subview proxies.
///
/// `_Subviews` provides access to the children of a variadic view as a
/// `RandomAccessCollection` of `_Subview` elements. It enables programmatic
/// traversal and manipulation of subviews.
///
/// - Properties:
///  - `startIndex`: The starting index of the collection.
///  - `endIndex`: The ending index of the collection.
///  - `children`: The underlying variadic view children.
///
/// - Subscripts:
///   - Access an individual subview by its index.
///
/// - Conformance:
///   - `View`: `_Subviews` can be embedded in a SwiftUI view hierarchy.
///   - `RandomAccessCollection`: Enables efficient indexed access and iteration.
public struct _Subviews: View, RandomAccessCollection {
    public typealias Element = _Subview

    public struct Iterator: IteratorProtocol {
        private var base: IndexingIterator<_VariadicView.Children>

        init(children: _VariadicView.Children) {
            self.base = children.makeIterator()
        }

        public mutating func next() -> _Subview? {
            guard let nextElement = base.next() else {
                return nil
            }
            return _Subview(_element: nextElement)
        }
    }

    var children: _VariadicView.Children

    public var body: some View {
        children
    }

    public func makeIterator() -> Iterator {
        Iterator(children: children)
    }

    public var startIndex: Int {
        children.startIndex
    }

    public var endIndex: Int {
        children.endIndex
    }

    public subscript(position: Int) -> _Subview {
        _Subview(_element: children[position])
    }

    public func index(after index: Int) -> Int {
        children.index(after: index)
    }
}
