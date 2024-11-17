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
