//  Copyright (c) 2024 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import protocol SwiftUI.View
import enum SwiftUI._VariadicView

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

