//
//  HideSection.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/22/22.
//

import SwiftUI

struct HideSectionView: View {
    // MARK: Properties
    
    @Binding var isHidden: Bool
    
    var body: some View {
        Menu("...") {
            if !isHidden {
                Button {
                    isHidden.toggle()
                } label: {
                    Label("Collapse", systemImage: "rectangle.compress.vertical")
                }
            } else {
                Button {
                    isHidden.toggle()
                } label: {
                    Label("Expand", systemImage: "rectangle.expand.vertical")
                }
            }
        }
        .font(.system(.caption, design: .serif))
    }
}
