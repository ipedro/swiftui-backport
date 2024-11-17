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
import struct SwiftUI.ForEach
import struct SwiftUI.ViewBuilder

/// A view that creates a tree of subviews from an input view.
///
/// `MultiViewTree` provides a way to access and transform the subviews of a given
/// input view. You can use it to construct a structured view hierarchy or perform
/// operations on the subviews programmatically.
///
/// - Parameters:
///   - Input: The type of the input view.
///   - Output: The type of the transformed view.
///
public struct MultiViewTree<Input, Output>: View where Input: View, Output: View {
    private var _tree: _VariadicView.Tree<Root, Input>
    
    /// Creates a tree of subviews from a given view.
    ///
    /// This initializer allows you to define a hierarchical structure based on
    /// the subviews of the input view. You can use it to build a custom view tree
    /// by either transforming the collection of subviews or mapping each subview
    /// to a specific view.
    ///
    /// - Parameters:
    ///   - input: The input view whose subviews will be extracted.
    ///   - transform: A closure that constructs a view hierarchy from the
    ///     collection of subviews.
    ///
    /// # Examples
    ///
    /// ## Transform-Based
    ///
    /// ```swift
    /// MultiViewTree(subviews: SomeParentView()) { subviews in
    ///     VStack {
    ///         ForEach(subviews.indices, id: \.self) { index in
    ///             subviews[index]
    ///         }
    ///     }
    /// }
    /// ```
    /// ## Row-Based
    ///
    /// ```swift
    /// MultiViewTree(subviews: SomeParentView()) { subview in
    ///     Text("Subview ID: \(subview.id)")
    /// }
    /// ```
    public init(
        subviews input: Input,
        @ViewBuilder transform: @escaping (_ subviews: _Subviews) -> Output
    ) {
        _tree = .init(
            .init(body: transform),
            content: { input }
        )
    }
    
    public init<Row: View>(
        subviews input: Input,
        @ViewBuilder row: @escaping (_ subview: _Subview) -> Row
    ) where Output == ForEach<_Subviews, _Subview.ID, Row> {
        _tree = .init(
            .init(body: { .init($0, content: row) }),
            content: { input }
        )
    }
    
    public var body: some View {
        _tree
    }
    
    public struct Root: _VariadicView.MultiViewRoot {
        var body: (_Subviews) -> Output
        
        public func body(children: _VariadicView.Children) -> Output {
            body(_Subviews(children: children))
        }
    }
}
