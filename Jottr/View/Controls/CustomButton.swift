//
//  CustomButton.swift
//  Jottr
//
//  Created by Kenneth Gutierrez on 10/21/22.
//

import Foundation
import SwiftUI

struct CustomButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
