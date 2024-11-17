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

/// A view that applies a unary transformation to subviews of a given view.
///
/// `UnaryViewTree` extracts subviews from an input view and transforms each one
/// using a provided closure. This is particularly useful for cases where
/// individual subviews require distinct processing.
///
/// - Parameters:
///   - Input: The type of the input view.
///   - Output: The type of the resulting view after transformation.
public struct UnaryViewTree<Input, Output>: View where Input: View, Output: View {
    private var _tree: _VariadicView.Tree<Root, Input>
    
    public init(
        subviews input: Input,
        @ViewBuilder transform: @escaping (_ subviews: _Subviews) -> Output
    ) {
        _tree = .init(Root(body: transform)) {
            input
        }
    }
    
    public init<V: View>(
        subviews input: Input,
        @ViewBuilder row: @escaping (_ subview: _Subview) -> V
    ) where Output == ForEach<_Subviews, _Subview.ID, V> {
        _tree = .init(Root(body: { subviews in
            ForEach<_Subviews, _Subview.ID, V>(subviews, content: row)
        })) {
            input
        }
    }
    
    public var body: some View {
        _tree
    }
    
    public struct Root: _VariadicView.UnaryViewRoot {
        var body: (_Subviews) -> Output
        
        public func body(children: _VariadicView.Children) -> Output {
            body(_Subviews(children: children))
        }
    }
}
