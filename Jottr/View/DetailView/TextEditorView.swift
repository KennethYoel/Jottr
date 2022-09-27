//
//  CustomEditorView.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/20/22.
//

import Foundation
import SwiftUI

/*
 Code sample for a TextEditor with Placeholder functionality from cs4alhaider at
 https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui
 */
struct TextEditorView: View {
    
    @Binding var title: String
    @Binding var text: String
    let placeholder: String
        
    var body: some View {
        VStack {
            TextField("Title", text: $title)
                .font(.custom("Futura", size: 17))
            ZStack(alignment: .leading) {
                if text.isEmpty {
                   VStack {
                        Text(placeholder)
                            .padding(.top, 10)
                            .padding(.leading, 6)
                            .opacity(0.7)
                       
                        Spacer()
                    }
                }
                
                VStack {
                    TextEditor(text: $text)
                        .frame(minHeight: 150, maxHeight: .infinity)
                        .opacity(text.isEmpty ? 0.85 : 1)
                    
                    Spacer()
                }
            }
        }
    }
}
