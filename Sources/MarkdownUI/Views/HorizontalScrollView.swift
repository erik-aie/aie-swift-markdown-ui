//
//  HorizontalScrollView.swift
//  
//
//  Created by Erik Abramczyk on 7/15/24.
//

import SwiftUI
import Foundation

struct HorizontalScrollView<Content: View>: View {
    let content: Content
    @State private var offset: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                content
                    .offset(x: offset + dragOffset)
                    .background(
                        GeometryReader { contentGeometry in
                            Color.clear.preference(key: ContentHeightPreferenceKey.self, value: contentGeometry.size.height)
                        }
                    )
//                    .gesture(
//                        DragGesture()
//                            .updating($dragOffset) { value, state, _ in
//                                state = value.translation.width
//                            }
//                            .onEnded { value in
//                                let scrollViewWidth = geometry.size.width
//                                let contentWidth = geometry.size.width // Adjust this if your content width is different
//                                let maxOffset = max(0, contentWidth - scrollViewWidth)
//                                
//                                offset = max(min(offset + value.translation.width, 0), -maxOffset)
//                            }
//                    )
            }
            .frame(height: contentHeight)
            .fixedSize(horizontal: false, vertical: true)
//            .simultaneousGesture(
//                DragGesture(coordinateSpace: .local)
//                    .onChanged { _ in }
//            )
        }
        .frame(height: contentHeight)
        .onPreferenceChange(ContentHeightPreferenceKey.self) { height in
            self.contentHeight = height
        }
    }
}


struct ContentHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
