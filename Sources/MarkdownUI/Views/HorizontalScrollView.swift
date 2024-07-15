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

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                content
                    .offset(x: offset + dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                let scrollViewWidth = geometry.size.width
                                let contentWidth = geometry.size.width // Adjust this if your content width is different
                                let maxOffset = max(0, contentWidth - scrollViewWidth)
                                
                                offset = max(min(offset + value.translation.width, 0), -maxOffset)
                            }
                    )
            }
            .scrollDisabled(true)
            .simultaneousGesture(
                DragGesture(coordinateSpace: .local)
                    .onChanged { _ in }
            )
        }
    }
}
