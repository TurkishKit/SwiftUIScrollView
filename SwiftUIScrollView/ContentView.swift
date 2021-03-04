//
//  ContentView.swift
//  SwiftUIScrollView
//
//  Created by Sinan Ulusan on 3.03.2021.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}


struct ScrollView<Content: View>: View {
    let axes: Axis.Set
    let showsIndicators: Bool
    let offsetChanged: (CGPoint) -> Void
    let content: Content

    init(
        axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.offsetChanged = offsetChanged
        self.content = content()
    }
    
    var body: some View {
        SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
            GeometryReader { geometry in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: geometry.frame(in: .named("scrollView")).origin
                )
            }.frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView(
                    axes: [.horizontal, .vertical],
                    showsIndicators: false,
                    offsetChanged: { print($0) }
                ) {
                    ForEach(0..<100) { i in
                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                    }
                }
        /*
        ScrollView {
            VStack(spacing: 20) {
               ForEach(0..<10) {
                   Text("Box \($0)")
                       .foregroundColor(.white)
                       .font(.largeTitle)
                       .frame(width: 200, height: 200)
                       .background(Color.blue)
               }
           }
        }
         *
        ScrollViewReader { scrollView in
            ScrollView(showsIndicators:false) {
              VStack(spacing: 20) {
                 Button("Aşağıya Kaydır") {
                     withAnimation {
                        scrollView.scrollTo(3, anchor: .center)
                     }
                 }
              ForEach(0..<10) { index in
                   Text("Box \(index)")
                       .id(index)
                       .foregroundColor(.white)
                       .font(.largeTitle)
                       .frame(width: 200, height: 200)
                       .background(Color.blue)
                 }
             }
          }
        }
        */
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
