//
//  MagnifyingGlass.swift
//  JottrDemo
//
//  Created by Kenneth Gutierrez on 10/11/22.
//

import SwiftUI

// a custom modifier
struct MagnifyingGlass: ViewModifier {
    @Binding var showingSearchScreen: Bool
    
    func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, alignment: .trailing) {
                ZStack {
                    Circle()
                        .fill(.white)
                        .frame(width: 45, height: 45)
                        .padding([.trailing], 25)
                    Button {
                        showingSearchScreen.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.original)
                            .font(.headline)
                            .padding([.trailing], 25)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Show Search")
                }
            }
    }
}

// extensions on View that make working with custom modifiers easier to use
extension View {
    func magnifyingGlass(show search: Binding<Bool>) -> some View {
        modifier(MagnifyingGlass(showingSearchScreen: search))
    }
}
