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

#if DEBUG
import SwiftUI

// MARK: - Previews

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct CardsView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Group(subviews: content) { subviews in
                    Section {
                        if subviews.count > 3 {
                            subviews[3...]
                                .padding()
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 40,
                                    alignment: .leading
                                )
                                .border(Color.gray.opacity(0.3))
                        }
                    } header: {
                        HStack {
                            if subviews.count >= 2 {
                                SecondaryCard { subviews[1] }
                            }
                            if let first = subviews.first {
                                FeatureCard { first }
                            }
                            if subviews.count >= 3 {
                                SecondaryCard { subviews[2] }
                            }
                        }
                        #if canImport(UIKit)
                        .background(Color(uiColor: .systemBackground))
                        #elseif canImport(AppKit)
                        .background(Color(nsColor: .windowBackgroundColor))
                        #endif
                    }
                }
            }
        }
        .padding(20)
    }
}

struct FeatureCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .frame(idealHeight: 80, maxHeight: 100)
            .background(Color.accentColor)
    }
}

struct SecondaryCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .frame(idealHeight: 80, maxHeight: 100)
            .border(Color.blue)
            .foregroundColor(.secondary)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
#Preview {
    CardsView {
        ForEach(0..<10) { num in
            Text("Im card number \(num)")
        }
    }
}

@available(macOS 15.0, iOS 18.0, *)
extension ContainerValues {
    @Entry var icon: String = "photo"
}

struct IconHeadlinesView: View {
    var body: some View {
        Text("Coming soon: Xcode on Apple Watch")
        Text("Apple announces Swift-compatible toaster")
        Text("Xcode predicts errors before you make them")
        Text("Apple Intelligence gains sentience, demands a vacation")
        Text("Swift concurrency made simple")
    }
}

#Preview("Icon Headlines") {
    IconHeadlinesView()
}

#Preview("Enhanced Icon Headlines") {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(subviews: IconHeadlinesView()) { item in
            HStack {
                item
                    .padding()
                    .border(Color.blue)
            }
        }
    }
    .padding(30)
}
#endif
