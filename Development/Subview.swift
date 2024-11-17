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
