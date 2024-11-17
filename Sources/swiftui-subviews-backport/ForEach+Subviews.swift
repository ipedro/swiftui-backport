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
import struct SwiftUI.ViewBuilder
import struct SwiftUI.ForEach

@available(iOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in ForEach(subview: ...) init")
@available(macOS, introduced: 10.15, deprecated: 15.0, message: "Please use the built in ForEach(subview: ...) init")
@available(tvOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in ForEach(subview: ...) init")
@available(watchOS, introduced: 6.0, deprecated: 11.0, message: "Please use the built in ForEach(subview: ...) init")
@available(visionOS, introduced: 1.0, deprecated: 2.0, message: "Please use the built in ForEach(subview: ...) init")
extension ForEach {
    
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the subviews of a given view.
    ///
    /// Subviews are proxies to the resolved view they represent, meaning
    /// that modifiers applied to the original view will be applied before
    /// modifiers applied to the subview, and the view is resolved
    /// using the environment of its container, *not* the environment of the
    /// its subview proxy. Additionally, because subviews must represent a
    /// single leaf view, or container, a subview may represent a view after the
    /// application of styles. As such, attempting to apply a style to it may
    /// have no affect.
    ///
    /// - Parameters:
    ///   - view: The view to extract the subviews of.
    ///   - content: The view builder that creates views from subviews.
    @_alwaysEmitIntoClient
    public init<V: View, C: View>(
        subviews view: V,
        @ViewBuilder content: @escaping (_ subview: _Subview) -> C
    ) where Data == Range<Int>, ID == Int, Content == MultiViewTree<V, ForEach<_Subviews, _Subview.ID, C>> {
        self.init(0..<1) { _ in
            MultiViewTree(subviews: view, row: content)
        }
    }
}