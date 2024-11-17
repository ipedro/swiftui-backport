import enum SwiftUI._VariadicView
import struct SwiftUI.ForEach
import protocol SwiftUI.View
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
