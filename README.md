# Backport for SwiftUI

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Platforms](https://img.shields.io/badge/platforms-iOS%2013%2B%20%7C%20macOS%2010.15%2B%20%7C%20tvOS%2013%2B%20%7C%20watchOS%206%2B%20%7C%20visionOS%201%2B-blue.svg)](https://developer.apple.com/swift/)
[![Swift Version](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org/download/)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)
[![Build Status](https://github.com/ipedro/swiftui-backport/actions/workflows/ci.yml/badge.svg)](https://github.com/ipedro/swiftui-backport/actions)
[![GitHub Stars](https://img.shields.io/github/stars/ipedro/swiftui-backport.svg)](https://github.com/ipedro/swiftui-backport/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/ipedro/swiftui-backport.svg)](https://github.com/ipedro/swiftui-backport/issues)
[![Twitter](https://img.shields.io/twitter/follow/ipedroalmeida.svg?style=social&label=Follow)](https://twitter.com/ipedroalmeida)

A lightweight Swift package that backports SwiftUI APIs to iOS versions earlier than latest (18). This allows developers to use newer APIs while maintaining compatibility with older iOS versions.

## Features

- Backports ForEach and Group initializers: Use the subview-based initializers on iOS versions earlier than 18.
- Programmatic access to subviews: Easily manipulate and transform subviews in your SwiftUI views.
- Lightweight and easy to integrate: Minimal code addition to your project.

## Installation

### Swift Package Manager

#### Xcode Project**

You can add the package to your project using Swift Package Manager. In Xcode:

1. Go to File > Add Packages…
2. Enter the repository URL: https://github.com/ipedro/swiftui-backport.git
3. Choose the package and add it to your project.

#### Package.swift

If you’re developing a Swift package and want to add Subviews Backport as a dependency, modify your `Package.swift` file as follows:

1) Add the package to your dependencies array:

    ```swift
    dependencies: [
        .package(url: "https://github.com/ipedro/swiftui-backport.git", from: "1.0.0")
    ]
    ```

2) Add SwiftUIBackport to your target’s dependencies:

    ```swift
    targets: [
        .target(
            name: "YourPackage",
            dependencies: [
                .product(name: "SwiftUIBackport", package: "swiftui-backport")
            ]
        ),
        // Other targets...
    ]
    ```

## Usage

Import the package in your Swift file:

```swift
import SwiftUIBackport
```

### Backported ForEach Initializer

Use the ForEach(subviews:content:) initializer to iterate over the subviews of a given view.

```swift
ForEach(subviews: YourParentView()) { subview in
    // Customize each subview
    subview
}
```

### Backported Group Initializer

Use the Group(subviews:transform:) initializer to create a group from the subviews of a given view.

```swift
Group(subviews: YourParentView()) { subviews in
    VStack {
        ForEach(subviews) { subview in
            subview
        }
    }
}
```

## Examples

### Iterating Over Subviews with ForEach

```swift
struct ContentView: View {
    var body: some View {
        ForEach(subviews: HStack {
            Text("First")
            Text("Second")
            Text("Third")
        }) { subview in
            subview
                .font(.headline)
        }
    }
}
```

### Custom Layout with Group

```swift
struct CardsView: View {
    var body: some View {
        Group(subviews: VStack {
            Text("Card 1")
            Text("Card 2")
            Text("Card 3")
        }) { subviews in
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
        }
    }
}
```

### Customizing Subviews in a List

```swift
import SwiftUI
import SwiftUIBackport

struct CustomListView: View {
    var body: some View {
        Group(subviews: VStack {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
        }) { subviews in
            List {
                ForEach(subviews) { subview in
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(.blue)
                        subview
                            .font(.headline)
                    }
                }
            }
        }
    }
}
```

**Explanation:**

- Purpose: Display a list where each item is a customized version of the subviews.
- Usage: We use Group to access the subviews of a VStack and then construct a List where each subview is customized with additional views and modifiers.

### Custom Stack that Applies Modifiers to Subviews

```swift
import SwiftUI
import SwiftUIBackport

struct CustomStack<Content: View>: View {
    let content: Content
    let spacing: CGFloat
    let alignment: HorizontalAlignment

    init(spacing: CGFloat = 10, alignment: HorizontalAlignment = .center, @ViewBuilder content: () -> Content) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content()
    }

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            Group(subviews: content) { subview in
                subview
                    .padding()
                    .background(Color.yellow.opacity(0.3))
                    .cornerRadius(8)
            }
        }
    }
}

// Usage
struct CustomStackView: View {
    var body: some View {
        CustomStack(spacing: 20, alignment: .leading) {
            Text("First Item")
            Text("Second Item")
            Text("Third Item")
        }
        .padding()
    }
}
```

**Explanation:**

- Purpose: Apply the same set of modifiers to each subview.
- Usage: UnaryViewTree processes each subview individually, allowing us to apply modifiers directly.

### Adaptive Stack that Switches Between V/HStack

```swift
import SwiftUI
import SwiftUIBackport

struct AdaptiveStack<Content: View>: View {
    let content: Content
    let threshold: Int

    init(threshold: Int = 3, @ViewBuilder content: () -> Content) {
        self.threshold = threshold
        self.content = content()
    }

    var body: some View {
        Group(subviews: content) { subviews in
            if subviews.count <= threshold {
                HStack {
                    subviews
                }
            } else {
                VStack {
                    subviews
                }
            }
        }
    }
}

// Usage
struct AdaptiveStackExampleView: View {
    var body: some View {
        AdaptiveStack {
            Text("Item 1")
            Text("Item 2")
            Text("Item 3")
            Text("Item 4")
            Text("Item 5")
        }
        .padding()
    }
}
```

**Explanation:**

- Purpose: Create a custom stack that switches between HStack and VStack based on the number of subviews.
- Usage: The AdaptiveStack view takes a threshold parameter. If the number of subviews is less than or equal to the threshold, it uses an HStack; otherwise, it uses a VStack.
- Implementation:
- MultiViewTree: We use MultiViewTree to access the subviews of the provided content.
- Conditional Layout: In the closure, we check subviews.count and choose between HStack and VStack.
- Using subviews Directly: We pass subviews directly into the chosen stack without iterating over them.

**Example Usage:**

```swift
struct AdaptiveStackDemo: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Adaptive Stack with 2 Items:")
                .font(.headline)
            AdaptiveStack {
                Text("Item A")
                Text("Item B")
            }
            .border(Color.blue)

            Text("Adaptive Stack with 5 Items:")
                .font(.headline)
            AdaptiveStack {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
                Text("Item 4")
                Text("Item 5")
            }
            .border(Color.green)
        }
        .padding()
    }
}
```

**Explanation:**

- The first AdaptiveStack has two items and displays them in an HStack.
- The second AdaptiveStack has five items and displays them in a VStack.

### Conditionally Transforming Subviews

```swift
import SwiftUI
import SwiftUIBackport

struct ConditionalTransformationView: View {
    var body: some View {
        UnaryViewTree(subviews: VStack {
            Text("Title").font(.title)
            Divider()
            Text("Subtitle").font(.subheadline)
            Divider()
            Text("Body text goes here.").font(.body)
        }) { subview in
            if subview.body is Divider {
                subview
            } else {
                subview
                    .foregroundColor(.purple)
            }
        }
    }
}
```

**Explanation:**

- Purpose: Apply transformations based on the type of subview.
- Usage: In the closure, we check if the subview is a Divider and handle it differently from other subviews.

#### Customize Subviews

```swift
import SwiftUI
import SwiftUIBackport

struct CustomizedSubviewsExample: View {
    var body: some View {
        Group(subviews: HStack {
            Text("Apple")
            Text("Banana")
            Text("Cherry")
        }) { subviews in
            VStack(alignment: .leading) {
                ForEach(subviews.indices, id: \.self) { index in
                    HStack {
                        Text("\(index + 1).")
                            .bold()
                        subviews[index]
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
        }
    }
}
```

## How It Works

The package provides extensions to ForEach and Group that enable the use of subview-based initializers on older iOS versions. It leverages SwiftUI’s _VariadicView system to access and manipulate subviews programmatically.

### Key Components

- _Subview: A proxy representation of a subview, conforming to View and Identifiable.
- `_Subviews`: A collection of `_Subview` instances, conforming to RandomAccessCollection.
- `MultiViewTree`: A view that creates a tree of subviews from an input view.
- `UnaryViewTree`: A view that creates a tree of subviews from an input view.

## Compatibility

- iOS: 13.0+
- macOS: 10.15+
- tvOS: 13.0+
- watchOS: 6.0+

## Limitations

- Subviews are proxies to their resolved views, so modifiers applied to the original view take effect before modifiers applied to the subview.
- Subviews might represent views after styles have been applied; applying additional styles might not always have the desired effect.

## License

Copyright (c) 2024 Pedro Almeida

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by SwiftUI’s new subview APIs introduced in iOS 18.
- Thanks to the SwiftUI community for ongoing support and contributions.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any bugs, feature requests, or improvements.

## Contact

Created by [Pedro Almeida](https://twitter.com/ipedro). Feel free to reach out for any questions or feedback.

Note: This package is a backport and is not affiliated with or endorsed by Apple Inc.
