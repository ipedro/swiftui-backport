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
import protocol Swift.Identifiable
import enum SwiftUI._VariadicView
import struct SwiftUI.ForEach

/// A proxy representation of a subview.
///
/// `_Subview` acts as a lightweight wrapper around an element of a variadic
/// view’s children. It provides identity and proxy access to the original view.
///
/// - Important: Modifications applied to `_Subview` only affect the view's proxy
///   and do not alter the original view.
///
/// - Properties:
///   - `id`: A unique identifier for the subview.
///   - `_element`: The underlying variadic view child.
///
/// - Conformance:
///   - `View`: `_Subview` is a SwiftUI view that can be embedded in a view hierarchy.
///   - `Identifiable`: Allows `_Subview` to be uniquely identified when used in collections.
public struct _Subview: View, Identifiable {
    public static func == (lhs: _Subview, rhs: _Subview) -> Bool {
        lhs._element.id == rhs._element.id
    }
    
    var _element: _VariadicView.Children.Element
    
    public var id: AnyHashable {
        _element.id
    }
    
    public var body: some View {
        _element
    }
    
    public func id<ID: Hashable>(as _: ID.Type = ID.self) -> ID? {
        _element.id(as: ID.self)
    }
}

#if hasAttribute(retroactive)
extension Slice: @retroactive View where Element == _Subview, Index: SignedInteger, Base.Index.Stride: SignedInteger {
    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#else
extension Slice: View where Element == _Subview, Index: SignedInteger, Base.Index.Stride: SignedInteger {
    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#endif
