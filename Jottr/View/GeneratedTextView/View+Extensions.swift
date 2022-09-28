//
//  Extensions.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 9/21/22.
//

import Foundation
import SwiftUI

/*
 A custom extension to Binding so that I attach observing code directly to the binding rather than to the view – it lets me
 place the observer next to the thing it’s observing, rather than having lots of onChange() modifiers attached elsewhere in my
 view. by https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
 */
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
